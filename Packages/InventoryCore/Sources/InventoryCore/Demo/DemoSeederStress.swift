// DemoSeederStress.swift — InventoryCore/Demo
// Copyright 2026 sunghun.ahn — Still Hours
// Performance benchmark stress dataset — R14.4
// Created: 2026-05-22

#if DEBUG

import Foundation
import SwiftData

// MARK: - DemoSeederStress

/// Generates a large synthetic dataset for scroll-performance benchmarking.
///
/// Produces `count` items spread across all four media types, each with
/// 1–5 synthetic memories whose dates are distributed across the last 5 years.
/// Use via the `--seed-stress-50` launch argument in performance UI tests.
///
/// **Usage (UI tests)**:
/// ```swift
/// app.launchArguments.append("--seed-stress-50")
/// app.launch()
/// ```
///
/// - Note: `@MainActor` mirrors `DemoSeeder` — `ModelContext` injected from
///   `@Environment(\.modelContext)` is main-actor-bound.
@available(iOS 26, macOS 26, *)
@MainActor
public final class DemoSeederStress {

    // MARK: Properties

    private let context: ModelContext

    // MARK: Initialiser

    /// Creates a stress seeder backed by the given model context.
    ///
    /// - Parameter context: A `ModelContext` bound to the main actor.
    public init(context: ModelContext) {
        self.context = context
    }

    // MARK: Public API

    /// Seeds the store with `count` synthetic items.
    ///
    /// Clears any existing items first so the test starts from a known state.
    ///
    /// - Parameter count: Number of items to generate. Defaults to 50.
    /// - Throws: On `ModelContext` save failure.
    public func seedStressDataset(count: Int = 50) async throws {
        // Clear existing data so the stress run is isolated.
        let existing = try context.fetch(FetchDescriptor<Item>())
        for item in existing {
            context.delete(item)
        }
        try context.save()

        // Cycle through all four media types evenly.
        let mediums: [Medium] = [.book, .music, .movie, .object]
        let states: [ItemState] = [.owned, .owned, .owned, .lent, .digitalOnly]
        let calendar = Calendar(identifier: .gregorian)
        let now = Date()

        for index in 1...count {
            let medium = mediums[(index - 1) % mediums.count]
            let state = states[(index - 1) % states.count]
            let mediumLabel = Self.label(for: medium)
            let itemYear = 2000 + ((index * 7) % 25) // spread 2000–2024

            let item = Item(
                title: "Stress \(mediumLabel) #\(index)",
                creator: "Stress Creator #\(((index - 1) % 10) + 1)",
                year: itemYear,
                medium: medium,
                state: state,
                tags: Self.syntheticTags(index: index, medium: medium)
            )
            context.insert(item)

            // Attach 1–5 memories, spread across the last 5 years.
            let memoryCount = ((index - 1) % 5) + 1
            let memoryKinds = Self.memoryKinds(for: medium)
            for memIdx in 0..<memoryCount {
                // Spread memory dates across 0–1825 days (5 years) for timeline grouping.
                let daysBack = (memIdx * 365) + ((index * 13 + memIdx * 7) % 365)
                let date = calendar.date(
                    byAdding: .day,
                    value: -daysBack,
                    to: now
                ) ?? now

                let kind = memoryKinds[memIdx % memoryKinds.count]
                let memory = Memory(
                    kind: kind,
                    date: date,
                    note: "Stress note \(index).\(memIdx + 1) — \(mediumLabel) #\(index)"
                )
                memory.item = item
                item.memories.append(memory)
                context.insert(memory)
            }
        }

        try context.save()
    }

    // MARK: Helpers

    private static func label(for medium: Medium) -> String {
        switch medium {
        case .book:   return "Book"
        case .music:  return "Album"
        case .movie:  return "Film"
        case .object: return "Object"
        }
    }

    private static func syntheticTags(index: Int, medium: Medium) -> [String] {
        let base = ["stress", "benchmark", label(for: medium).lowercased()]
        let extras = ["2024", "vintage", "classic", "modern", "rare"]
        return base + [extras[index % extras.count]]
    }

    /// Returns an appropriate set of `MemoryKind` values for the given medium.
    private static func memoryKinds(for medium: Medium) -> [MemoryKind] {
        switch medium {
        case .book:
            return [.acquired, .read, .annotated, .lent, .received]
        case .music:
            return [.acquired, .listened, .lent, .received, .gifted]
        case .movie:
            return [.acquired, .watched, .lent, .received, .gifted]
        case .object:
            return [.acquired, .annotated, .lent, .received, .gifted]
        }
    }
}

#endif
