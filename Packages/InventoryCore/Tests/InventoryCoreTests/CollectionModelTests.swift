// CollectionModelTests.swift — InventoryCoreTests
// Still Hours v0.1 MVP — Pre-flight Round 4 unit tests
// Date: 2026-05-20

import Testing
import SwiftData
import Foundation
@testable import InventoryCore

@MainActor
struct CollectionModelTests {

    private func makeContainer() throws -> ModelContainer {
        try ModelContainer(
            for: SchemaV1.schema,
            configurations: ModelConfiguration(isStoredInMemoryOnly: true)
        )
    }

    // MARK: - Init Defaults

    @Test func initDefaults_itemsEmpty() {
        let col = Collection(title: "Favourites")
        #expect(col.items.isEmpty)
    }

    @Test func initDefaults_itemOrderEmpty() {
        let col = Collection(title: "Favourites")
        #expect(col.itemOrder.isEmpty)
    }

    @Test func initDefaults_notPinnedToHome() {
        let col = Collection(title: "Favourites")
        #expect(col.pinnedToHome == false)
    }

    @Test func initDefaults_smartFilterNil() {
        let col = Collection(title: "Favourites")
        #expect(col.smartFilter == nil)
    }

    // MARK: - Ordered Items (itemOrder respects insertion sequence)

    @Test func itemOrder_preservesInsertionOrder() throws {
        let container = try makeContainer()
        let context = container.mainContext

        let col = Collection(title: "Reading List")
        let a = Item(title: "A", medium: .book)
        let b = Item(title: "B", medium: .book)
        let c = Item(title: "C", medium: .book)

        context.insert(col)
        context.insert(a)
        context.insert(b)
        context.insert(c)

        col.items.append(contentsOf: [a, b, c])
        col.itemOrder.append(contentsOf: [a.id, b.id, c.id])
        try context.save()

        let descriptor = FetchDescriptor<InventoryCore.Collection>()
        let results = try context.fetch(descriptor)
        let fetched = try #require(results.first)
        #expect(fetched.itemOrder.count == 3)
        #expect(fetched.itemOrder[0] == a.id)
        #expect(fetched.itemOrder[1] == b.id)
        #expect(fetched.itemOrder[2] == c.id)
    }

    @Test func itemOrder_independentFromItemsRelationshipOrder() throws {
        // itemOrder is the authoritative ordering; items relationship may differ.
        let col = Collection(title: "Custom Order")
        let id1 = UUID()
        let id2 = UUID()
        col.itemOrder = [id2, id1] // explicit reverse order
        #expect(col.itemOrder[0] == id2)
        #expect(col.itemOrder[1] == id1)
    }

    // MARK: - SmartFilterRule Predicate Sanity

    @Test func smartFilter_mediumFilterOnlyBooks() {
        let rule = SmartFilterRule(mediumFilter: [.book])
        let mediumFilter = rule.mediumFilter
        #expect(mediumFilter != nil)
        #expect(mediumFilter?.contains(.book) == true)
        #expect(mediumFilter?.contains(.music) == false)
    }

    @Test func smartFilter_stateFilterOwnedAndLent() {
        let rule = SmartFilterRule(stateFilter: [.owned, .lent])
        let stateFilter = rule.stateFilter
        #expect(stateFilter?.count == 2)
        #expect(stateFilter?.contains(.owned) == true)
        #expect(stateFilter?.contains(.lent) == true)
        #expect(stateFilter?.contains(.lost) == false)
    }

    @Test func smartFilter_tagFilterAllRequired() {
        let rule = SmartFilterRule(tagFilter: ["japan", "photography"])
        let tagFilter = rule.tagFilter
        #expect(tagFilter?.count == 2)
        #expect(tagFilter?.contains("japan") == true)
    }

    @Test func smartFilter_dateRangeSanity() throws {
        let start = Date(timeIntervalSince1970: 0)
        let end = Date(timeIntervalSince1970: 86_400)
        let interval = DateInterval(start: start, end: end)
        let rule = SmartFilterRule(dateRange: interval)
        let dateRange = try #require(rule.dateRange)
        #expect(dateRange.start == start)
        #expect(dateRange.end == end)
        #expect(dateRange.duration == 86_400)
    }

    @Test func smartFilter_allNilMeansNoConstraint() {
        let rule = SmartFilterRule()
        #expect(rule.mediumFilter == nil)
        #expect(rule.stateFilter == nil)
        #expect(rule.tagFilter == nil)
        #expect(rule.dateRange == nil)
    }

    // MARK: - SmartFilterRule Codable

    @Test func smartFilter_codableRoundTrip() throws {
        let rule = SmartFilterRule(mediumFilter: [.book, .music], stateFilter: [.owned])
        let data = try JSONEncoder().encode(rule)
        let decoded = try JSONDecoder().decode(SmartFilterRule.self, from: data)
        #expect(decoded.mediumFilter == rule.mediumFilter)
        #expect(decoded.stateFilter == rule.stateFilter)
    }

    // MARK: - Persistence

    @Test func persistCollection_insertAndFetch() throws {
        let container = try makeContainer()
        let context = container.mainContext
        let col = Collection(title: "Jazz Records")
        context.insert(col)
        try context.save()

        let descriptor = FetchDescriptor<InventoryCore.Collection>()
        let results = try context.fetch(descriptor)
        #expect(results.count == 1)
        #expect(results[0].title == "Jazz Records")
    }
}
