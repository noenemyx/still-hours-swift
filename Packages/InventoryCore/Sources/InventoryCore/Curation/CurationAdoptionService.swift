// CurationAdoptionService.swift — InventoryCore/Curation
// Copyright 2026 sunghun.ahn — Own Your Curation
// Build #9b — SchemaV2: dedup by externalID; publisher / source as first-class fields
// Created: 2026-05-24

import Foundation
import SwiftData

// MARK: - CurationAdoptionService

/// Converts a ``SearchResult`` into a persisted ``Item``, deduplicating
/// against existing items in the SwiftData store.
///
/// Follows the same `@MainActor final class` pattern as ``LibraryService``
/// — `ModelContext` is main-actor-bound and must not cross actor boundaries.
@available(iOS 26, macOS 26, *)
@MainActor
public final class CurationAdoptionService {

    // MARK: Initialiser

    public init() {}

    // MARK: Adopt

    /// Converts `result` into a persisted ``Item``, or returns the existing
    /// item if a duplicate is found.
    ///
    /// Deduplication strategy (SchemaV2):
    /// - Primary key: `result.externalID` when non-nil (ISBN, TMDB id, etc.).
    /// - Fallback: `(medium, title.lowercased(), creator?.lowercased())` for
    ///   results that carry no stable external identifier (e.g. objects, places).
    ///
    /// If a match is found the existing item is returned immediately — no
    /// duplicate is inserted.
    ///
    /// - Parameters:
    ///   - result: The ``SearchResult`` to adopt.
    ///   - context: The `ModelContext` to insert into. Must be the same
    ///     context the caller's SwiftUI environment vends.
    /// - Returns: The newly created or pre-existing ``Item``.
    /// - Throws: ``ServiceError/persistFailed(underlying:)`` on save failure.
    public func adopt(_ result: SearchResult, into context: ModelContext) async throws -> Item {
        // 1. Dedup check
        if let existing = try existingItem(matching: result, in: context) {
            return existing
        }

        // 2. Insert — publisher and source are first-class fields in SchemaV2
        let item = Item(
            title: result.title,
            creator: result.creator,
            year: result.year,
            medium: result.medium,
            externalID: result.externalID,
            source: result.source.rawValue,
            publisher: result.publisher
        )
        context.insert(item)
        do {
            try context.save()
        } catch {
            throw ServiceError.persistFailed(underlying: error)
        }
        return item
    }

    // MARK: Private

    private func existingItem(matching result: SearchResult, in context: ModelContext) throws -> Item? {
        // Primary dedup: externalID — stable cross-source key (ISBN, TMDB id, …)
        // H2: predicate-scoped fetch — avoids O(n) full-table scan (axis-M anti-pattern).
        if let extID = result.externalID {
            var descriptor = FetchDescriptor<Item>(predicate: #Predicate { $0.externalID == extID })
            descriptor.fetchLimit = 1
            return try context.fetch(descriptor).first
        }

        // Fallback dedup: (medium, title, creator) — for results without externalID.
        // O(n) fallback acceptable only when externalID is nil; predicate-scope on medium
        // to reduce candidates.
        // Full-table scan acceptable here: only reached when externalID is nil
        // (uncommon path for objects/places). SwiftData #Predicate does not support
        // captured Codable enum values — filter in-memory instead (axis-M note).
        let all = try context.fetch(FetchDescriptor<Item>())
        let titleKey = result.title.lowercased()
        let creatorKey = result.creator?.lowercased()
        let medium = result.medium
        return all.first { item in
            item.medium == medium
            && item.title.lowercased() == titleKey
            && item.creator?.lowercased() == creatorKey
        }
    }
}
