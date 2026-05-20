// AttachmentModelTests.swift — InventoryCoreTests
// Still Hours v0.1 MVP — Pre-flight Round 4 unit tests
// Date: 2026-05-20

import Testing
import SwiftData
import Foundation
@testable import InventoryCore

@MainActor
struct AttachmentModelTests {

    private func makeContainer() throws -> ModelContainer {
        try ModelContainer(
            for: SchemaV1.schema,
            configurations: ModelConfiguration(isStoredInMemoryOnly: true)
        )
    }

    // MARK: - AttachmentKind — all 4 cases

    @Test func attachmentKind_allFourCasesPresent() {
        let cases = AttachmentKind.allCases
        #expect(cases.count == 4)
        #expect(cases.contains(.photo))
        #expect(cases.contains(.voice))
        #expect(cases.contains(.receipt))
        #expect(cases.contains(.document))
    }

    @Test func attachmentKind_rawValues() {
        #expect(AttachmentKind.photo.rawValue == "photo")
        #expect(AttachmentKind.voice.rawValue == "voice")
        #expect(AttachmentKind.receipt.rawValue == "receipt")
        #expect(AttachmentKind.document.rawValue == "document")
    }

    // MARK: - Init Defaults

    @Test func initDefaults_thumbnailPathNil() {
        let attachment = Attachment(kind: .photo, path: "photos/cover.jpg")
        #expect(attachment.thumbnailPath == nil)
    }

    @Test func initDefaults_captionNil() {
        let attachment = Attachment(kind: .voice, path: "audio/note.m4a")
        #expect(attachment.caption == nil)
    }

    @Test func initDefaults_itemIsNil() {
        let attachment = Attachment(kind: .receipt, path: "receipts/amazon.pdf")
        #expect(attachment.item == nil)
    }

    // MARK: - Parent Item Linkage

    @Test func parentItem_linkAndPersist() throws {
        let container = try makeContainer()
        let context = container.mainContext

        let item = Item(title: "Leica M6", medium: .object)
        let attachment = Attachment(kind: .photo, path: "photos/leica_front.jpg")
        context.insert(item)
        context.insert(attachment)
        attachment.item = item
        item.attachments.append(attachment)
        try context.save()

        let descriptor = FetchDescriptor<InventoryCore.Attachment>()
        let results = try context.fetch(descriptor)
        let fetched = try #require(results.first)
        let parentItem = try #require(fetched.item)
        #expect(parentItem.title == "Leica M6")
    }

    // MARK: - Parent Memory Linkage (via Memory.photos)

    @Test func parentMemory_photoLinkAndPersist() throws {
        let container = try makeContainer()
        let context = container.mainContext

        let item = Item(title: "The Waves", medium: .book)
        let memory = Memory(kind: .read)
        let photo = Attachment(kind: .photo, path: "photos/page_spread.heic", caption: "A beautiful spread")
        context.insert(item)
        context.insert(memory)
        context.insert(photo)
        memory.item = item
        memory.photos.append(photo)
        try context.save()

        let descriptor = FetchDescriptor<Memory>()
        let results = try context.fetch(descriptor)
        let fetched = try #require(results.first)
        #expect(fetched.photos.count == 1)
        let fetchedPhoto = try #require(fetched.photos.first)
        #expect(fetchedPhoto.path == "photos/page_spread.heic")
        let caption = try #require(fetchedPhoto.caption)
        #expect(caption == "A beautiful spread")
    }

    @Test func parentMemory_cascadeDeleteRemovesPhotos() throws {
        let container = try makeContainer()
        let context = container.mainContext

        let item = Item(title: "Invisible Cities", medium: .book)
        let memory = Memory(kind: .annotated)
        let photo = Attachment(kind: .photo, path: "photos/annotation.jpg")
        context.insert(item)
        context.insert(memory)
        context.insert(photo)
        memory.item = item
        memory.photos.append(photo)
        try context.save()

        context.delete(memory)
        try context.save()

        // Disambiguate from `Testing.Attachment` (Swift Testing's artifact type).
        let remaining: [InventoryCore.Attachment] = try context.fetch(FetchDescriptor())
        // cascade from Memory.photos should remove the photo attachment
        #expect(remaining.isEmpty)
    }

    // MARK: - Path and Metadata

    @Test func attachment_pathAndThumbnail() throws {
        let attachment = Attachment(
            kind: .photo,
            path: "photos/original.jpg",
            thumbnailPath: "photos/thumb.jpg"
        )
        #expect(attachment.path == "photos/original.jpg")
        let thumb = try #require(attachment.thumbnailPath)
        #expect(thumb == "photos/thumb.jpg")
    }

    @Test func attachment_documentKindWithCaption() throws {
        let attachment = Attachment(
            kind: .document,
            path: "docs/warranty.pdf",
            caption: "Warranty card"
        )
        #expect(attachment.kind == .document)
        let caption = try #require(attachment.caption)
        #expect(caption == "Warranty card")
    }
}
