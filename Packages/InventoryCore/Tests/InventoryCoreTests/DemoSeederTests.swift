// DemoSeederTests.swift — InventoryCoreTests
// Copyright 2026 sunghun.ahn — Still Hours Sprint 1.7
// Created: 2026-05-21
// LINT-IGNORE: Privacy — no external URL

#if DEBUG

import Testing
import SwiftData
import Foundation
@testable import InventoryCore

// MARK: - Suite

@MainActor
struct DemoSeederTests {

    // MARK: Helpers

    private func makeContainer() throws -> ModelContainer {
        try ModelContainer(
            for: SchemaV1.schema,
            configurations: ModelConfiguration(isStoredInMemoryOnly: true)
        )
    }

    // MARK: - Tests

    /// An empty library should receive all demo items after seeding.
    @Test func seedIfEmpty_emptyLibrary_addsItems() async throws {
        let container = try makeContainer()
        let context = container.mainContext
        let seeder = DemoSeeder(context: context)

        try await seeder.seedIfEmpty()

        let count = try context.fetchCount(FetchDescriptor<Item>())
        #expect(count >= 6)
        #expect(count <= 8)
    }

    /// Calling `seedIfEmpty` when items already exist must be a no-op.
    @Test func seedIfEmpty_nonEmptyLibrary_isNoOp() async throws {
        let container = try makeContainer()
        let context = container.mainContext

        let existing = Item(title: "Pre-existing", medium: .book)
        context.insert(existing)
        try context.save()

        let seeder = DemoSeeder(context: context)
        try await seeder.seedIfEmpty()

        let count = try context.fetchCount(FetchDescriptor<Item>())
        #expect(count == 1)
    }

    /// After seeding, every `Medium` case must have at least one item.
    @Test func seedIfEmpty_eachMediumPresent() async throws {
        let container = try makeContainer()
        let context = container.mainContext
        let seeder = DemoSeeder(context: context)

        try await seeder.seedIfEmpty()

        let all = try context.fetch(FetchDescriptor<Item>())
        let mediums = Set(all.map(\.medium))
        #expect(mediums.contains(.book))
        #expect(mediums.contains(.music))
        #expect(mediums.contains(.movie))
        #expect(mediums.contains(.object))
    }

    /// Every seeded item must have at least one memory attached.
    @Test func seedIfEmpty_memoriesAttached() async throws {
        let container = try makeContainer()
        let context = container.mainContext
        let seeder = DemoSeeder(context: context)

        try await seeder.seedIfEmpty()

        let all = try context.fetch(FetchDescriptor<Item>())
        for item in all {
            #expect(!item.memories.isEmpty, "Item '\(item.title)' has no memories")
        }
    }
}

#endif
