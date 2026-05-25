// NaverPlaceSearchProvider.swift — InventoryCore/Search/Providers
// Copyright 2026 sunghun.ahn — Own Your Curation
// Build #9b — Naver Local Search API
// Created: 2026-05-25

import Foundation

/// Searches Naver Local (Place) API. Shares credentials with NaverBookSearchProvider.
/// Endpoint: https://openapi.naver.com/v1/search/local.json
public struct NaverPlaceSearchProvider: SearchProvider, Sendable {

    public let source: SearchSource = .naverPlace
    public let medium: Medium = .place

    private let clientID: String
    private let clientSecret: String
    private let urlSession: URLSession

    public init(clientID: String, clientSecret: String, urlSession: URLSession = .shared) {
        self.clientID = clientID
        self.clientSecret = clientSecret
        self.urlSession = urlSession
    }

    public func search(query: String, limit: Int) async throws -> [SearchResult] {
        guard let encoded = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
              let url = URL(string: "https://openapi.naver.com/v1/search/local.json?query=\(encoded)&display=5")
        else { return [] }

        var request = URLRequest(url: url, timeoutInterval: 5)
        request.httpMethod = "GET"
        request.setValue(clientID, forHTTPHeaderField: "X-Naver-Client-Id")
        request.setValue(clientSecret, forHTTPHeaderField: "X-Naver-Client-Secret")

        let (data, _) = try await urlSession.data(for: request)
        let response = try JSONDecoder().decode(NaverLocalResponse.self, from: data)

        return response.items.prefix(limit).map { item in
            let title = stripHTML(item.title)
            let externalID = "\(item.mapx),\(item.mapy)"
            return SearchResult(
                id: "naver-place-\(item.mapx)-\(item.mapy)",
                medium: .place,
                title: title,
                creator: nil,
                year: nil,
                coverURL: nil,
                externalID: externalID,
                source: .naverPlace,
                confidence: 0.95,
                publisher: item.address
            )
        }
    }

    private func stripHTML(_ string: String) -> String {
        string
            .replacingOccurrences(of: "<b>", with: "")
            .replacingOccurrences(of: "</b>", with: "")
    }
}

// MARK: - Private response types

private struct NaverLocalResponse: Decodable {
    let items: [NaverLocalItem]
}

private struct NaverLocalItem: Decodable {
    let title: String
    let address: String
    let roadAddress: String
    let mapx: String
    let mapy: String
    let category: String
}
