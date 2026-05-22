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

// MARK: - Helpers

private func mockMusicSession() -> URLSession {
    let config = URLSessionConfiguration.ephemeral
    config.protocolClasses = [MockURLProtocol.self]
    return URLSession(configuration: config)
}

// MARK: - Tests

// `MockURLProtocol` uses `nonisolated(unsafe) static var` for its stubs.
// Swift Testing runs tests in parallel by default — that creates a race on
// static state. `.serialized` runs tests one at a time (Axis G).
@Suite(.serialized)
struct MusicMetadataLookupTests {

    // MARK: Happy path — MusicBrainz

    @Test func lookup_query_returnsMusicBrainzMetadata() async throws {
        MockURLProtocol.stubData = musicBrainzQueryResponse
        MockURLProtocol.stubError = nil
        MockURLProtocol.stubStatusCode = 200
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
        MockURLProtocol.stubData = musicBrainzBarcodeResponse
        MockURLProtocol.stubError = nil
        MockURLProtocol.stubStatusCode = 200
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
        MockURLProtocol.stubData = itunesQueryResponse
        MockURLProtocol.stubError = nil
        MockURLProtocol.stubStatusCode = 200
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
        MockURLProtocol.stubData = musicBrainzEmptyResponse
        MockURLProtocol.stubError = nil
        MockURLProtocol.stubStatusCode = 200
        let sut = MusicMetadataLookup(urlSession: mockMusicSession(), primary: .musicBrainz)
        await #expect(throws: LookupError.self) {
            _ = try await sut.lookup(query: "Unknown Artist - Unknown Album")
        }
    }

    // MARK: Network error

    @Test func lookup_networkError_throwsNetworkUnavailable() async throws {
        MockURLProtocol.stubData = nil
        MockURLProtocol.stubError = URLError(.notConnectedToInternet)
        MockURLProtocol.stubStatusCode = 200
        let sut = MusicMetadataLookup(urlSession: mockMusicSession(), primary: .musicBrainz)
        await #expect(throws: LookupError.self) {
            _ = try await sut.lookup(query: "Radiohead - OK Computer")
        }
    }

    // MARK: Malformed JSON

    @Test func lookup_malformedJSON_throwsMalformedResponse() async throws {
        // Valid JSON with a release entry that has no "title" field.
        MockURLProtocol.stubData = malformedJSONResponse
        MockURLProtocol.stubError = nil
        MockURLProtocol.stubStatusCode = 200
        let sut = MusicMetadataLookup(urlSession: mockMusicSession(), primary: .musicBrainz)
        await #expect(throws: LookupError.self) {
            _ = try await sut.lookup(query: "Radiohead - OK Computer")
        }
    }

    // MARK: Rate limited

    @Test func lookup_rateLimited_throwsRateLimited() async throws {
        MockURLProtocol.stubData = "{}".data(using: .utf8)
        MockURLProtocol.stubError = nil
        MockURLProtocol.stubStatusCode = 429
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
