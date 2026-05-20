// ItemModelTests.swift — InventoryCoreTests
// Still Hours v0.1 MVP — Pre-flight Round 4 unit tests
// Date: 2026-05-20

import Testing
import SwiftData
import Foundation
@testable import InventoryCore

@MainActor
struct ItemModelTests {

    // MARK: - Helpers

    private func makeContainer() throws -> ModelContainer {
        try ModelContainer(
            for: SchemaV1.schema,
            configurations: ModelConfiguration(isStoredInMemoryOnly: true)
        )
    }

    // MARK: - Init Defaults

    @Test func initDefaults_stateIsOwned() throws {
        let item = Item(title: "Meditations", medium: .book)
        #expect(item.state == .owned)
    }

    @Test func initDefaults_tagsEmpty() throws {
        let item = Item(title: "Meditations", medium: .book)
        #expect(item.tags.isEmpty)
    }

    @Test func initDefaults_memoriesEmpty() throws {
        let item = Item(title: "Meditations", medium: .book)
        #expect(item.memories.isEmpty)
    }

    @Test func initDefaults_collectionsEmpty() throws {
        let item = Item(title: "Meditations", medium: .book)
        #expect(item.collections.isEmpty)
    }

    @Test func initDefaults_attachmentsEmpty() throws {
        let item = Item(title: "Meditations", medium: .book)
        #expect(item.attachments.isEmpty)
    }

    @Test func initDefaults_coverImageDataNil() throws {
        let item = Item(title: "Meditations", medium: .book)
        #expect(item.coverImageData == nil)
    }

    // MARK: - Medium Enum Cases

    @Test func medium_allCasesPresent() {
        let cases = Medium.allCases
        #expect(cases.contains(.book))
        #expect(cases.contains(.music))
        #expect(cases.contains(.movie))
        #expect(cases.contains(.object))
        #expect(cases.count == 4)
    }

    @Test func medium_rawValues() {
        #expect(Medium.book.rawValue == "book")
        #expect(Medium.music.rawValue == "music")
        #expect(Medium.movie.rawValue == "movie")
        #expect(Medium.object.rawValue == "object")
    }

    // MARK: - ItemState Enum Cases

    @Test func itemState_allCasesPresent() {
        let cases = ItemState.allCases
        #expect(cases.count == 6)
        #expect(cases.contains(.owned))
        #expect(cases.contains(.lent))
        #expect(cases.contains(.giftedOut))
        #expect(cases.contains(.lost))
        #expect(cases.contains(.digitalOnly))
        #expect(cases.contains(.archived))
    }

    // MARK: - Manifestation Work/Release Pattern

    @Test func manifestation_workPattern_bookWithYear() throws {
        let item = Item(title: "Blood Meridian", creator: "Cormac McCarthy", year: 1985, medium: .book)
        #expect(item.title == "Blood Meridian")
        let creator = try #require(item.creator)
        #expect(creator == "Cormac McCarthy")
        let year = try #require(item.year)
        #expect(year == 1985)
        #expect(item.medium == .book)
    }

    @Test func manifestation_releasePattern_musicAlbum() throws {
        let item = Item(title: "Kind of Blue", creator: "Miles Davis", year: 1959, medium: .music)
        #expect(item.medium == .music)
        let year = try #require(item.year)
        #expect(year == 1959)
    }

    @Test func manifestation_movieWithState() throws {
        let item = Item(title: "2001: A Space Odyssey", medium: .movie, state: .archived)
        #expect(item.state == .archived)
    }

    @Test func manifestation_objectNoCreator() throws {
        let item = Item(title: "Vintage Camera", medium: .object)
        #expect(item.creator == nil)
        #expect(item.year == nil)
    }

    // MARK: - ModelContainer Persistence

    @Test func persistItem_insertAndFetch() throws {
        let container = try makeContainer()
        let context = container.mainContext
        let item = Item(title: "Dune", medium: .book)
        context.insert(item)
        try context.save()

        let descriptor = FetchDescriptor<Item>()
        let results = try context.fetch(descriptor)
        #expect(results.count == 1)
        #expect(results[0].title == "Dune")
    }

    @Test func persistItem_idIsStableAfterSave() throws {
        let container = try makeContainer()
        let context = container.mainContext
        let originalID = UUID()
        let item = Item(id: originalID, title: "Steppenwolf", medium: .book)
        context.insert(item)
        try context.save()

        let descriptor = FetchDescriptor<Item>()
        let results = try context.fetch(descriptor)
        let fetched = try #require(results.first)
        #expect(fetched.id == originalID)
    }
}
