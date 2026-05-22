// MovieMetadata.swift — InventoryCore/Lookups
// Copyright 2026 sunghun.ahn — Still Hours Sprint 1.10 MovieMetadataLookup
// Created: 2026-05-22
// LINT-IGNORE: Privacy — external URLs limited to api.themoviedb.org, www.omdbapi.com

import Foundation

// MARK: - MovieSource

/// The external API that produced a ``MovieMetadata`` result.
public enum MovieSource: String, Codable, Sendable {
    /// The Movie Database — api.themoviedb.org
    case tmdb
    /// Open Movie Database — www.omdbapi.com
    case omdb
}

// MARK: - MovieMetadata

/// Resolved movie metadata returned by ``MovieMetadataLookup``.
///
/// All fields except `title` and `source` are optional — external APIs
/// provide varying levels of completeness. Callers must not assume
/// secondary fields are populated.
public struct MovieMetadata: Sendable, Codable, Equatable {

    /// Primary title of the film.
    public let title: String

    /// Original title in the film's language (may differ from localised title).
    public let originalTitle: String?

    /// Four-digit release year.
    public let year: Int?

    /// Director names in display order.
    public let directors: [String]

    /// Runtime in minutes.
    public let runtime: Int?

    /// HTTPS poster image URL from an allowed host.
    public let posterURL: URL?

    /// TMDB numeric film ID.
    public let tmdbID: Int?

    /// IMDb ID string (e.g. "tt0133093").
    public let imdbID: String?

    /// Which API produced this result.
    public let source: MovieSource

    public init(
        title: String,
        originalTitle: String?,
        year: Int?,
        directors: [String],
        runtime: Int?,
        posterURL: URL?,
        tmdbID: Int?,
        imdbID: String?,
        source: MovieSource
    ) {
        self.title = title
        self.originalTitle = originalTitle
        self.year = year
        self.directors = directors
        self.runtime = runtime
        self.posterURL = posterURL
        self.tmdbID = tmdbID
        self.imdbID = imdbID
        self.source = source
    }
}
