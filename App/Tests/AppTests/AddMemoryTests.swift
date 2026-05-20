// AddMemoryTests.swift — App/Tests/AppTests
// Copyright 2026 sunghun.ahn — Still Hours
// Sprint 1.6 — AddMemoryView (Memory to existing Item)
// Created: 2026-05-21
//
// Unit tests for the add-memory flow via LibraryService.
// Axis C: No @available on @Test functions.
// Axis D: Qualify InventoryCore.Collection, InventoryCore.Attachment in FetchDescriptor.
// No force unwrap.

import Testing
import SwiftData
import Foundation
@testable import StillHours
import InventoryCore

// MARK: - Helpers

// Platform floor: see Package.swift / project.yml deploymentTarget=26.0
private func makeTestContainer() throws -> ModelContainer {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    return try ModelContainer(
        for: Item.self,
             Memory.self,
             InventoryCore.Collection.self,
             InventoryCore.Attachment.self,
        configurations: config
    )
}

@MainActor
private func makeTestLibrary(container: ModelContainer) -> LibraryService {
    LibraryService(context: ModelContext(container))
}

// MARK: - AddMemoryTests

@Suite("AddMemory")
struct AddMemoryTests {

    // MARK: 1. attachMemory saves to item

    @Test("addMemory_validKind_savesToItem — memory lands on item.memories")
    @MainActor
    func addMemory_validKind_savesToItem() async throws {
        let container = try makeTestContainer()
        let library = makeTestLibrary(container: container)

        let item = Item(title: "Norwegian Wood", medium: .book)
        try await library.addItem(item)

        let memory = Memory(kind: .read, note: "Deeply moved.")
        try await library.attachMemory(memory, to: item)

        #expect(item.memories.count == 1)
        #expect(item.memories.first?.kind == .read)
    }

    // MARK: 2. Default date is within ±1 minute of now

    @Test("addMemory_defaultDateIsNow — default date within 60s of now")
    func addMemory_defaultDateIsNow() {
        let before = Date()
        let memory = Memory(kind: .acquired)
        let after = Date()

        #expect(memory.date >= before)
        #expect(memory.date <= after)
    }

    // MARK: 3. All 8 MemoryKind cases attach successfully

    @Test("addMemory_8KindsAllSupported — all cases attach to item")
    @MainActor
    func addMemory_8KindsAllSupported() async throws {
        let container = try makeTestContainer()
        let library = makeTestLibrary(container: container)

        let item = Item(title: "The Archive", medium: .object)
        try await library.addItem(item)

        for kind in MemoryKind.allCases {
            let memory = Memory(kind: kind, note: "")
            try await library.attachMemory(memory, to: item)
        }

        #expect(item.memories.count == MemoryKind.allCases.count)

        let attachedKinds = Set(item.memories.map(\.kind))
        for kind in MemoryKind.allCases {
            #expect(attachedKinds.contains(kind))
        }
    }

    // MARK: 4. Empty note is valid (BuJo date-only memories)

    @Test("addMemory_emptyNoteIsAllowed — empty note string saves without error")
    @MainActor
    func addMemory_emptyNoteIsAllowed() async throws {
        let container = try makeTestContainer()
        let library = makeTestLibrary(container: container)

        let item = Item(title: "Stoner", medium: .book)
        try await library.addItem(item)

        let memory = Memory(kind: .read, note: "")
        try await library.attachMemory(memory, to: item)

        #expect(item.memories.count == 1)
        #expect(item.memories.first?.note == "")
    }
}
