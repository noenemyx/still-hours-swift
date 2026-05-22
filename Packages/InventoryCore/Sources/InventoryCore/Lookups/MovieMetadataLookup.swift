// MovieMetadataLookup.swift — InventoryCore/Lookups
// Copyright 2026 sunghun.ahn — Still Hours Sprint 1.10 MovieMetadataLookup
// Created: 2026-05-22
// LINT-IGNORE: Privacy — only api.themoviedb.org and www.omdbapi.com are called

import Foundation

// MARK: - MovieMetadataLookup

/// Resolves a movie title query or IMDb ID to ``MovieMetadata`` by querying external APIs.
///
/// Primary source defaults to TMDB; OMDb is the fallback. The order can be reversed
/// via `primary` at initialisation time.
///
/// **API key requirement**: TMDB v3 and OMDb both require a personal API key.
/// If no key is provided for the requested source the actor throws
/// ``LookupError/apiKeyMissing(_:)``. Manual entry is the v1.0 default path.
///
/// Privacy: only `api.themoviedb.org` and `www.omdbapi.com` are ever contacted.
/// Any URL whose host is outside this whitelist throws ``LookupError/unauthorizedHost(_:)``.
/// User-Agent is set to `StillHours/1.0` — no device identifiers included.
public actor MovieMetadataLookup {

    // MARK: Constants

    /// Hosts approved by scripts/check-privacy.sh for movie metadata lookup.
    private static let allowedHosts: Set<String> = [
        "api.themoviedb.org",
        "www.omdbapi.com"
    ]

    // MARK: Properties

    private let urlSession: URLSession
    private let tmdbAPIKey: String?
    private let omdbAPIKey: String?
    private let primary: MovieSource

    // MARK: Init

    public init(
        urlSession: URLSession = .shared,
        tmdbAPIKey: String? = nil,
        omdbAPIKey: String? = nil,
        primary: MovieSource = .tmdb
    ) {
        self.urlSession = urlSession
        self.tmdbAPIKey = tmdbAPIKey
        self.omdbAPIKey = omdbAPIKey
        self.primary = primary
    }

    // MARK: - Public API

    /// Resolves a free-form title query to ``MovieMetadata``.
    ///
    /// - Parameter query: Movie title string, e.g. "The Matrix".
    /// - Returns: Populated ``MovieMetadata`` from the first source that has a result.
    /// - Throws: ``LookupError/apiKeyMissing(_:)`` when no API key is configured,
    ///   or another ``LookupError`` on network failure or no result.
    public func lookup(query: String) async throws -> MovieMetadata {
        let trimmed = query.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { throw LookupError.notFound(query) }

        let secondary: MovieSource = (primary == .tmdb) ? .omdb : .tmdb

        do {
            return try await fetchByQuery(query: trimmed, from: primary)
        } catch LookupError.notFound, LookupError.malformedResponse {
            return try await fetchByQuery(query: trimmed, from: secondary)
        }
        // apiKeyMissing, networkUnavailable, rateLimited, unauthorizedHost propagate immediately.
    }

    /// Resolves a known IMDb ID directly to ``MovieMetadata``.
    ///
    /// - Parameter imdbID: IMDb identifier string, e.g. "tt0133093".
    /// - Returns: Populated ``MovieMetadata``.
    /// - Throws: ``LookupError/apiKeyMissing(_:)`` when no API key is configured,
    ///   or another ``LookupError`` on network failure or no result.
    public func lookup(imdbID: String) async throws -> MovieMetadata {
        let trimmed = imdbID.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { throw LookupError.notFound(imdbID) }

        let secondary: MovieSource = (primary == .tmdb) ? .omdb : .tmdb

        do {
            return try await fetchByIMDb(imdbID: trimmed, from: primary)
        } catch LookupError.notFound, LookupError.malformedResponse {
            return try await fetchByIMDb(imdbID: trimmed, from: secondary)
        }
    }

    // MARK: - Fetch Dispatchers

    private func fetchByQuery(query: String, from source: MovieSource) async throws -> MovieMetadata {
        switch source {
        case .tmdb: return try await fetchTMDBByQuery(query: query)
        case .omdb: return try await fetchOMDbByQuery(query: query)
        }
    }

    private func fetchByIMDb(imdbID: String, from source: MovieSource) async throws -> MovieMetadata {
        switch source {
        case .tmdb: return try await fetchTMDBByIMDb(imdbID: imdbID)
        case .omdb: return try await fetchOMDbByIMDb(imdbID: imdbID)
        }
    }

    // MARK: - Allowed-Host Guard

    private func checkedURL(_ url: URL) throws -> URL {
        guard let host = url.host, Self.allowedHosts.contains(host) else {
            throw LookupError.unauthorizedHost(url)
        }
        return url
    }

    // MARK: - API Key Guards

    private func requireTMDBKey() throws -> String {
        guard let key = tmdbAPIKey, !key.isEmpty else {
            throw LookupError.apiKeyMissing(.tmdb)
        }
        return key
    }

    private func requireOMDbKey() throws -> String {
        guard let key = omdbAPIKey, !key.isEmpty else {
            throw LookupError.apiKeyMissing(.omdb)
        }
        return key
    }

    // MARK: - TMDB

    private func fetchTMDBByQuery(query: String) async throws -> MovieMetadata {
        let key = try requireTMDBKey()
        let encoded = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? query
        let urlString = "https://api.themoviedb.org/3/search/movie?api_key=\(key)&query=\(encoded)&limit=1"
        let rawURL = URL(string: urlString)!
        let url = try checkedURL(rawURL)
        let data = try await sessionData(from: url)
        return try mapTMDBSearch(data: data, query: query)
    }

    private func fetchTMDBByIMDb(imdbID: String) async throws -> MovieMetadata {
        let key = try requireTMDBKey()
        // TMDB find endpoint resolves external IDs.
        let urlString = "https://api.themoviedb.org/3/find/\(imdbID)?api_key=\(key)&external_source=imdb_id"
        let rawURL = URL(string: urlString)!
        let url = try checkedURL(rawURL)
        let data = try await sessionData(from: url)
        return try mapTMDBFind(data: data, imdbID: imdbID)
    }

    private func mapTMDBSearch(data: Data, query: String) throws -> MovieMetadata {
        guard let root = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
              let results = root["results"] as? [[String: Any]],
              let first = results.first else {
            throw LookupError.notFound(query)
        }
        return try mapTMDBMovie(dict: first, imdbID: nil)
    }

    private func mapTMDBFind(data: Data, imdbID: String) throws -> MovieMetadata {
        guard let root = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
              let movieResults = root["movie_results"] as? [[String: Any]],
              let first = movieResults.first else {
            throw LookupError.notFound(imdbID)
        }
        return try mapTMDBMovie(dict: first, imdbID: imdbID)
    }

    private func mapTMDBMovie(dict: [String: Any], imdbID: String?) throws -> MovieMetadata {
        guard let title = dict["title"] as? String else {
            throw LookupError.malformedResponse(.tmdb)
        }

        let originalTitle = dict["original_title"] as? String

        let year: Int? = {
            guard let raw = dict["release_date"] as? String else { return nil }
            return Self.extractYear(from: raw)
        }()

        let tmdbID = dict["id"] as? Int

        // TMDB search/find does not return directors inline — credits require a
        // separate detail call which we omit in v1.0 to keep it single-request.
        let directors: [String] = []

        let runtime: Int? = dict["runtime"] as? Int

        // TMDB poster paths are relative (/abc.jpg) — we do not resolve the full
        // image base URL here to avoid an undisclosed host (image.tmdb.org) that
        // is not in the privacy whitelist.
        let posterURL: URL? = nil

        return MovieMetadata(
            title: title,
            originalTitle: originalTitle,
            year: year,
            directors: directors,
            runtime: runtime,
            posterURL: posterURL,
            tmdbID: tmdbID,
            imdbID: imdbID,
            source: .tmdb
        )
    }

    // MARK: - OMDb

    private func fetchOMDbByQuery(query: String) async throws -> MovieMetadata {
        let key = try requireOMDbKey()
        let encoded = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? query
        // LINT-IGNORE: Privacy — www.omdbapi.com is an approved host
        let urlString = "https://www.omdbapi.com/?apikey=\(key)&t=\(encoded)"
        let rawURL = URL(string: urlString)!
        let url = try checkedURL(rawURL)
        let data = try await sessionData(from: url)
        return try mapOMDb(data: data, query: query)
    }

    private func fetchOMDbByIMDb(imdbID: String) async throws -> MovieMetadata {
        let key = try requireOMDbKey()
        // LINT-IGNORE: Privacy — www.omdbapi.com is an approved host
        let urlString = "https://www.omdbapi.com/?apikey=\(key)&i=\(imdbID)"
        let rawURL = URL(string: urlString)!
        let url = try checkedURL(rawURL)
        let data = try await sessionData(from: url)
        return try mapOMDb(data: data, query: imdbID)
    }

    private func mapOMDb(data: Data, query: String) throws -> MovieMetadata {
        guard let root = try? JSONSerialization.jsonObject(with: data) as? [String: Any] else {
            throw LookupError.malformedResponse(.omdb)
        }

        // OMDb returns {"Response":"False","Error":"..."} on not-found.
        if let response = root["Response"] as? String, response == "False" {
            throw LookupError.notFound(query)
        }

        guard let title = root["Title"] as? String else {
            throw LookupError.malformedResponse(.omdb)
        }

        let originalTitle: String? = nil  // OMDb does not expose originalTitle separately.

        let year: Int? = {
            guard let raw = root["Year"] as? String else { return nil }
            return Self.extractYear(from: raw)
        }()

        let directors: [String] = {
            guard let raw = root["Director"] as? String, raw != "N/A" else { return [] }
            return raw.components(separatedBy: ", ").map { $0.trimmingCharacters(in: .whitespaces) }
        }()

        let runtime: Int? = {
            guard let raw = root["Runtime"] as? String, raw != "N/A" else { return nil }
            // "142 min" — extract leading digits.
            let digits = raw.prefix(while: { $0.isNumber })
            return Int(digits)
        }()

        let imdbID = root["imdbID"] as? String
        let tmdbID: Int? = nil  // OMDb does not return TMDB IDs.

        return MovieMetadata(
            title: title,
            originalTitle: originalTitle,
            year: year,
            directors: directors,
            runtime: runtime,
            posterURL: nil,  // OMDb poster URLs come from a non-whitelisted host.
            tmdbID: tmdbID,
            imdbID: imdbID,
            source: .omdb
        )
    }

    // MARK: - Year Extractor

    /// Pulls a 4-digit 19xx/20xx year out of a free-form date string.
    /// TMDB uses "2000-03-31"; OMDb uses "1999" or "1999–2003" for series.
    /// Scanning for a year token avoids the "March 4, 2014" → 4201 bug.
    static func extractYear(from raw: String) -> Int? {
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
