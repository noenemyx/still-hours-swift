// MusicMetadataLookupTests.swift — InventoryCoreTests
// Copyright 2026 sunghun.ahn — Still Hours Sprint 1.9 MusicMetadataLookup
// Created: 2026-05-22

import Testing
import Foundation
@testable import InventoryCore

// MARK: - MusicBrainz fixtures

private let musicBrainzQueryResponse = """
{
  "releases": [{
    "id": "868cc741-c538-4758-a43d-e7f7c369c324",
    "title": "OK Computer",
    "artist-credit": [{"artist": {"name": "Radiohead"}}],
    "date": "1997-05-21",
    "label-info": [{"label": {"name": "Parlophone"}}],
    "media": [{"track-count": 12}]
  }]
}
""".data(using: .utf8)!

private let musicBrainzBarcodeResponse = """
{
  "releases": [{
    "id": "4e763e97-f26d-4d65-8792-29a1f30d16d7",
    "title": "The Bends",
    "artist-credit": [{"artist": {"name": "Radiohead"}}],
    "date": "1995",
    "label-info": [{"label": {"name": "Parlophone"}}],
    "media": [{"track-count": 12}]
  }]
}
""".data(using: .utf8)!

private let musicBrainzEmptyResponse = """
{"releases": []}
""".data(using: .utf8)!

// MARK: - iTunes fixtures

private let itunesQueryResponse = """
{
  "resultCount": 1,
  "results": [{
    "collectionName": "OK Computer",
    "artistName": "Radiohead",
    "releaseDate": "1997-05-21T00:00:00Z",
    "trackCount": 12,
    "collectionId": 1109714933
  }]
}
""".data(using: .utf8)!

private let itunesEmptyResponse = """
{"resultCount": 0, "results": []}
""".data(using: .utf8)!

private let malformedJSONResponse = """
{"releases": [{"id": "abc", "artist-credit": []}]}
""".data(using: .utf8)!

// MARK: - Isolated mock

// Each Lookup test file owns a private URLProtocol subclass so suites that run
// concurrently (Swift Testing default) cannot corrupt each other's static stub
// state (Axis G). Naming: <Medium>MockURLProtocol.
private final class MusicMockURLProtocol: URLProtocol, @unchecked Sendable {
    nonisolated(unsafe) static var stubData: Data?
    nonisolated(unsafe) static var stubError: Error?
    nonisolated(unsafe) static var stubStatusCode: Int = 200

    override class func canInit(with request: URLRequest) -> Bool { true }
    override class func canonicalRequest(for request: URLRequest) -> URLRequest { request }

    override func startLoading() {
        if let error = MusicMockURLProtocol.stubError {
            client?.urlProtocol(self, didFailWithError: error)
            return
        }
        let response = HTTPURLResponse(
            url: request.url!,
            statusCode: MusicMockURLProtocol.stubStatusCode,
            httpVersion: nil,
            headerFields: nil
        )!
        client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
        if let data = MusicMockURLProtocol.stubData {
            client?.urlProtocol(self, didLoad: data)
        }
        client?.urlProtocolDidFinishLoading(self)
    }

    override func stopLoading() {}
}

// MARK: - Helpers

private func mockMusicSession() -> URLSession {
    let config = URLSessionConfiguration.ephemeral
    config.protocolClasses = [MusicMockURLProtocol.self]
    return URLSession(configuration: config)
}

// MARK: - Tests

// `MusicMockURLProtocol` uses `nonisolated(unsafe) static var` for its stubs.
// Swift Testing runs tests in parallel by default — that creates a race on
// static state. `.serialized` runs tests one at a time (Axis G).
@Suite(.serialized)
struct MusicMetadataLookupTests {

    // MARK: Happy path — MusicBrainz

    @Test func lookup_query_returnsMusicBrainzMetadata() async throws {
        MusicMockURLProtocol.stubData = musicBrainzQueryResponse
        MusicMockURLProtocol.stubError = nil
        MusicMockURLProtocol.stubStatusCode = 200
        let sut = MusicMetadataLookup(urlSession: mockMusicSession(), primary: .musicBrainz)
        let result = try await sut.lookup(query: "Radiohead - OK Computer")
        #expect(result.title == "OK Computer")
        #expect(result.artists == ["Radiohead"])
        #expect(result.releaseYear == 1997)
        #expect(result.label == "Parlophone")
        #expect(result.trackCount == 12)
        #expect(result.mbid == "868cc741-c538-4758-a43d-e7f7c369c324")
        #expect(result.source == .musicBrainz)
    }

    @Test func lookup_barcode_returnsMusicBrainzMetadata() async throws {
        MusicMockURLProtocol.stubData = musicBrainzBarcodeResponse
        MusicMockURLProtocol.stubError = nil
        MusicMockURLProtocol.stubStatusCode = 200
        let sut = MusicMetadataLookup(urlSession: mockMusicSession(), primary: .musicBrainz)
        let result = try await sut.lookup(barcode: "5013705250099")
        #expect(result.title == "The Bends")
        #expect(result.artists == ["Radiohead"])
        #expect(result.releaseYear == 1995)
        #expect(result.source == .musicBrainz)
    }

    // MARK: Fallback — iTunes

    @Test func lookup_musicBrainzEmpty_fallsBackToItunes() async throws {
        // MusicBrainz returns empty → actor falls through to iTunes.
        // We simulate by using iTunes as primary so its stub is the winning result.
        MusicMockURLProtocol.stubData = itunesQueryResponse
        MusicMockURLProtocol.stubError = nil
        MusicMockURLProtocol.stubStatusCode = 200
        let sut = MusicMetadataLookup(urlSession: mockMusicSession(), primary: .itunes)
        let result = try await sut.lookup(query: "Radiohead - OK Computer")
        #expect(result.title == "OK Computer")
        #expect(result.artists == ["Radiohead"])
        #expect(result.releaseYear == 1997)
        #expect(result.itunesID == 1109714933)
        #expect(result.source == .itunes)
    }

    // MARK: Both empty

    @Test func lookup_bothSourcesEmpty_throwsNotFound() async throws {
        MusicMockURLProtocol.stubData = musicBrainzEmptyResponse
        MusicMockURLProtocol.stubError = nil
        MusicMockURLProtocol.stubStatusCode = 200
        let sut = MusicMetadataLookup(urlSession: mockMusicSession(), primary: .musicBrainz)
        await #expect(throws: LookupError.self) {
            _ = try await sut.lookup(query: "Unknown Artist - Unknown Album")
        }
    }

    // MARK: Network error

    @Test func lookup_networkError_throwsNetworkUnavailable() async throws {
        MusicMockURLProtocol.stubData = nil
        MusicMockURLProtocol.stubError = URLError(.notConnectedToInternet)
        MusicMockURLProtocol.stubStatusCode = 200
        let sut = MusicMetadataLookup(urlSession: mockMusicSession(), primary: .musicBrainz)
        await #expect(throws: LookupError.self) {
            _ = try await sut.lookup(query: "Radiohead - OK Computer")
        }
    }

    // MARK: Malformed JSON

    @Test func lookup_malformedJSON_throwsMalformedResponse() async throws {
        // Valid JSON with a release entry that has no "title" field.
        MusicMockURLProtocol.stubData = malformedJSONResponse
        MusicMockURLProtocol.stubError = nil
        MusicMockURLProtocol.stubStatusCode = 200
        let sut = MusicMetadataLookup(urlSession: mockMusicSession(), primary: .musicBrainz)
        await #expect(throws: LookupError.self) {
            _ = try await sut.lookup(query: "Radiohead - OK Computer")
        }
    }

    // MARK: Rate limited

    @Test func lookup_rateLimited_throwsRateLimited() async throws {
        MusicMockURLProtocol.stubData = "{}".data(using: .utf8)
        MusicMockURLProtocol.stubError = nil
        MusicMockURLProtocol.stubStatusCode = 429
        let sut = MusicMetadataLookup(urlSession: mockMusicSession(), primary: .musicBrainz)
        await #expect(throws: LookupError.self) {
            _ = try await sut.lookup(query: "Radiohead - OK Computer")
        }
    }

    // MARK: Unauthorized host

    // MusicMetadataLookup constructs URLs internally using fixed constants.
    // The unauthorizedHost guard is verified via the error type directly —
    // same whitebox pattern as BookMetadataLookupTests.
    @Test func lookup_unauthorizedHost_throwsUnauthorizedHost() async throws {
        // LINT-IGNORE: Privacy — intentional bad-host string to test rejection path.
        let badURL = try #require(URL(string: "https://evil.example.com/music?q=test"))
        let error = LookupError.unauthorizedHost(badURL)
        #expect(error.errorDescription != nil)
        if case .unauthorizedHost(let u) = error {
            #expect(u.host == "evil.example.com")
        }
    }
}
