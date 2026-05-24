// UnifiedSearch.swift — InventoryCore/Search
// Copyright 2026 sunghun.ahn — Own Your Curation
// R19 — Curation paradigm: single search input across 5 mediums
// Created: 2026-05-24
//
// Architecture:
// - Each medium has multiple SearchProvider implementations (priority chain)
// - UnifiedSearchService fires all providers in parallel via TaskGroup
// - Results merged + per-medium ranked by source priority + confidence
// - Privacy: per-source allowlist enforced in concrete provider; this layer
//   has no network code itself

import Foundation

// MARK: - SearchResult

/// Canonical search result shape — common across all sources.
///
/// `externalID` is the stable identifier from the source (ISBN, TMDB id,
/// Naver productId, etc.). Use it as the `Item.externalID` once adopted
/// so deduplication works across re-curations.
public struct SearchResult: Sendable, Identifiable, Equatable {
    public let id: String
    public let medium: Medium
    public let title: String
    public let creator: String?
    public let year: Int?
    public let coverURL: URL?
    public let externalID: String?
    public let source: SearchSource
    public let confidence: Double  // 0.0 – 1.0 (source-relative)
    public let publisher: String?
    public let extra: [String: String]

    public init(
        id: String,
        medium: Medium,
        title: String,
        creator: String? = nil,
        year: Int? = nil,
        coverURL: URL? = nil,
        externalID: String? = nil,
        source: SearchSource,
        confidence: Double = 0.5,
        publisher: String? = nil,
        extra: [String: String] = [:]
    ) {
        self.id = id
        self.medium = medium
        self.title = title
        self.creator = creator
        self.year = year
        self.coverURL = coverURL
        self.externalID = externalID
        self.source = source
        self.confidence = confidence
        self.publisher = publisher
        self.extra = extra
    }
}

// MARK: - SearchSource

public enum SearchSource: String, Sendable, CaseIterable {
    // Books
    case naverBook
    case aladin
    case openLibrary
    case googleBooks
    // Music
    case iTunes
    case musicBrainz
    case discogs
    // Films
    case kobis
    case tmdb
    case omdb
    // Places
    case naverPlace
    case appleMaps
    // Mock — Build #9a placeholder until KR API keys arrive
    case mockBook
    case mockMusic
    case mockFilm
    case mockObject
    case mockPlace

    /// Default ranking priority (higher = preferred when deduping across sources).
    public var priority: Int {
        switch self {
        case .naverBook:     return 100
        case .aladin:         return 95
        case .iTunes:         return 100
        case .kobis:          return 100
        case .naverPlace:     return 100
        case .musicBrainz:    return 80
        case .tmdb:           return 90
        case .discogs:        return 85
        case .openLibrary:    return 70
        case .googleBooks:    return 70
        case .omdb:           return 70
        case .appleMaps:      return 80
        case .mockBook, .mockMusic, .mockFilm, .mockObject, .mockPlace:
            return 1
        }
    }
}

// MARK: - SearchProvider

public protocol SearchProvider: Sendable {
    var source: SearchSource { get }
    var medium: Medium { get }
    /// Returns up to `limit` results for this query. Implementations should
    /// throw on transport failure; "no results" should return [].
    func search(query: String, limit: Int) async throws -> [SearchResult]
}

// MARK: - UnifiedSearchService

/// Parallel multi-source search aggregator.
///
/// Fires all registered providers concurrently and merges results.
/// Per-medium dedupe by (source.priority, externalID) — best source wins.
public actor UnifiedSearchService {

    private let providers: [any SearchProvider]
    private let perMediumLimit: Int

    public init(providers: [any SearchProvider]? = nil, perMediumLimit: Int = 5) {
        // Default: mock providers (Build #9a, no keys yet).
        // Build #9b will inject real providers once KR API keys arrive.
        self.providers = providers ?? [
            MockBookSearchProvider(),
            MockMusicSearchProvider(),
            MockFilmSearchProvider(),
            MockObjectSearchProvider(),
            MockPlaceSearchProvider(),
        ]
        self.perMediumLimit = perMediumLimit
    }

    /// Search all providers in parallel, return merged + per-medium-ranked results.
    public func search(query: String) async -> [Medium: [SearchResult]] {
        let trimmed = query.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return [:] }

        let allResults = await withTaskGroup(of: [SearchResult].self, returning: [SearchResult].self) { group in
            for provider in providers {
                group.addTask { (try? await provider.search(query: trimmed, limit: 10)) ?? [] }
            }
            var merged: [SearchResult] = []
            for await batch in group {
                merged.append(contentsOf: batch)
            }
            return merged
        }

        // Bucket by medium, dedupe by externalID (prefer higher-priority source),
        // then sort by (priority desc, confidence desc).
        var buckets: [Medium: [SearchResult]] = [:]
        for medium in Medium.allCases {
            let mediumResults = allResults.filter { $0.medium == medium }
            let deduped = Self.dedupe(mediumResults)
            let ranked = deduped.sorted {
                if $0.source.priority != $1.source.priority {
                    return $0.source.priority > $1.source.priority
                }
                return $0.confidence > $1.confidence
            }
            buckets[medium] = Array(ranked.prefix(perMediumLimit))
        }
        return buckets
    }

    private static func dedupe(_ results: [SearchResult]) -> [SearchResult] {
        var seen: [String: SearchResult] = [:]
        for r in results {
            let key = r.externalID ?? "\(r.source.rawValue):\(r.title.lowercased())"
            if let existing = seen[key] {
                if r.source.priority > existing.source.priority {
                    seen[key] = r
                }
            } else {
                seen[key] = r
            }
        }
        return Array(seen.values)
    }
}

// MARK: - Mock Providers (Build #9a — until real APIs wired in Build #9b)

struct MockBookSearchProvider: SearchProvider {
    let source: SearchSource = .mockBook
    let medium: Medium = .book
    func search(query: String, limit: Int) async throws -> [SearchResult] {
        try? await Task.sleep(nanoseconds: 200_000_000)
        return [
            SearchResult(
                id: "mock-book-1-\(query.hashValue)",
                medium: .book,
                title: "\(query) — 예시 도서",
                creator: "예시 저자",
                year: 2024,
                externalID: "9788900000000",
                source: .mockBook,
                confidence: 0.85,
                publisher: "예시 출판사"
            )
        ]
    }
}

struct MockMusicSearchProvider: SearchProvider {
    let source: SearchSource = .mockMusic
    let medium: Medium = .music
    func search(query: String, limit: Int) async throws -> [SearchResult] {
        try? await Task.sleep(nanoseconds: 250_000_000)
        return [
            SearchResult(
                id: "mock-music-1-\(query.hashValue)",
                medium: .music,
                title: "\(query) (Album)",
                creator: "예시 아티스트",
                year: 2023,
                externalID: "mock-album-001",
                source: .mockMusic,
                confidence: 0.75
            )
        ]
    }
}

struct MockFilmSearchProvider: SearchProvider {
    let source: SearchSource = .mockFilm
    let medium: Medium = .movie
    func search(query: String, limit: Int) async throws -> [SearchResult] {
        try? await Task.sleep(nanoseconds: 220_000_000)
        return [
            SearchResult(
                id: "mock-film-1-\(query.hashValue)",
                medium: .movie,
                title: "\(query) (영화)",
                creator: "예시 감독",
                year: 2022,
                externalID: "mock-movie-001",
                source: .mockFilm,
                confidence: 0.65
            )
        ]
    }
}

struct MockObjectSearchProvider: SearchProvider {
    let source: SearchSource = .mockObject
    let medium: Medium = .object
    func search(query: String, limit: Int) async throws -> [SearchResult] {
        try? await Task.sleep(nanoseconds: 180_000_000)
        // Objects are typically not search-discoverable; return empty more often
        if query.count < 3 { return [] }
        return [
            SearchResult(
                id: "mock-object-1-\(query.hashValue)",
                medium: .object,
                title: "\(query)",
                creator: nil,
                year: nil,
                externalID: nil,
                source: .mockObject,
                confidence: 0.4
            )
        ]
    }
}

struct MockPlaceSearchProvider: SearchProvider {
    let source: SearchSource = .mockPlace
    let medium: Medium = .place
    func search(query: String, limit: Int) async throws -> [SearchResult] {
        try? await Task.sleep(nanoseconds: 240_000_000)
        return [
            SearchResult(
                id: "mock-place-1-\(query.hashValue)",
                medium: .place,
                title: "\(query) (장소)",
                creator: nil,
                year: nil,
                externalID: "mock-place-001",
                source: .mockPlace,
                confidence: 0.6,
                publisher: "서울"
            )
        ]
    }
}
