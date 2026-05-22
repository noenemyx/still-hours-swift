// DemoSeederExportIntegrationTests.swift — InventoryCoreTests
// Copyright 2026 sunghun.ahn — Still Hours R13.3
// Created: 2026-05-22
// LINT-IGNORE: Privacy — no external URL
//
// End-to-end integration: seed 8 items + memories → export JSON / CSV →
// verify round-trip structure and escaping.

#if DEBUG

import Testing
import SwiftData
import Foundation
@testable import InventoryCore

// MARK: - Decodable Mirrors

private struct LibraryPayload: Decodable {
    var items: [ItemExportMirror]
    var memories: [MemoryExportMirror]
    var collections: [CollectionExportMirror]
    var attachments: [AttachmentExportMirror]
}

private struct ItemExportMirror: Decodable {
    var id: UUID
    var title: String
    var creator: String?
    var year: Int?
    var medium: Medium
    var state: ItemState
    var tags: [String]
    var createdAt: Date
    var updatedAt: Date
}

private struct MemoryExportMirror: Decodable {
    var id: UUID
    var kind: MemoryKind
    var date: Date
    var note: String
    var photoCount: Int
    var noteHistory: [HistoryEntry]
    var createdAt: Date
}

private struct CollectionExportMirror: Decodable {
    var id: UUID
    var title: String
}

private struct AttachmentExportMirror: Decodable {
    var id: UUID
    var kind: AttachmentKind
    var path: String
}

// MARK: - Suite

@MainActor
struct DemoSeederExportIntegrationTests {

    // MARK: Helpers

    private func makeContainer() throws -> ModelContainer {
        try ModelContainer(
            for: SchemaV1.schema,
            configurations: ModelConfiguration(isStoredInMemoryOnly: true)
        )
    }

    private func makeDecoder() -> JSONDecoder {
        let d = JSONDecoder()
        d.dateDecodingStrategy = .iso8601
        return d
    }

    // MARK: - Tests

    /// Seeds the demo library, exports as JSON, decodes back, verifies all 8
    /// items are present and titles match what DemoSeederContent defines.
    @Test func seedThenJSONExport_containsAllItems() async throws {
        let container = try makeContainer()
        let context = container.mainContext

        let seeder = DemoSeeder(context: context)
        try await seeder.seedIfEmpty()

        let seededItems = try context.fetch(FetchDescriptor<Item>(sortBy: [SortDescriptor(\.title)]))
        let seededTitles = Set(seededItems.map(\.title))

        let service = ExportService(context: context)
        let jsonData = try await service.exportAllAsJSON()
        #expect(!jsonData.isEmpty)

        let payload = try makeDecoder().decode(LibraryPayload.self, from: jsonData)

        // All seeded items must appear in the export.
        #expect(payload.items.count == seededItems.count)
        let exportedTitles = Set(payload.items.map(\.title))
        #expect(exportedTitles == seededTitles)

        // Spot-check well-known titles from DemoSeederContent.
        #expect(exportedTitles.contains("Norwegian Wood"))
        #expect(exportedTitles.contains("Kind of Blue"))
        #expect(exportedTitles.contains("Leica M6"))
    }

    /// Seeds the demo library and verifies memory–item relationships survive
    /// the JSON round-trip by checking memory counts per item in the payload.
    @Test func seedThenJSONExport_preservesMemoryRelationships() async throws {
        let container = try makeContainer()
        let context = container.mainContext

        let seeder = DemoSeeder(context: context)
        try await seeder.seedIfEmpty()

        // Capture per-item memory counts before export.
        let seededItems = try context.fetch(FetchDescriptor<Item>())
        let memoriesPerTitle: [String: Int] = Dictionary(
            uniqueKeysWithValues: seededItems.map { ($0.title, $0.memories.count) }
        )

        let service = ExportService(context: context)
        let jsonData = try await service.exportAllAsJSON()
        let payload = try makeDecoder().decode(LibraryPayload.self, from: jsonData)

        // Total memories in export must equal sum of per-item memory counts.
        let totalExpected = memoriesPerTitle.values.reduce(0, +)
        #expect(payload.memories.count == totalExpected)

        // Every item must have at least one memory recorded.
        for item in seededItems {
            #expect(
                !item.memories.isEmpty,
                "Item '\(item.title)' has no memories after seeding"
            )
        }

        // "Norwegian Wood" has 3 memories in DemoSeederContent.
        let norwegianWoodMemoryCount = try #require(memoriesPerTitle["Norwegian Wood"])
        #expect(norwegianWoodMemoryCount == 3)
    }

    /// Seeds items, exports as CSV, parses the header row, and verifies all
    /// nine expected column names are present in the correct positions.
    @Test func seedThenCSVExport_columnStructure() async throws {
        let container = try makeContainer()
        let context = container.mainContext

        let seeder = DemoSeeder(context: context)
        try await seeder.seedIfEmpty()

        let service = ExportService(context: context)
        let csvData = try await service.exportAllAsCSV()

        let csvString = try #require(String(data: csvData, encoding: .utf8))
        let rows = csvString.components(separatedBy: "\n")

        // Must have a header + at least one data row.
        #expect(rows.count >= 2)

        let header = rows[0]
        let columns = header.components(separatedBy: ",")

        let expectedColumns = [
            "id", "title", "creator", "year", "medium", "state",
            "tags", "createdAt", "updatedAt"
        ]
        #expect(columns == expectedColumns)

        // Data rows must not be empty.
        let dataRows = rows.dropFirst().filter { !$0.isEmpty }
        #expect(dataRows.count >= 1)
    }

    /// Seeds a single item whose title contains a comma, a double-quote, and a
    /// newline, then verifies that exportAllAsCSV wraps and escapes it correctly
    /// per RFC 4180.
    @Test func seedThenCSVExport_csvEscaping() async throws {
        let container = try makeContainer()
        let context = container.mainContext

        // Insert one synthetic item with special characters in the title.
        let tricky = Item(
            title: "Comma, \"Quote\", and\nNewline",
            creator: nil,
            year: nil,
            medium: .book,
            state: .owned,
            tags: []
        )
        context.insert(tricky)
        try context.save()

        let service = ExportService(context: context)
        let csvData = try await service.exportAllAsCSV()

        let csvString = try #require(String(data: csvData, encoding: .utf8))

        // RFC 4180: fields containing comma, double-quote, or newline must be
        // wrapped in double-quotes, with embedded double-quotes doubled.
        #expect(csvString.contains("\"Comma, \"\"Quote\"\", and"))

        // The entire CSV must be decodable as UTF-8 (no binary garbage).
        #expect(!csvString.isEmpty)
    }

    /// Verifies that exporting an empty library produces valid, non-error JSON
    /// with all four keys present and empty arrays as values.
    @Test func exportAllAsJSON_emptyLibrary() async throws {
        let container = try makeContainer()
        let context = container.mainContext

        // No seeding — library is empty.
        let service = ExportService(context: context)
        let jsonData = try await service.exportAllAsJSON()

        #expect(!jsonData.isEmpty)

        let jsonString = try #require(String(data: jsonData, encoding: .utf8))
        #expect(!jsonString.isEmpty)

        let payload = try makeDecoder().decode(LibraryPayload.self, from: jsonData)
        #expect(payload.items.isEmpty)
        #expect(payload.memories.isEmpty)
        #expect(payload.collections.isEmpty)
        #expect(payload.attachments.isEmpty)
    }
}

#endif
