// BookMetadataLookup.swift — InventoryCore/Lookups
// Copyright 2026 sunghun.ahn — Still Hours Sprint 1.2 BookMetadataLookup
// Created: 2026-05-21
// LINT-IGNORE: Privacy — only openlibrary.org and www.googleapis.com are called

import Foundation

// MARK: - BookMetadataLookup

/// Resolves an ISBN to ``BookMetadata`` by querying external APIs.
///
/// Primary source defaults to Open Library; Google Books is the fallback.
/// The order can be reversed via `primary` at initialisation time.
///
/// Privacy: only `openlibrary.org` and `www.googleapis.com` are ever contacted.
/// Any URL whose host is outside this whitelist throws ``LookupError/unauthorizedHost(_:)``.
/// User-Agent is set to `StillHours/1.0` — no device identifiers included.
public actor BookMetadataLookup {

    // MARK: Constants

    /// Hosts approved by scripts/check-privacy.sh for book metadata lookup.
    private static let allowedHosts: Set<String> = [
        "openlibrary.org",
        "www.googleapis.com"
    ]

    // MARK: Properties

    private let urlSession: URLSession
    private let primary: LookupSource

    // MARK: Init

    public init(urlSession: URLSession = .shared, primary: LookupSource = .openLibrary) {
        self.urlSession = urlSession
        self.primary = primary
    }

    // MARK: - Public API

    /// Resolves an ISBN to ``BookMetadata``.
    ///
    /// - Parameter isbn: ISBN-10 or ISBN-13 string. Hyphens are stripped automatically.
    /// - Returns: Populated ``BookMetadata`` from the first source that has a result.
    /// - Throws: ``LookupError`` on invalid input, network failure, or no result.
    public func lookup(isbn: String) async throws -> BookMetadata {
        let cleaned = try validated(isbn: isbn)
        let secondary: LookupSource = (primary == .openLibrary) ? .googleBooks : .openLibrary

        do {
            return try await fetch(isbn: cleaned, from: primary)
        } catch LookupError.notFound, LookupError.malformedResponse {
            return try await fetch(isbn: cleaned, from: secondary)
        }
        // Other errors (networkUnavailable, rateLimited, unauthorizedHost) propagate immediately.
    }

    // MARK: - ISBN Validation

    private func validated(isbn: String) throws -> String {
        let stripped = isbn.replacingOccurrences(of: "-", with: "")
        guard !stripped.isEmpty else { throw LookupError.invalidISBN(isbn) }

        switch stripped.count {
        case 10:
            guard isValidISBN10(stripped) else { throw LookupError.invalidISBN(isbn) }
        case 13:
            guard isValidISBN13(stripped) else { throw LookupError.invalidISBN(isbn) }
        default:
            throw LookupError.invalidISBN(isbn)
        }
        return stripped
    }

    private func isValidISBN10(_ s: String) -> Bool {
        // Last character may be 'X' (= 10). All others must be digits.
        let chars = Array(s)
        for (i, c) in chars.enumerated() {
            if i == 9 {
                guard c.isNumber || c == "X" || c == "x" else { return false }
            } else {
                guard c.isNumber else { return false }
            }
        }
        return true
    }

    private func isValidISBN13(_ s: String) -> Bool {
        s.allSatisfy(\.isNumber)
    }

    // MARK: - Fetch Dispatcher

    private func fetch(isbn: String, from source: LookupSource) async throws -> BookMetadata {
        switch source {
        case .openLibrary: return try await fetchOpenLibrary(isbn: isbn)
        case .googleBooks:  return try await fetchGoogleBooks(isbn: isbn)
        }
    }

    // MARK: - Allowed-Host Guard

    private func checkedURL(_ url: URL) throws -> URL {
        guard let host = url.host, Self.allowedHosts.contains(host) else {
            throw LookupError.unauthorizedHost(url)
        }
        return url
    }

    // MARK: - Open Library

    private func fetchOpenLibrary(isbn: String) async throws -> BookMetadata {
        let rawURL = URL(string: "https://openlibrary.org/api/books?bibkeys=ISBN:\(isbn)&jscmd=data&format=json")!
        let url = try checkedURL(rawURL)
        let data = try await sessionData(from: url)

        guard let root = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
              let entry = root["ISBN:\(isbn)"] as? [String: Any] else {
            throw LookupError.notFound(isbn)
        }

        return try mapOpenLibrary(entry: entry, isbn: isbn)
    }

    private func mapOpenLibrary(entry: [String: Any], isbn: String) throws -> BookMetadata {
        guard let title = entry["title"] as? String else {
            throw LookupError.malformedResponse(.openLibrary)
        }

        let authors: [String] = {
            guard let arr = entry["authors"] as? [[String: Any]] else { return [] }
            return arr.compactMap { $0["name"] as? String }
        }()

        let publishedYear: Int? = {
            guard let raw = entry["publish_date"] as? String else { return nil }
            // "publish_date" can be "2003" or "January 1, 2003" or "March 4, 2014".
            // Concatenating all digits and taking the prefix mis-parses
            // "March 4, 2014" → "42014" → 4201. Instead match a 4-digit
            // 19xx/20xx year token explicitly.
            return Self.extractYear(from: raw)
        }()

        let publisher: String? = {
            guard let arr = entry["publishers"] as? [[String: Any]],
                  let first = arr.first,
                  let name = first["name"] as? String else { return nil }
            return name
        }()

        let pageCount: Int? = entry["number_of_pages"] as? Int

        let coverImageURL: URL? = {
            guard let covers = entry["cover"] as? [String: Any],
                  let largeStr = covers["large"] as? String ?? (covers["medium"] as? String),
                  largeStr.hasPrefix("https://"),
                  let url = URL(string: largeStr) else { return nil }
            return url
        }()

        // Determine isbn10 / isbn13 from identifiers block
        var isbn10: String?
        var isbn13: String?
        if let ids = entry["identifiers"] as? [String: Any] {
            if let arr = ids["isbn_10"] as? [String] { isbn10 = arr.first }
            if let arr = ids["isbn_13"] as? [String] { isbn13 = arr.first }
        }
        // Fallback: assign supplied isbn to whichever slot matches its length
        if isbn10 == nil && isbn13 == nil {
            if isbn.count == 10 { isbn10 = isbn } else { isbn13 = isbn }
        }

        return BookMetadata(
            title: title,
            authors: authors,
            publishedYear: publishedYear,
            publisher: publisher,
            pageCount: pageCount,
            coverImageURL: coverImageURL,
            isbn10: isbn10,
            isbn13: isbn13,
            source: .openLibrary
        )
    }

    // MARK: - Google Books

    private func fetchGoogleBooks(isbn: String) async throws -> BookMetadata {
        let rawURL = URL(string: "https://www.googleapis.com/books/v1/volumes?q=isbn:\(isbn)")!
        let url = try checkedURL(rawURL)
        let data = try await sessionData(from: url)

        guard let root = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
              let totalItems = root["totalItems"] as? Int, totalItems > 0,
              let items = root["items"] as? [[String: Any]],
              let first = items.first,
              let volumeInfo = first["volumeInfo"] as? [String: Any] else {
            throw LookupError.notFound(isbn)
        }

        return try mapGoogleBooks(volumeInfo: volumeInfo, isbn: isbn)
    }

    private func mapGoogleBooks(volumeInfo: [String: Any], isbn: String) throws -> BookMetadata {
        guard let title = volumeInfo["title"] as? String else {
            throw LookupError.malformedResponse(.googleBooks)
        }

        let authors = volumeInfo["authors"] as? [String] ?? []

        let publishedYear: Int? = {
            guard let raw = volumeInfo["publishedDate"] as? String else { return nil }
            // Same Open Library-style heterogeneous date safety — match a
            // 4-digit 19xx/20xx token instead of blindly taking prefix(4).
            return Self.extractYear(from: raw)
        }()

        let publisher = volumeInfo["publisher"] as? String
        let pageCount = volumeInfo["pageCount"] as? Int

        let coverImageURL: URL? = {
            guard let imageLinks = volumeInfo["imageLinks"] as? [String: Any],
                  let rawStr = imageLinks["thumbnail"] as? String else { return nil }
            // Google sometimes returns http:// — upgrade to https://
            let httpsStr = rawStr.replacingOccurrences(of: "http://", with: "https://")
            guard httpsStr.hasPrefix("https://"), let url = URL(string: httpsStr) else { return nil }
            return url
        }()

        var isbn10: String?
        var isbn13: String?
        if let identifiers = volumeInfo["industryIdentifiers"] as? [[String: Any]] {
            for id in identifiers {
                guard let type = id["type"] as? String, let value = id["identifier"] as? String else { continue }
                if type == "ISBN_10" { isbn10 = value }
                if type == "ISBN_13" { isbn13 = value }
            }
        }
        if isbn10 == nil && isbn13 == nil {
            if isbn.count == 10 { isbn10 = isbn } else { isbn13 = isbn }
        }

        return BookMetadata(
            title: title,
            authors: authors,
            publishedYear: publishedYear,
            publisher: publisher,
            pageCount: pageCount,
            coverImageURL: coverImageURL,
            isbn10: isbn10,
            isbn13: isbn13,
            source: .googleBooks
        )
    }

    // MARK: - Year Extractor

    /// Pulls a 4-digit 19xx/20xx year out of a free-form date string.
    /// Open Library returns dates in heterogeneous formats — sometimes just
    /// "2014", sometimes "March 4, 2014", sometimes "2014-03-04". Scanning
    /// for a year token avoids the "March 4, 2014" → 4201 bug from
    /// stripping non-digits and taking the prefix.
    static func extractYear(from raw: String) -> Int? {
        // Look for the first 4-char substring matching 19xx or 20xx.
        let characters = Array(raw)
        guard characters.count >= 4 else { return nil }
        for i in 0...(characters.count - 4) {
            let slice = characters[i..<(i + 4)]
            guard slice.allSatisfy(\.isNumber) else { continue }
            let candidate = String(slice)
            guard let year = Int(candidate), (1900...2099).contains(year) else { continue }
            return year
        }
        return nil
    }

    // MARK: - Session Helper

    private func sessionData(from url: URL) async throws -> Data {
        var request = URLRequest(url: url)
        request.setValue("StillHours/1.0", forHTTPHeaderField: "User-Agent")
        request.timeoutInterval = 2.0

        do {
            let (data, response) = try await urlSession.data(for: request)
            if let http = response as? HTTPURLResponse, http.statusCode == 429 {
                throw LookupError.rateLimited
            }
            return data
        } catch let error as LookupError {
            throw error
        } catch {
            throw LookupError.networkUnavailable
        }
    }
}
