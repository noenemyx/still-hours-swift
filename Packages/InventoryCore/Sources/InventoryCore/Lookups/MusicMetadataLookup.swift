// MusicMetadataLookup.swift — InventoryCore/Lookups
// Copyright 2026 sunghun.ahn — Still Hours Sprint 1.9 MusicMetadataLookup
// Created: 2026-05-22
// LINT-IGNORE: Privacy — only musicbrainz.org and api.itunes.apple.com are called

import Foundation

// MARK: - MusicMetadataLookup

/// Resolves a music album query or barcode to ``MusicMetadata`` by querying external APIs.
///
/// Primary source defaults to MusicBrainz; iTunes Search API is the fallback.
/// The order can be reversed via `primary` at initialisation time.
///
/// Privacy: only `musicbrainz.org` and `api.itunes.apple.com` are ever contacted.
/// Any URL whose host is outside this whitelist throws ``LookupError/unauthorizedHost(_:)``.
/// User-Agent is set to `StillHours/1.0` — no device identifiers included.
///
/// MusicBrainz enforces a 1 req/sec rate limit. A 1-second delay is applied before
/// each MusicBrainz request to comply.
public actor MusicMetadataLookup {

    // MARK: Constants

    /// Hosts approved by scripts/check-privacy.sh for music metadata lookup.
    private static let allowedHosts: Set<String> = [
        "musicbrainz.org",
        "api.itunes.apple.com"
    ]

    // MARK: Properties

    private let urlSession: URLSession
    private let primary: MusicSource

    // MARK: Init

    public init(urlSession: URLSession = .shared, primary: MusicSource = .musicBrainz) {
        self.urlSession = urlSession
        self.primary = primary
    }

    // MARK: - Public API

    /// Resolves an "Artist - Album" query string to ``MusicMetadata``.
    ///
    /// - Parameter query: Free-form search string, e.g. "Radiohead - OK Computer".
    /// - Returns: Populated ``MusicMetadata`` from the first source that has a result.
    /// - Throws: ``LookupError`` on network failure or no result.
    public func lookup(query: String) async throws -> MusicMetadata {
        let trimmed = query.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { throw LookupError.notFound(query) }

        let secondary: MusicSource = (primary == .musicBrainz) ? .itunes : .musicBrainz

        do {
            return try await fetchByQuery(query: trimmed, from: primary)
        } catch LookupError.notFound, LookupError.malformedResponse {
            return try await fetchByQuery(query: trimmed, from: secondary)
        }
        // Other errors (networkUnavailable, rateLimited, unauthorizedHost) propagate immediately.
    }

    /// Resolves a UPC/EAN-13 barcode to ``MusicMetadata``.
    ///
    /// - Parameter barcode: UPC or EAN-13 digits (hyphens stripped automatically).
    /// - Returns: Populated ``MusicMetadata`` from the first source that has a result.
    /// - Throws: ``LookupError`` on network failure or no result.
    public func lookup(barcode: String) async throws -> MusicMetadata {
        let cleaned = barcode.replacingOccurrences(of: "-", with: "")
        guard !cleaned.isEmpty, cleaned.allSatisfy(\.isNumber) else {
            throw LookupError.notFound(barcode)
        }

        let secondary: MusicSource = (primary == .musicBrainz) ? .itunes : .musicBrainz

        do {
            return try await fetchByBarcode(barcode: cleaned, from: primary)
        } catch LookupError.notFound, LookupError.malformedResponse {
            return try await fetchByBarcode(barcode: cleaned, from: secondary)
        }
        // Other errors propagate immediately.
    }

    // MARK: - Fetch Dispatchers

    private func fetchByQuery(query: String, from source: MusicSource) async throws -> MusicMetadata {
        switch source {
        case .musicBrainz: return try await fetchMusicBrainzByQuery(query: query)
        case .itunes:      return try await fetchITunesByQuery(query: query)
        }
    }

    private func fetchByBarcode(barcode: String, from source: MusicSource) async throws -> MusicMetadata {
        switch source {
        case .musicBrainz: return try await fetchMusicBrainzByBarcode(barcode: barcode)
        case .itunes:      return try await fetchITunesByBarcode(barcode: barcode)
        }
    }

    // MARK: - Allowed-Host Guard

    private func checkedURL(_ url: URL) throws -> URL {
        guard let host = url.host, Self.allowedHosts.contains(host) else {
            throw LookupError.unauthorizedHost(url)
        }
        return url
    }

    // MARK: - MusicBrainz

    /// MusicBrainz requires ≤1 req/sec. Always delay 1s before calling.
    private func musicBrainzDelay() async {
        try? await Task.sleep(nanoseconds: 1_000_000_000)
    }

    private func fetchMusicBrainzByQuery(query: String) async throws -> MusicMetadata {
        await musicBrainzDelay()

        // Split "Artist - Album" if the separator is present; otherwise use full string for both.
        let parts = query.components(separatedBy: " - ")
        let (artistPart, releasePart): (String, String)
        if parts.count >= 2 {
            artistPart = parts[0].trimmingCharacters(in: .whitespaces)
            releasePart = parts[1...].joined(separator: " - ").trimmingCharacters(in: .whitespaces)
        } else {
            artistPart = query
            releasePart = query
        }

        // Percent-encode each component separately (no + for MusicBrainz Lucene syntax).
        let artistEncoded = artistPart.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? artistPart
        let releaseEncoded = releasePart.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? releasePart

        let urlString = "https://musicbrainz.org/ws/2/release?query=artist:\(artistEncoded)+release:\(releaseEncoded)&fmt=json&limit=1"
        let rawURL = URL(string: urlString)!
        let url = try checkedURL(rawURL)
        let data = try await sessionData(from: url)
        return try mapMusicBrainz(data: data, query: query)
    }

    private func fetchMusicBrainzByBarcode(barcode: String) async throws -> MusicMetadata {
        await musicBrainzDelay()

        let urlString = "https://musicbrainz.org/ws/2/release?query=barcode:\(barcode)&fmt=json&limit=1"
        let rawURL = URL(string: urlString)!
        let url = try checkedURL(rawURL)
        let data = try await sessionData(from: url)
        return try mapMusicBrainz(data: data, query: barcode)
    }

    private func mapMusicBrainz(data: Data, query: String) throws -> MusicMetadata {
        guard let root = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
              let releases = root["releases"] as? [[String: Any]],
              let first = releases.first else {
            throw LookupError.notFound(query)
        }

        guard let title = first["title"] as? String else {
            throw LookupError.malformedResponse(LookupSource.musicBrainz)
        }

        let mbid = first["id"] as? String

        let artists: [String] = {
            guard let credits = first["artist-credit"] as? [[String: Any]] else { return [] }
            return credits.compactMap { credit -> String? in
                guard let artist = credit["artist"] as? [String: Any] else { return nil }
                return artist["name"] as? String
            }
        }()

        let releaseYear: Int? = {
            guard let raw = first["date"] as? String else { return nil }
            return Self.extractYear(from: raw)
        }()

        let label: String? = {
            guard let labelInfo = first["label-info"] as? [[String: Any]],
                  let firstLabel = labelInfo.first,
                  let labelDict = firstLabel["label"] as? [String: Any] else { return nil }
            return labelDict["name"] as? String
        }()

        let trackCount: Int? = {
            guard let media = first["media"] as? [[String: Any]] else { return nil }
            return media.compactMap { $0["track-count"] as? Int }.reduce(0, +)
        }()

        return MusicMetadata(
            title: title,
            artists: artists,
            releaseYear: releaseYear,
            label: label,
            trackCount: trackCount,
            coverImageURL: nil,       // MusicBrainz cover art requires a separate API; omitted.
            mbid: mbid,
            itunesID: nil,
            source: .musicBrainz
        )
    }

    // MARK: - iTunes Search API

    private func fetchITunesByQuery(query: String) async throws -> MusicMetadata {
        let encoded = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? query
        let urlString = "https://api.itunes.apple.com/search?term=\(encoded)&entity=album&country=US&limit=1"
        let rawURL = URL(string: urlString)!
        let url = try checkedURL(rawURL)
        let data = try await sessionData(from: url)
        return try mapITunes(data: data, query: query)
    }

    private func fetchITunesByBarcode(barcode: String) async throws -> MusicMetadata {
        // iTunes Search has no barcode field; search the barcode string as a term.
        return try await fetchITunesByQuery(query: barcode)
    }

    private func mapITunes(data: Data, query: String) throws -> MusicMetadata {
        guard let root = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
              let resultCount = root["resultCount"] as? Int, resultCount > 0,
              let results = root["results"] as? [[String: Any]],
              let first = results.first else {
            throw LookupError.notFound(query)
        }

        guard let collectionName = first["collectionName"] as? String else {
            throw LookupError.malformedResponse(LookupSource.itunes)
        }

        let artists: [String] = {
            guard let name = first["artistName"] as? String else { return [] }
            return [name]
        }()

        let releaseYear: Int? = {
            guard let raw = first["releaseDate"] as? String else { return nil }
            // releaseDate is typically "2000-05-01T00:00:00Z" — extract 4-digit year.
            return Self.extractYear(from: raw)
        }()

        let trackCount = first["trackCount"] as? Int

        let coverImageURL: URL? = {
            guard let artworkStr = first["artworkUrl100"] as? String else { return nil }
            // LINT-IGNORE: Privacy — Swift string-replace literals, not an HTTP call
            // iTunes sometimes returns http:// — upgrade to https://.
            let httpsStr = artworkStr.replacingOccurrences(of: "http://", with: "https://")
            // Cover image is served from mzstatic.com — not in our whitelist; omit.
            // Only return a URL if it comes from an allowed host.
            guard httpsStr.hasPrefix("https://"),
                  let url = URL(string: httpsStr),
                  let host = url.host,
                  Self.allowedHosts.contains(host) else { return nil }
            return url
        }()

        let itunesID = first["collectionId"] as? Int

        return MusicMetadata(
            title: collectionName,
            artists: artists,
            releaseYear: releaseYear,
            label: nil,        // iTunes Search doesn't expose label in this endpoint.
            trackCount: trackCount,
            coverImageURL: coverImageURL,
            mbid: nil,
            itunesID: itunesID,
            source: .itunes
        )
    }

    // MARK: - Year Extractor

    /// Pulls a 4-digit 19xx/20xx year out of a free-form date string.
    /// MusicBrainz uses "2000", "2000-05", "2000-05-21"; iTunes uses ISO 8601.
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
