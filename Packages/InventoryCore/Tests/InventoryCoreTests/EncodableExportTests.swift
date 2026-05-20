// EncodableExportTests.swift — InventoryCoreTests
// Still Hours v0.1 MVP — Pre-flight Round 4 unit tests
// Date: 2026-05-20
//
// Verifies Promise lint #2: Data Sovereignty — plaintext export.
// Each entity's Encodable extension is exercised via JSON encode → decode → equality.
// A silent break in the Encodable extension (missing key, wrong type) will fail here.

import Testing
import SwiftData
import Foundation
@testable import InventoryCore

// MARK: - Decodable Mirrors
// Lightweight decode-only structs matching each entity's CodingKeys.
// Defined locally — no production code impact.

private struct ItemExport: Decodable {
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

private struct MemoryExport: Decodable {
    var id: UUID
    var kind: MemoryKind
    var date: Date
    var note: String
    var photoCount: Int
    var voiceNotePath: String?
    var noteHistory: [HistoryEntry]
    var createdAt: Date
}

private struct CollectionExport: Decodable {
    var id: UUID
    var title: String
    var collectionDescription: String?
    var itemOrder: [UUID]
    var coverItemID: UUID?
    var pinnedToHome: Bool
    var smartFilter: SmartFilterRule?
    var createdAt: Date
    var updatedAt: Date
}

private struct AttachmentExport: Decodable {
    var id: UUID
    var kind: AttachmentKind
    var path: String
    var thumbnailPath: String?
    var caption: String?
    var createdAt: Date
}

// MARK: - Tests

struct EncodableExportTests {

    private let encoder: JSONEncoder = {
        let e = JSONEncoder()
        e.dateEncodingStrategy = .iso8601
        return e
    }()

    private let decoder: JSONDecoder = {
        let d = JSONDecoder()
        d.dateDecodingStrategy = .iso8601
        return d
    }()

    // MARK: - Item

    @Test func item_jsonRoundTrip_identityPreserved() throws {
        let fixedID = UUID()
        let fixedDate = Date(timeIntervalSince1970: 1_748_736_000)
        let item = Item(
            id: fixedID,
            title: "Never Let Me Go",
            creator: "Kazuo Ishiguro",
            year: 2005,
            medium: .book,
            state: .owned,
            tags: ["fiction", "dystopia"],
            createdAt: fixedDate,
            updatedAt: fixedDate
        )

        let data = try encoder.encode(item)
        let decoded = try decoder.decode(ItemExport.self, from: data)

        #expect(decoded.id == fixedID)
        #expect(decoded.title == "Never Let Me Go")
        let creator = try #require(decoded.creator)
        #expect(creator == "Kazuo Ishiguro")
        let year = try #require(decoded.year)
        #expect(year == 2005)
        #expect(decoded.medium == .book)
        #expect(decoded.state == .owned)
        #expect(decoded.tags == ["fiction", "dystopia"])
    }

    @Test func item_jsonRoundTrip_optionalFieldsAbsent() throws {
        let item = Item(title: "Untitled", medium: .object)
        let data = try encoder.encode(item)
        let decoded = try decoder.decode(ItemExport.self, from: data)
        #expect(decoded.creator == nil)
        #expect(decoded.year == nil)
    }

    // MARK: - Memory

    @Test func memory_jsonRoundTrip_identityPreserved() throws {
        let fixedID = UUID()
        let fixedDate = Date(timeIntervalSince1970: 1_748_736_000)
        let memory = Memory(
            id: fixedID,
            kind: .listened,
            date: fixedDate,
            note: "Felt like rain",
            createdAt: fixedDate
        )
        memory.noteHistory.append(HistoryEntry(note: "Felt like rain", editedAt: fixedDate))

        let data = try encoder.encode(memory)
        let decoded = try decoder.decode(MemoryExport.self, from: data)

        #expect(decoded.id == fixedID)
        #expect(decoded.kind == .listened)
        #expect(decoded.note == "Felt like rain")
        #expect(decoded.photoCount == 0)
        #expect(decoded.noteHistory.count == 1)
        #expect(decoded.noteHistory[0].note == "Felt like rain")
    }

    @Test func memory_jsonRoundTrip_allEightKindsEncode() throws {
        for kind in MemoryKind.allCases {
            let memory = Memory(kind: kind)
            let data = try encoder.encode(memory)
            let decoded = try decoder.decode(MemoryExport.self, from: data)
            #expect(decoded.kind == kind, "Kind \(kind.rawValue) failed round-trip")
        }
    }

    // MARK: - Collection

    @Test func collection_jsonRoundTrip_identityPreserved() throws {
        let fixedID = UUID()
        let fixedDate = Date(timeIntervalSince1970: 1_748_736_000)
        let orderID = UUID()
        let rule = SmartFilterRule(mediumFilter: [.book], stateFilter: [.owned])
        let col = Collection(
            id: fixedID,
            title: "Must Read",
            collectionDescription: "The greats",
            itemOrder: [orderID],
            pinnedToHome: true,
            smartFilter: rule,
            createdAt: fixedDate,
            updatedAt: fixedDate
        )

        let data = try encoder.encode(col)
        let decoded = try decoder.decode(CollectionExport.self, from: data)

        #expect(decoded.id == fixedID)
        #expect(decoded.title == "Must Read")
        let desc = try #require(decoded.collectionDescription)
        #expect(desc == "The greats")
        #expect(decoded.itemOrder == [orderID])
        #expect(decoded.pinnedToHome == true)
        let decodedFilter = try #require(decoded.smartFilter)
        #expect(decodedFilter.mediumFilter?.contains(.book) == true)
    }

    @Test func collection_jsonRoundTrip_noSmartFilter() throws {
        let col = Collection(title: "Curated")
        let data = try encoder.encode(col)
        let decoded = try decoder.decode(CollectionExport.self, from: data)
        #expect(decoded.smartFilter == nil)
    }

    // MARK: - Attachment

    @Test func attachment_jsonRoundTrip_identityPreserved() throws {
        let fixedID = UUID()
        let fixedDate = Date(timeIntervalSince1970: 1_748_736_000)
        let attachment = Attachment(
            id: fixedID,
            kind: .receipt,
            path: "receipts/bookshop.pdf",
            thumbnailPath: "receipts/thumb.jpg",
            caption: "Proof of purchase",
            createdAt: fixedDate
        )

        let data = try encoder.encode(attachment)
        let decoded = try decoder.decode(AttachmentExport.self, from: data)

        #expect(decoded.id == fixedID)
        #expect(decoded.kind == .receipt)
        #expect(decoded.path == "receipts/bookshop.pdf")
        let thumb = try #require(decoded.thumbnailPath)
        #expect(thumb == "receipts/thumb.jpg")
        let caption = try #require(decoded.caption)
        #expect(caption == "Proof of purchase")
    }

    @Test func attachment_jsonRoundTrip_allFourKindsEncode() throws {
        for kind in AttachmentKind.allCases {
            let attachment = Attachment(kind: kind, path: "test/file")
            let data = try encoder.encode(attachment)
            let decoded = try decoder.decode(AttachmentExport.self, from: data)
            #expect(decoded.kind == kind, "Kind \(kind.rawValue) failed round-trip")
        }
    }

    // MARK: - JSON is valid UTF-8 plaintext (Promise lint #2 direct check)

    @Test func allEntities_exportedJsonIsValidUTF8() throws {
        let item = Item(title: "Test", medium: .book)
        let memory = Memory(kind: .read)
        let col = Collection(title: "Test Collection")
        let attachment = Attachment(kind: .photo, path: "test.jpg")

        for data in [
            try encoder.encode(item),
            try encoder.encode(memory),
            try encoder.encode(col),
            try encoder.encode(attachment),
        ] {
            let string = try #require(String(data: data, encoding: .utf8))
            #expect(!string.isEmpty)
            // Must be parseable as JSON (not binary garbage)
            let parsed = try JSONSerialization.jsonObject(with: data)
            #expect(parsed is [String: Any])
        }
    }
}
