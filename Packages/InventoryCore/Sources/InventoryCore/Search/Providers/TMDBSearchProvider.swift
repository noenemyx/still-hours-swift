// TMDBSearchProvider.swift — InventoryCore/Search/Providers
// Copyright 2026 sunghun.ahn — Own Your Curation
// Build #9b — TMDB Movie Search API (v4 Bearer token)
// Created: 2026-05-25

import Foundation

/// Searches The Movie Database (TMDB) for movies.
/// Requires a v4 Read Access Token (Bearer auth).
/// Endpoint: https://api.themoviedb.org/3/search/movie
public struct TMDBSearchProvider: SearchProvider, Sendable {

    public let source: SearchSource = .tmdb
    public let medium: Medium = .movie

    private let bearerToken: String
    private let urlSession: URLSession

    public init(bearerToken: String, urlSession: URLSession = .shared) {
        self.bearerToken = bearerToken
        self.urlSession = urlSession
    }

    public func search(query: String, limit: Int) async throws -> [SearchResult] {
        guard let encoded = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
              let url = URL(string: "https://api.themoviedb.org/3/search/movie?query=\(encoded)&language=ko-KR")
        else { return [] }

        var request = URLRequest(url: url, timeoutInterval: 5)
        request.httpMethod = "GET"
        request.setValue("Bearer \(bearerToken)", forHTTPHeaderField: "Authorization")
        request.setValue("application/json", forHTTPHeaderField: "accept")

        let (data, _) = try await urlSession.data(for: request)
        let response = try JSONDecoder().decode(TMDBResponse.self, from: data)

        return response.results.prefix(limit).map { movie in
            let coverURL: URL? = movie.posterPath.flatMap {
                URL(string: "https://image.tmdb.org/t/p/w500\($0)")
            }
            return SearchResult(
                id: "tmdb-\(movie.id)",
                medium: .movie,
                title: movie.title,
                creator: nil,
                year: Int(movie.releaseDate?.prefix(4) ?? ""),
                coverURL: coverURL,
                externalID: String(movie.id),
                source: .tmdb,
                confidence: 0.85
            )
        }
    }
}

// MARK: - Private response types

private struct TMDBResponse: Decodable {
    let results: [TMDBMovie]
}

private struct TMDBMovie: Decodable {
    let id: Int
    let title: String
    let originalTitle: String
    let releaseDate: String?
    let posterPath: String?
    let overview: String

    enum CodingKeys: String, CodingKey {
        case id, title, overview
        case originalTitle = "original_title"
        case releaseDate = "release_date"
        case posterPath = "poster_path"
    }
}
