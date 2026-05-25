// KOBISSearchProvider.swift — InventoryCore/Search/Providers
// Copyright 2026 sunghun.ahn — Own Your Curation
// Build #9b — KOBIS Movie Information Service API
// Created: 2026-05-25

import Foundation

/// Searches KOBIS (Korean Film Council) movie database.
/// Key passed as query parameter; no headers required.
/// Endpoint: https://kobis.or.kr/kobisopenapi/webservice/rest/movie/searchMovieList.json
public struct KOBISSearchProvider: SearchProvider, Sendable {

    public let source: SearchSource = .kobis
    public let medium: Medium = .movie

    private let certKey: String
    private let urlSession: URLSession

    public init(certKey: String, urlSession: URLSession = .shared) {
        self.certKey = certKey
        self.urlSession = urlSession
    }

    public func search(query: String, limit: Int) async throws -> [SearchResult] {
        guard let encoded = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
              let url = URL(string: "https://kobis.or.kr/kobisopenapi/webservice/rest/movie/searchMovieList.json?key=\(certKey)&movieNm=\(encoded)&itemPerPage=10")
        else { return [] }

        var request = URLRequest(url: url, timeoutInterval: 5)
        request.httpMethod = "GET"

        let (data, _) = try await urlSession.data(for: request)
        let response = try JSONDecoder().decode(KOBISResponse.self, from: data)

        return response.movieListResult.movieList.prefix(limit).map { movie in
            SearchResult(
                id: "kobis-\(movie.movieCd)",
                medium: .movie,
                title: movie.movieNm,
                creator: movie.directors.first?.peopleNm,
                year: Int(movie.prdtYear),
                coverURL: nil,
                externalID: movie.movieCd,
                source: .kobis,
                confidence: 0.95,
                publisher: movie.companys.first?.companyNm
            )
        }
    }
}

// MARK: - Private response types

private struct KOBISResponse: Decodable {
    let movieListResult: KOBISMovieListResult
}

private struct KOBISMovieListResult: Decodable {
    let movieList: [KOBISMovie]
}

private struct KOBISMovie: Decodable {
    let movieCd: String
    let movieNm: String
    let movieNmEn: String
    let prdtYear: String
    let directors: [KOBISDirector]
    let companys: [KOBISCompany]
}

private struct KOBISDirector: Decodable {
    let peopleNm: String
}

private struct KOBISCompany: Decodable {
    let companyNm: String
}
