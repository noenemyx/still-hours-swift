// TimelineService.swift — InventoryCore/Services
// Copyright 2026 sunghun.ahn — Still Hours v0.1 MVP
// Pre-flight Round 4: InventoryService layer
// Created: 2026-05-20
// LINT-IGNORE: Privacy — no external URL

import Foundation
import SwiftData

// MARK: - TimelineService

/// Actor-isolated service for time-based ``Memory`` queries.
///
/// Drives the MemoryTimeline view (see docs/MemoryTimeline-Design.md).
/// All returned arrays are sorted chronologically — the most-recent
/// entry appears first (reverse chronological), matching a journal UI.
///
/// Swift 6 note: `ModelContext` is captured at init and accessed only
/// within this actor's isolation domain.
@available(iOS 26, macOS 26, *)
public actor TimelineService {

    // MARK: Stored Properties

    private let context: ModelContext

    // MARK: Initialiser

    public init(context: ModelContext) {
        self.context = context
    }

    // MARK: Per-Item Timeline

    /// Returns all ``Memory`` records for a given ``Item`` in reverse
    /// chronological order (most recent first).
    ///
    /// - Parameter item: The item whose memories to retrieve.
    /// - Returns: Array of memories sorted by `date` descending.
    public func memoriesForItem(_ item: Item) async throws -> [Memory] {
        var descriptor = FetchDescriptor<Memory>(
            sortBy: [SortDescriptor(\.date, order: .reverse)]
        )
        // Fetch all and filter client-side; SwiftData #Predicate
        // with relationship traversal requires extra care under strict
        // concurrency — avoid force-unwrap patterns (axis K, lessons-learned).
        let all = try context.fetch(descriptor)
        let itemID = item.id
        return all.filter { $0.item?.id == itemID }
    }

    // MARK: Cross-Library Timeline

    /// Returns the most-recent ``Memory`` entries across the entire library,
    /// suitable for a home-screen "recent activity" feed.
    ///
    /// - Parameter limit: Maximum number of entries to return (default: 20).
    ///   Must be ≥ 1.
    /// - Returns: Array of memories sorted by `date` descending, capped at `limit`.
    /// - Throws: ``ServiceError/invalidInput(_:)`` if `limit` < 1.
    public func recentMemoriesAcrossLibrary(limit: Int = 20) async throws -> [Memory] {
        guard limit >= 1 else { throw ServiceError.invalidInput("limit") }

        var descriptor = FetchDescriptor<Memory>(
            sortBy: [SortDescriptor(\.date, order: .reverse)]
        )
        descriptor.fetchLimit = limit
        return try context.fetch(descriptor)
    }

    // MARK: Year View

    /// Returns all ``Memory`` records whose `date` falls within a given
    /// calendar year, sorted reverse-chronologically.
    ///
    /// Used by the MemoryTimeline year-picker (docs/MemoryTimeline-Design.md).
    ///
    /// - Parameter year: A four-digit calendar year (e.g. 2026).
    /// - Returns: Array of memories for that year, most recent first.
    /// - Throws: ``ServiceError/invalidInput(_:)`` for out-of-range years.
    public func memoriesByYear(year: Int) async throws -> [Memory] {
        guard year >= 1900, year <= 2100 else {
            throw ServiceError.invalidInput("year")
        }

        var calendar = Calendar(identifier: .gregorian)
        calendar.timeZone = TimeZone.current

        guard
            let startOfYear = calendar.date(
                from: DateComponents(year: year, month: 1, day: 1)
            ),
            let endOfYear = calendar.date(
                from: DateComponents(year: year + 1, month: 1, day: 1)
            )
        else {
            throw ServiceError.invalidInput("year")
        }

        let all = try context.fetch(FetchDescriptor<Memory>(
            sortBy: [SortDescriptor(\.date, order: .reverse)]
        ))

        return all.filter { memory in
            memory.date >= startOfYear && memory.date < endOfYear
        }
    }

    // MARK: Grouped Helpers

    /// Groups an array of memories by calendar year, returning a dictionary
    /// keyed by year (descending).
    ///
    /// Convenience for the MemoryTimeline section-header model.
    ///
    /// - Parameter memories: A pre-fetched array of memories.
    /// - Returns: Dictionary mapping year → memories (sorted reverse-chronologically).
    public func groupByYear(_ memories: [Memory]) -> [Int: [Memory]] {
        let calendar = Calendar(identifier: .gregorian)
        return Dictionary(grouping: memories) { memory in
            calendar.component(.year, from: memory.date)
        }
    }
}
