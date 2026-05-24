// UnifiedSearchServiceTests.swift — InventoryCoreTests
// Build #9 — UnifiedSearchService public API coverage
// Date: 2026-05-24

import Testing
import Foundation
@testable import InventoryCore

// MARK: - Stub providers for isolation

private struct StubProvider: SearchProvider, @unchecked Sendable {
    let source: SearchSource
    let medium: Medium
    let results: [SearchResult]

    func search(query: String, limit: Int) async throws -> [SearchResult] {
        return Array(results.prefix(limit))
    }
}

// MARK: - Tests

struct UnifiedSearchServiceTests {

    // MARK: - Test A: empty / whitespace query returns empty dict

    @available(iOS 26, macOS 26, *)
    @Test func search_emptyQuery_returnsEmpty() async {
        let service = UnifiedSearchService()
        let result = await service.search(query: "")
        #expect(result.isEmpty)
    }

    @available(iOS 26, macOS 26, *)
    @Test func search_whitespaceQuery_returnsEmpty() async {
        let service = UnifiedSearchService()
        let result = await service.search(query: "   ")
        #expect(result.isEmpty)
    }

    // MARK: - Test B: default mock providers populate all 5 medium buckets

    @available(iOS 26, macOS 26, *)
    @Test func search_validQuery_defaultProviders_allMediumsPresent() async {
        // MockObjectSearchProvider requires query.count >= 3
        let service = UnifiedSearchService()
        let result = await service.search(query: "hello")
        #expect(result[.book]?.isEmpty == false)
        #expect(result[.music]?.isEmpty == false)
        #expect(result[.movie]?.isEmpty == false)
        #expect(result[.object]?.isEmpty == false)
        #expect(result[.place]?.isEmpty == false)
    }

    // MARK: - Test C: custom single book provider → only book bucket populated

    @available(iOS 26, macOS 26, *)
    @Test func search_singleBookProvider_onlyBookBucketNonEmpty() async {
        let provider = StubProvider(
            source: .mockBook,
            medium: .book,
            results: [
                SearchResult(
                    id: "b1",
                    medium: .book,
                    title: "Custom Book",
                    externalID: "ext-cb1",
                    source: .mockBook
                )
            ]
        )
        let service = UnifiedSearchService(providers: [provider])
        let result = await service.search(query: "custom")

        #expect(result[.book]?.isEmpty == false)
        // Other mediums must be either absent or empty
        for medium in [Medium.music, .movie, .object, .place] {
            let bucket = result[medium]
            #expect(bucket == nil || bucket!.isEmpty)
        }
    }

    // MARK: - Test D: two providers with same externalID → higher-priority source wins

    @available(iOS 26, macOS 26, *)
    @Test func search_sameExternalIDTwoProviders_higherPrioritySourceWins() async {
        let sharedExternalID = "shared-ext-001"
        let lowPriorityResult = SearchResult(
            id: "low-1",
            medium: .book,
            title: "Shared Book",
            externalID: sharedExternalID,
            source: .openLibrary,   // priority 70
            confidence: 0.9
        )
        let highPriorityResult = SearchResult(
            id: "high-1",
            medium: .book,
            title: "Shared Book",
            externalID: sharedExternalID,
            source: .naverBook,     // priority 100
            confidence: 0.5
        )

        let providerA = StubProvider(source: .openLibrary, medium: .book, results: [lowPriorityResult])
        let providerB = StubProvider(source: .naverBook,   medium: .book, results: [highPriorityResult])

        let service = UnifiedSearchService(providers: [providerA, providerB])
        let result = await service.search(query: "book")

        let bookResults = try! #require(result[.book])
        // After dedup, only one result for this externalID
        let matched = bookResults.filter { $0.externalID == sharedExternalID }
        #expect(matched.count == 1)
        #expect(matched[0].source == .naverBook)
    }

    // MARK: - Test E: perMediumLimit honored — provider returns 10, limit is 3

    @available(iOS 26, macOS 26, *)
    @Test func search_perMediumLimit_truncatesResults() async {
        let manyResults = (1...10).map { i in
            SearchResult(
                id: "book-\(i)",
                medium: .book,
                title: "Book \(i)",
                externalID: "ext-\(i)",
                source: .mockBook,
                confidence: Double(i) / 10.0
            )
        }
        let provider = StubProvider(source: .mockBook, medium: .book, results: manyResults)
        let service = UnifiedSearchService(providers: [provider], perMediumLimit: 3)
        let result = await service.search(query: "query")

        let bookBucket = result[.book] ?? []
        #expect(bookBucket.count <= 3)
    }
}
