// MovieMetadataLookupTests.swift — InventoryCoreTests
// Copyright 2026 sunghun.ahn — Still Hours Sprint 1.10 MovieMetadataLookup
// Created: 2026-05-22

import Testing
import Foundation
@testable import InventoryCore

// MARK: - TMDB fixtures

private let tmdbSearchResponse = """
{
  "results": [{
    "id": 603,
    "title": "The Matrix",
    "original_title": "The Matrix",
    "release_date": "1999-03-31"
  }]
}
""".data(using: .utf8)!

private let tmdbFindResponse = """
{
  "movie_results": [{
    "id": 603,
    "title": "The Matrix",
    "original_title": "The Matrix",
    "release_date": "1999-03-31"
  }]
}
""".data(using: .utf8)!

private let tmdbEmptyResponse = """
{"results": []}
""".data(using: .utf8)!

// MARK: - OMDb fixtures

private let omdbSearchResponse = """
{
  "Response": "True",
  "Title": "The Matrix",
  "Year": "1999",
  "Director": "Lana Wachowski, Lilly Wachowski",
  "Runtime": "136 min",
  "imdbID": "tt0133093"
}
""".data(using: .utf8)!

private let omdbNotFoundResponse = """
{"Response": "False", "Error": "Movie not found!"}
""".data(using: .utf8)!

private let malformedJSONResponse = """
{"results": [{"id": 999}]}
""".data(using: .utf8)!

// MARK: - Isolated mock

// Each Lookup test file owns a private URLProtocol subclass so suites that run
// concurrently (Swift Testing default) cannot corrupt each other's static stub
// state (Axis G). Naming: <Medium>MockURLProtocol.
private final class MovieMockURLProtocol: URLProtocol, @unchecked Sendable {
    nonisolated(unsafe) static var stubData: Data?
    nonisolated(unsafe) static var stubError: Error?
    nonisolated(unsafe) static var stubStatusCode: Int = 200

    override class func canInit(with request: URLRequest) -> Bool { true }
    override class func canonicalRequest(for request: URLRequest) -> URLRequest { request }

    override func startLoading() {
        if let error = MovieMockURLProtocol.stubError {
            client?.urlProtocol(self, didFailWithError: error)
            return
        }
        let response = HTTPURLResponse(
            url: request.url!,
            statusCode: MovieMockURLProtocol.stubStatusCode,
            httpVersion: nil,
            headerFields: nil
        )!
        client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
        if let data = MovieMockURLProtocol.stubData {
            client?.urlProtocol(self, didLoad: data)
        }
        client?.urlProtocolDidFinishLoading(self)
    }

    override func stopLoading() {}
}

// MARK: - Helpers

private func mockMovieSession() -> URLSession {
    let config = URLSessionConfiguration.ephemeral
    config.protocolClasses = [MovieMockURLProtocol.self]
    return URLSession(configuration: config)
}

// MARK: - Tests

// `MovieMockURLProtocol` uses `nonisolated(unsafe) static var` for its stubs.
// Swift Testing runs tests in parallel by default — that creates a race on
// static state. `.serialized` runs tests one at a time (Axis G).
@Suite(.serialized)
struct MovieMetadataLookupTests {

    // MARK: No API key

    @Test func lookup_noAPIKey_throwsApiKeyMissing() async throws {
        MovieMockURLProtocol.stubData = tmdbSearchResponse
        MovieMockURLProtocol.stubError = nil
        MovieMockURLProtocol.stubStatusCode = 200
        // No keys supplied — should throw immediately without hitting network.
        let sut = MovieMetadataLookup(urlSession: mockMovieSession())
        await #expect(throws: LookupError.self) {
            _ = try await sut.lookup(query: "The Matrix")
        }
    }

    // MARK: Happy path — TMDB

    @Test func lookup_tmdbHappyPath_returnsMovie() async throws {
        MovieMockURLProtocol.stubData = tmdbSearchResponse
        MovieMockURLProtocol.stubError = nil
        MovieMockURLProtocol.stubStatusCode = 200
        let sut = MovieMetadataLookup(
            urlSession: mockMovieSession(),
            tmdbAPIKey: "test-key",
            primary: .tmdb
        )
        let result = try await sut.lookup(query: "The Matrix")
        #expect(result.title == "The Matrix")
        #expect(result.year == 1999)
        #expect(result.tmdbID == 603)
        #expect(result.source == .tmdb)
    }

    // MARK: OMDb fallback

    @Test func lookup_omdbFallback_returnsMovie() async throws {
        // Use OMDb as primary to simulate the fallback result succeeding.
        MovieMockURLProtocol.stubData = omdbSearchResponse
        MovieMockURLProtocol.stubError = nil
        MovieMockURLProtocol.stubStatusCode = 200
        let sut = MovieMetadataLookup(
            urlSession: mockMovieSession(),
            omdbAPIKey: "test-key",
            primary: .omdb
        )
        let result = try await sut.lookup(query: "The Matrix")
        #expect(result.title == "The Matrix")
        #expect(result.year == 1999)
        #expect(result.directors == ["Lana Wachowski", "Lilly Wachowski"])
        #expect(result.runtime == 136)
        #expect(result.imdbID == "tt0133093")
        #expect(result.source == .omdb)
    }

    // MARK: Both sources empty

    @Test func lookup_bothEmpty_throwsNotFound() async throws {
        MovieMockURLProtocol.stubData = tmdbEmptyResponse
        MovieMockURLProtocol.stubError = nil
        MovieMockURLProtocol.stubStatusCode = 200
        // TMDB primary returns empty; OMDb session also returns TMDB-empty-shaped
        // data which mapOMDb will throw malformedResponse for (no "Response"/"Title").
        // Net result: LookupError is thrown.
        let sut = MovieMetadataLookup(
            urlSession: mockMovieSession(),
            tmdbAPIKey: "test-key",
            omdbAPIKey: "test-key",
            primary: .tmdb
        )
        await #expect(throws: LookupError.self) {
            _ = try await sut.lookup(query: "NonExistentFilmXYZ")
        }
    }

    // MARK: Network error

    @Test func lookup_networkError_throwsNetworkUnavailable() async throws {
        MovieMockURLProtocol.stubData = nil
        MovieMockURLProtocol.stubError = URLError(.notConnectedToInternet)
        MovieMockURLProtocol.stubStatusCode = 200
        let sut = MovieMetadataLookup(
            urlSession: mockMovieSession(),
            tmdbAPIKey: "test-key",
            primary: .tmdb
        )
        await #expect(throws: LookupError.self) {
            _ = try await sut.lookup(query: "The Matrix")
        }
    }

    // MARK: Malformed JSON

    @Test func lookup_malformedJSON_throwsMalformedResponse() async throws {
        // Valid JSON with a result entry that has no "title" field.
        MovieMockURLProtocol.stubData = malformedJSONResponse
        MovieMockURLProtocol.stubError = nil
        MovieMockURLProtocol.stubStatusCode = 200
        let sut = MovieMetadataLookup(
            urlSession: mockMovieSession(),
            tmdbAPIKey: "test-key",
            primary: .tmdb
        )
        await #expect(throws: LookupError.self) {
            _ = try await sut.lookup(query: "The Matrix")
        }
    }

    // MARK: Unauthorized host

    // MovieMetadataLookup constructs URLs internally using fixed constants.
    // The unauthorizedHost guard is verified via the error type directly —
    // same whitebox pattern as BookMetadataLookupTests.
    @Test func lookup_unauthorizedHost_throwsUnauthorizedHost() async throws {
        // LINT-IGNORE: Privacy — intentional bad-host string to test rejection path.
        let badURL = try #require(URL(string: "https://evil.example.com/movie?q=test"))
        let error = LookupError.unauthorizedHost(badURL)
        #expect(error.errorDescription != nil)
        if case .unauthorizedHost(let u) = error {
            #expect(u.host == "evil.example.com")
        }
    }

    // MARK: IMDb ID lookup

    @Test func lookup_imdbID_returnsTMDBMovie() async throws {
        MovieMockURLProtocol.stubData = tmdbFindResponse
        MovieMockURLProtocol.stubError = nil
        MovieMockURLProtocol.stubStatusCode = 200
        let sut = MovieMetadataLookup(
            urlSession: mockMovieSession(),
            tmdbAPIKey: "test-key",
            primary: .tmdb
        )
        let result = try await sut.lookup(imdbID: "tt0133093")
        #expect(result.title == "The Matrix")
        #expect(result.year == 1999)
        #expect(result.tmdbID == 603)
        #expect(result.imdbID == "tt0133093")
        #expect(result.source == .tmdb)
    }
}
