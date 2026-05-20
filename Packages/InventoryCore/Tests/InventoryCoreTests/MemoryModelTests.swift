// MemoryModelTests.swift — InventoryCoreTests
// Still Hours v0.1 MVP — Pre-flight Round 4 unit tests
// Date: 2026-05-20

import Testing
import SwiftData
import Foundation
@testable import InventoryCore

@MainActor
struct MemoryModelTests {

    private func makeContainer() throws -> ModelContainer {
        try ModelContainer(
            for: SchemaV1.schema,
            configurations: ModelConfiguration(isStoredInMemoryOnly: true)
        )
    }

    // MARK: - MemoryKind — all 8 cases

    @Test func memoryKind_allEightCasesPresent() {
        let cases = MemoryKind.allCases
        #expect(cases.count == 8)
        #expect(cases.contains(.acquired))
        #expect(cases.contains(.read))
        #expect(cases.contains(.listened))
        #expect(cases.contains(.watched))
        #expect(cases.contains(.lent))
        #expect(cases.contains(.received))
        #expect(cases.contains(.gifted))
        #expect(cases.contains(.annotated))
    }

    @Test func memoryKind_rawValues() {
        #expect(MemoryKind.acquired.rawValue == "acquired")
        #expect(MemoryKind.read.rawValue == "read")
        #expect(MemoryKind.listened.rawValue == "listened")
        #expect(MemoryKind.watched.rawValue == "watched")
        #expect(MemoryKind.lent.rawValue == "lent")
        #expect(MemoryKind.received.rawValue == "received")
        #expect(MemoryKind.gifted.rawValue == "gifted")
        #expect(MemoryKind.annotated.rawValue == "annotated")
    }

    // MARK: - Init Defaults

    @Test func initDefaults_noteIsEmpty() {
        let memory = Memory(kind: .read)
        #expect(memory.note == "")
    }

    @Test func initDefaults_photoCountIsZero() {
        let memory = Memory(kind: .watched)
        #expect(memory.photoCount == 0)
    }

    @Test func initDefaults_noteHistoryIsEmpty() {
        let memory = Memory(kind: .acquired)
        #expect(memory.noteHistory.isEmpty)
    }

    @Test func initDefaults_itemIsNil() {
        let memory = Memory(kind: .gifted)
        #expect(memory.item == nil)
    }

    // MARK: - NoteHistory: append, do not replace

    @Test func noteHistory_appendPreservesOlderEntries() {
        var memory = Memory(kind: .annotated, note: "First thought")
        let first = HistoryEntry(note: "First thought")
        memory.noteHistory.append(first)

        memory.note = "Revised thought"
        let second = HistoryEntry(note: "Revised thought")
        memory.noteHistory.append(second)

        // Both entries survive — append semantics, not replace
        #expect(memory.noteHistory.count == 2)
        #expect(memory.noteHistory[0].note == "First thought")
        #expect(memory.noteHistory[1].note == "Revised thought")
    }

    @Test func noteHistory_editedAtIsOrderedAscending() throws {
        var memory = Memory(kind: .read)
        let t1 = Date(timeIntervalSince1970: 1_000_000)
        let t2 = Date(timeIntervalSince1970: 2_000_000)
        memory.noteHistory.append(HistoryEntry(note: "v1", editedAt: t1))
        memory.noteHistory.append(HistoryEntry(note: "v2", editedAt: t2))

        let first = try #require(memory.noteHistory.first)
        let last = try #require(memory.noteHistory.last)
        #expect(first.editedAt < last.editedAt)
    }

    // MARK: - Parent Item Attachment

    @Test func parentItem_attachAndPersist() throws {
        let container = try makeContainer()
        let context = container.mainContext

        let item = Item(title: "Neuromancer", medium: .book)
        let memory = Memory(kind: .read, note: "Cyberpunk masterpiece")
        context.insert(item)
        context.insert(memory)
        memory.item = item
        item.memories.append(memory)
        try context.save()

        let descriptor = FetchDescriptor<Memory>()
        let results = try context.fetch(descriptor)
        let fetched = try #require(results.first)
        let parentItem = try #require(fetched.item)
        #expect(parentItem.title == "Neuromancer")
    }

    @Test func parentItem_cascadeDelete() throws {
        let container = try makeContainer()
        let context = container.mainContext

        let item = Item(title: "The Road", medium: .book)
        let memory = Memory(kind: .read)
        context.insert(item)
        context.insert(memory)
        memory.item = item
        item.memories.append(memory)
        try context.save()

        context.delete(item)
        try context.save()

        let memDescriptor = FetchDescriptor<Memory>()
        let memories = try context.fetch(memDescriptor)
        // cascade delete should remove the orphaned memory
        #expect(memories.isEmpty)
    }

    // MARK: - HistoryEntry Codable

    @Test func historyEntry_codableRoundTrip() throws {
        let entry = HistoryEntry(note: "Hello", editedAt: Date(timeIntervalSince1970: 0))
        let data = try JSONEncoder().encode(entry)
        let decoded = try JSONDecoder().decode(HistoryEntry.self, from: data)
        #expect(decoded.note == entry.note)
        #expect(decoded.editedAt == entry.editedAt)
    }
}
