// CurationAdoptionServiceTests.swift — InventoryCoreTests
// Build #9 — CurationAdoptionService public API coverage
// Date: 2026-05-24

import Testing
import SwiftData
import Foundation
@testable import InventoryCore

@MainActor
struct CurationAdoptionServiceTests {

    // MARK: - Helpers

    @available(iOS 26, macOS 26, *)
    private func makeContainer() throws -> ModelContainer {
        try ModelContainer(
            for: SchemaV2.schema,
            configurations: ModelConfiguration(isStoredInMemoryOnly: true, cloudKitDatabase: .none)
        )
    }

    private func makeResult(
        id: String = UUID().uuidString,
        medium: Medium = .book,
        title: String = "Test Title",
        creator: String? = "Test Creator",
        externalID: String? = "ext-001",
        source: SearchSource = .mockBook,
        publisher: String? = "Test Publisher"
    ) -> SearchResult {
        SearchResult(
            id: id,
            medium: medium,
            title: title,
            creator: creator,
            externalID: externalID,
            source: source,
            publisher: publisher
        )
    }

    @available(iOS 26, macOS 26, *)
    private func fetchAll(from context: ModelContext) throws -> [Item] {
        try context.fetch(FetchDescriptor<Item>())
    }

    // MARK: - Test A: adopt new SearchResult → creates Item with correct fields

    @available(iOS 26, macOS 26, *)
    @Test func adopt_newResult_createsItemWithCorrectFields() async throws {
        let container = try makeContainer()
        let context = container.mainContext
        let service = CurationAdoptionService()

        let result = makeResult(
            medium: .book,
            title: "Dune",
            creator: "Frank Herbert",
            externalID: "isbn-0000001",
            source: .mockBook,
            publisher: "Chilton Books"
        )

        let item = try await service.adopt(result, into: context)

        #expect(item.title == "Dune")
        #expect(item.creator == "Frank Herbert")
        #expect(item.medium == .book)
        #expect(item.externalID == "isbn-0000001")
        #expect(item.source == SearchSource.mockBook.rawValue)
        #expect(item.publisher == "Chilton Books")

        let all = try fetchAll(from: context)
        #expect(all.count == 1)
    }

    // MARK: - Test B: externalID-based dedup — same externalID → same Item, count stays 1

    @available(iOS 26, macOS 26, *)
    @Test func adopt_sameExternalID_returnsSameItemNoDuplicate() async throws {
        let container = try makeContainer()
        let context = container.mainContext
        let service = CurationAdoptionService()

        let result1 = makeResult(id: "r1", title: "Dune", externalID: "isbn-dedup-001")
        let result2 = makeResult(id: "r2", title: "Dune", externalID: "isbn-dedup-001")

        let item1 = try await service.adopt(result1, into: context)
        let item2 = try await service.adopt(result2, into: context)

        #expect(item1.id == item2.id)
        let all = try fetchAll(from: context)
        #expect(all.count == 1)
    }

    // MARK: - Test C: fallback dedup by (medium, title, creator) when externalID is nil

    @available(iOS 26, macOS 26, *)
    @Test func adopt_nilExternalID_sameMetadata_returnsSameItem() async throws {
        let container = try makeContainer()
        let context = container.mainContext
        let service = CurationAdoptionService()

        let result1 = SearchResult(
            id: "r1",
            medium: .object,
            title: "Vintage Camera",
            creator: "Leica",
            externalID: nil,
            source: .mockObject
        )
        let result2 = SearchResult(
            id: "r2",
            medium: .object,
            title: "Vintage Camera",
            creator: "Leica",
            externalID: nil,
            source: .mockObject
        )

        let item1 = try await service.adopt(result1, into: context)
        let item2 = try await service.adopt(result2, into: context)

        #expect(item1.id == item2.id)
        let all = try fetchAll(from: context)
        #expect(all.count == 1)
    }

    // MARK: - Test D: different externalID → 2 distinct Items

    @available(iOS 26, macOS 26, *)
    @Test func adopt_differentExternalIDs_createsTwoDistinctItems() async throws {
        let container = try makeContainer()
        let context = container.mainContext
        let service = CurationAdoptionService()

        let result1 = makeResult(id: "r1", title: "Book A", externalID: "ext-aaa")
        let result2 = makeResult(id: "r2", title: "Book B", externalID: "ext-bbb")

        let item1 = try await service.adopt(result1, into: context)
        let item2 = try await service.adopt(result2, into: context)

        #expect(item1.id != item2.id)
        let all = try fetchAll(from: context)
        #expect(all.count == 2)
    }
}
