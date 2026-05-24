// iTunesSearchProvider.swift — InventoryCore/Search/Providers
// Copyright 2026 sunghun.ahn — Own Your Curation
// Build #9b — iTunes Search API (no key required, public endpoint)
// Created: 2026-05-24

import Foundation

/// Searches iTunes Search API for albums. No API key required.
/// Endpoint: https://itunes.apple.com/search?term=<encoded>&entity=album&limit=10&country=kr&lang=ko_kr
public struct iTunesSearchProvider: SearchProvider, Sendable {

    public let source: SearchSource = .iTunes
    public let medium: Medium = .music

    private let urlSession: URLSession

    public init(urlSession: URLSession = .shared) {
        self.urlSession = urlSession
    }

    public func search(query: String, limit: Int) async throws -> [SearchResult] {
        guard let encoded = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
              let url = URL(string: "https://itunes.apple.com/search?term=\(encoded)&entity=album&limit=\(limit)&country=kr&lang=ko_kr")
        else { return [] }

        var request = URLRequest(url: url, timeoutInterval: 5)
        request.httpMethod = "GET"

        let (data, _) = try await urlSession.data(for: request)

        let response = try JSONDecoder().decode(iTunesResponse.self, from: data)
        return response.results.map { item in
            // FIXME: brittle — Apple may change artwork URL pattern (e.g. ".jpg" suffix variations). Consider regex parse when Build #9b ships.
            let artworkHD = item.artworkUrl100.map {
                $0.replacingOccurrences(of: "100x100bb", with: "600x600bb")
                  .replacingOccurrences(of: "100x100", with: "600x600")
            }
            return SearchResult(
                id: "itunes-\(item.collectionId)",
                medium: .music,
                title: item.collectionName,
                creator: item.artistName,
                year: item.releaseDate.flatMap { Int($0.prefix(4)) },
                coverURL: artworkHD.flatMap { URL(string: $0) },
                externalID: String(item.collectionId),
                source: .iTunes,
                confidence: 0.9
            )
        }
    }
}

// MARK: - Private response types

private struct iTunesResponse: Decodable {
    let resultCount: Int
    let results: [iTunesAlbum]
}

private struct iTunesAlbum: Decodable {
    let collectionId: Int
    let collectionName: String
    let artistName: String
    let releaseDate: String?
    let artworkUrl100: String?
}
