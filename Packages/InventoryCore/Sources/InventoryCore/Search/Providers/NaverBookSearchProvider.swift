// NaverBookSearchProvider.swift — InventoryCore/Search/Providers
// Copyright 2026 sunghun.ahn — Own Your Curation
// Build #9b — Naver Book Search API
// Created: 2026-05-25

import Foundation

/// Searches Naver Book API. Requires Naver Developer Console credentials.
/// Endpoint: https://openapi.naver.com/v1/search/book.json
public struct NaverBookSearchProvider: SearchProvider, Sendable {

    public let source: SearchSource = .naverBook
    public let medium: Medium = .book

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
              let url = URL(string: "https://openapi.naver.com/v1/search/book.json?query=\(encoded)&display=10")
        else { return [] }

        var request = URLRequest(url: url, timeoutInterval: 5)
        request.httpMethod = "GET"
        request.setValue(clientID, forHTTPHeaderField: "X-Naver-Client-Id")
        request.setValue(clientSecret, forHTTPHeaderField: "X-Naver-Client-Secret")

        let (data, _) = try await urlSession.data(for: request)
        let response = try JSONDecoder().decode(NaverBookResponse.self, from: data)

        return response.items.prefix(limit).compactMap { item in
            let isbn = item.isbn.trimmingCharacters(in: .whitespaces)
            guard !isbn.isEmpty else { return nil }
            let title = stripHTML(item.title)
            let authors = item.author
                .components(separatedBy: "^")
                .map { $0.trimmingCharacters(in: .whitespaces) }
                .filter { !$0.isEmpty }
            return SearchResult(
                id: "naver-book-\(isbn)",
                medium: .book,
                title: title,
                creator: authors.first,
                year: Int(item.pubdate.prefix(4)),
                coverURL: URL(string: item.image),
                externalID: isbn,
                source: .naverBook,
                confidence: 0.95,
                publisher: item.publisher
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

private struct NaverBookResponse: Decodable {
    let items: [NaverBookItem]
}

private struct NaverBookItem: Decodable {
    let title: String
    let author: String
    let isbn: String
    let image: String
    let publisher: String
    let pubdate: String
}
