// BookMetadata.swift — InventoryCore/Lookups
// Copyright 2026 sunghun.ahn — Still Hours Sprint 1.2 BookMetadataLookup
// Created: 2026-05-21
// LINT-IGNORE: Privacy — external URLs limited to openlibrary.org, www.googleapis.com

import Foundation

// MARK: - LookupSource

/// The external API that produced a lookup result.
public enum LookupSource: String, Codable, Sendable {
    /// Open Library — openlibrary.org
    case openLibrary
    /// Google Books — www.googleapis.com
    case googleBooks
    /// MusicBrainz — musicbrainz.org
    case musicBrainz
    /// iTunes Search API — api.itunes.apple.com
    case itunes
    /// The Movie Database — api.themoviedb.org
    case tmdb
    /// Open Movie Database — www.omdbapi.com
    case omdb
}

// MARK: - BookMetadata

/// Resolved book metadata returned by ``BookMetadataLookup``.
///
/// All fields except `title` and `source` are optional — external APIs
/// provide varying levels of completeness. Callers must not assume
/// secondary fields are populated.
public struct BookMetadata: Sendable, Codable, Equatable {

    /// Primary title of the work.
    public let title: String

    /// Author names in display order (e.g. ["Haruki Murakami"]).
    public let authors: [String]

    /// Four-digit year of first publication or this edition's release.
    public let publishedYear: Int?

    /// Publisher name string.
    public let publisher: String?

    /// Total page count of this edition.
    public let pageCount: Int?

    /// HTTPS cover image URL from an allowed host.
    public let coverImageURL: URL?

    /// ISBN-10 identifier (10 characters, no hyphens).
    public let isbn10: String?

    /// ISBN-13 identifier (13 digits, no hyphens).
    public let isbn13: String?

    /// Which API produced this result.
    public let source: LookupSource

    public init(
        title: String,
        authors: [String],
        publishedYear: Int?,
        publisher: String?,
        pageCount: Int?,
        coverImageURL: URL?,
        isbn10: String?,
        isbn13: String?,
        source: LookupSource
    ) {
        self.title = title
        self.authors = authors
        self.publishedYear = publishedYear
        self.publisher = publisher
        self.pageCount = pageCount
        self.coverImageURL = coverImageURL
        self.isbn10 = isbn10
        self.isbn13 = isbn13
        self.source = source
    }
}
