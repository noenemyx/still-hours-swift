// MusicMetadata.swift — InventoryCore/Lookups
// Copyright 2026 sunghun.ahn — Still Hours Sprint 1.9 MusicMetadataLookup
// Created: 2026-05-22
// LINT-IGNORE: Privacy — external URLs limited to musicbrainz.org, api.itunes.apple.com

import Foundation

// MARK: - MusicSource

/// The external API that produced a ``MusicMetadata`` result.
public enum MusicSource: String, Codable, Sendable {
    /// MusicBrainz — musicbrainz.org
    case musicBrainz
    /// iTunes Search API — api.itunes.apple.com
    case itunes
}

// MARK: - MusicMetadata

/// Resolved music album metadata returned by ``MusicMetadataLookup``.
///
/// All fields except `title` and `source` are optional — external APIs
/// provide varying levels of completeness. Callers must not assume
/// secondary fields are populated.
public struct MusicMetadata: Sendable, Codable, Equatable {

    /// Album title.
    public let title: String

    /// Artist names in display order (e.g. ["Radiohead"]).
    public let artists: [String]

    /// Four-digit year of the album release.
    public let releaseYear: Int?

    /// Record label name string.
    public let label: String?

    /// Total track count on the album.
    public let trackCount: Int?

    /// HTTPS cover image URL from an allowed host.
    public let coverImageURL: URL?

    /// MusicBrainz Release ID (UUID string).
    public let mbid: String?

    /// iTunes collection ID (numeric).
    public let itunesID: Int?

    /// Which API produced this result.
    public let source: MusicSource

    public init(
        title: String,
        artists: [String],
        releaseYear: Int?,
        label: String?,
        trackCount: Int?,
        coverImageURL: URL?,
        mbid: String?,
        itunesID: Int?,
        source: MusicSource
    ) {
        self.title = title
        self.artists = artists
        self.releaseYear = releaseYear
        self.label = label
        self.trackCount = trackCount
        self.coverImageURL = coverImageURL
        self.mbid = mbid
        self.itunesID = itunesID
        self.source = source
    }
}
