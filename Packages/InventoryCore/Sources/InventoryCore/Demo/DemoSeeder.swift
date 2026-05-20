// DemoSeeder.swift — InventoryCore/Demo
// Copyright 2026 sunghun.ahn — Still Hours Sprint 1.7
// Created: 2026-05-21
// LINT-IGNORE: Privacy — no external URL

#if DEBUG

import Foundation
import SwiftData

// MARK: - DemoSeeder

/// One-shot seeder that populates a demo library for development and
/// App Store screenshot sessions.
///
/// **Usage** (root view, DEBUG gate):
/// ```swift
/// #if DEBUG
/// .task {
///     try? await DemoSeeder(context: modelContext).seedIfEmpty()
/// }
/// #endif
/// ```
///
/// - Note: All methods operate directly on the injected `ModelContext`.
///   The seeder bypasses `LibraryService` intentionally — it runs at
///   startup before the service layer is initialised, avoiding circular
///   dependency.
/// - Note: `@MainActor` is required because `ModelContext` injected via
///   `@Environment(\.modelContext)` is bound to the main actor (Axis I).
@available(iOS 26, macOS 26, *)
@MainActor
public final class DemoSeeder {

    // MARK: Properties

    private let context: ModelContext

    // MARK: Initialiser

    /// Creates a seeder backed by the given model context.
    ///
    /// - Parameter context: A `ModelContext` bound to the main actor.
    public init(context: ModelContext) {
        self.context = context
    }

    // MARK: Public API

    /// Seeds the library with demo content if it is currently empty.
    ///
    /// Idempotent: if any `Item` already exists in the store, this
    /// method returns immediately without making changes.
    ///
    /// - Throws: On `ModelContext` save failure.
    public func seedIfEmpty() async throws {
        let descriptor = FetchDescriptor<Item>()
        let count = try context.fetchCount(descriptor)
        guard count == 0 else { return }
        try insertDemoItems()
    }

    /// Removes all `Item` records (and their cascaded memories) from the store.
    ///
    /// - Throws: On `ModelContext` save failure.
    public func clearAll() async throws {
        let items = try context.fetch(FetchDescriptor<Item>())
        for item in items {
            context.delete(item)
        }
        try context.save()
    }

    /// Clears the store and re-inserts the full demo data set.
    ///
    /// - Throws: On `ModelContext` save failure.
    public func reseed() async throws {
        try await clearAll()
        try insertDemoItems()
    }

    // MARK: Private

    private func insertDemoItems() throws {
        let allDemoItems: [DemoItem] =
            DemoSeederContent.books
            + DemoSeederContent.music
            + DemoSeederContent.movies
            + DemoSeederContent.objects

        for demoItem in allDemoItems {
            let item = Item(
                title: demoItem.title,
                creator: demoItem.creator,
                year: demoItem.year,
                medium: demoItem.medium,
                state: demoItem.state,
                tags: demoItem.tags
            )
            context.insert(item)

            for demoMemory in demoItem.memories {
                let memory = Memory(
                    kind: demoMemory.kind,
                    date: daysAgo(demoMemory.daysAgo),
                    note: demoMemory.note
                )
                memory.item = item
                item.memories.append(memory)
                context.insert(memory)
            }
        }

        try context.save()
    }

    /// Returns a `Date` exactly `n` calendar days before now (noon, local time).
    private func daysAgo(_ n: Int) -> Date {
        let cal = Calendar.current
        let today = cal.startOfDay(for: Date())
        let past = cal.date(byAdding: .day, value: -n, to: today) ?? today
        return cal.date(byAdding: .hour, value: 12, to: past) ?? past
    }
}

#endif
