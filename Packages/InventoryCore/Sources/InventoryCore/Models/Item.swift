// Item.swift — InventoryCore
// Still Hours v0.1 MVP — PRD §7 Data Model
// LINT-IGNORE: Privacy — no external URL

import Foundation
import SwiftData

// MARK: - Enumerations

/// The medium type of an ``Item``.
public enum Medium: String, Codable, CaseIterable, Sendable {
    /// A physical or digital book.
    case book
    /// A music album or track.
    case music
    /// A film or video.
    case movie
    /// A physical object or collectible.
    case object
    /// A place — cafe, bookshop, gallery, travel destination, etc.
    case place
}

/// The current ownership / disposition state of an ``Item``.
public enum ItemState: String, Codable, CaseIterable, Sendable {
    /// Item is in the user's possession.
    case owned
    /// Item has been lent to someone.
    case lent
    /// Item was gifted away by the user.
    case giftedOut
    /// Item is missing or lost.
    case lost
    /// Item exists only in digital form (no physical copy).
    case digitalOnly
    /// Item has been archived / retired from active use.
    case archived
}

// MARK: - Model

/// A single catalogued possession — book, record, film, or object.
///
/// `Item` is the central entity in Still Hours. Every ``Memory``,
/// ``Collection`` membership, and ``Attachment`` hangs off an `Item`.
@available(iOS 26, macOS 26, *)
@Model
public final class Item {

    // MARK: Identity

    /// Stable, globally unique identifier. Never changes after creation.
    @Attribute(.unique) public var id: UUID

    /// Human-readable title (book name, album title, film title, …).
    public var title: String

    /// Creator credit — author, artist, director, manufacturer, etc.
    public var creator: String?

    /// Year of original publication / release / manufacture.
    public var year: Int?

    /// Medium classification.
    public var medium: Medium

    // MARK: State

    /// Current ownership / disposition state.
    public var state: ItemState

    // MARK: Taxonomy

    /// Free-form tags for cross-medium search and personal organisation.
    public var tags: [String]

    // MARK: Cover

    /// Raw JPEG/PNG data for the item's cover image (thumbnail-sized).
    ///
    /// Stored inline in SwiftData store; large originals should live in
    /// the file system referenced via an ``Attachment``.
    public var coverImageData: Data?

    // MARK: Relationships

    /// All memory entries recorded for this item.
    ///
    /// Deleted together with the item (`cascade`).
    @Relationship(deleteRule: .cascade, inverse: \Memory.item)
    public var memories: [Memory]

    /// Collections this item belongs to (many-to-many).
    @Relationship(inverse: \Collection.items)
    public var collections: [Collection]

    /// File attachments associated with this item (photos, receipts, …).
    ///
    /// Deleted together with the item (`cascade`).
    @Relationship(deleteRule: .cascade, inverse: \Attachment.item)
    public var attachments: [Attachment]

    // MARK: External Identity (SchemaV2)

    /// Stable identifier from the originating source — ISBN, TMDB id,
    /// Naver productId, etc. `nil` for manually-entered items.
    ///
    /// Used as the primary deduplication key in ``CurationAdoptionService``
    /// when present; falls back to `(medium, title, creator)` otherwise.
    public var externalID: String?

    /// Raw value of the ``SearchSource`` enum that produced this item
    /// (e.g. "naverBook", "iTunes", "kobis", "manualEntry").
    /// `nil` for items entered before SchemaV2.
    public var source: String?

    /// Publisher, label, or studio associated with this item.
    ///
    /// First-class field as of SchemaV2; previously stored as a
    /// "publisher:<value>" tag hack in ``CurationAdoptionService``.
    public var publisher: String?

    // MARK: Timestamps

    /// When this item record was first created.
    public var createdAt: Date

    /// When this item record was last modified.
    public var updatedAt: Date

    // MARK: Initialiser

    public init(
        id: UUID = UUID(),
        title: String,
        creator: String? = nil,
        year: Int? = nil,
        medium: Medium,
        state: ItemState = .owned,
        tags: [String] = [],
        coverImageData: Data? = nil,
        externalID: String? = nil,
        source: String? = nil,
        publisher: String? = nil,
        createdAt: Date = Date(),
        updatedAt: Date = Date()
    ) {
        self.id = id
        self.title = title
        self.creator = creator
        self.year = year
        self.medium = medium
        self.state = state
        self.tags = tags
        self.coverImageData = coverImageData
        self.externalID = externalID
        self.source = source
        self.publisher = publisher
        self.memories = []
        self.collections = []
        self.attachments = []
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }
}

// MARK: - Encodable (Data Sovereignty export — Promise lint #2)

@available(iOS 26, macOS 26, *)
extension Item: Encodable {
    enum CodingKeys: String, CodingKey {
        case id, title, creator, year, medium, state, tags, createdAt, updatedAt
        case externalID, source, publisher
    }

    public func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(title, forKey: .title)
        try container.encodeIfPresent(creator, forKey: .creator)
        try container.encodeIfPresent(year, forKey: .year)
        try container.encode(medium, forKey: .medium)
        try container.encode(state, forKey: .state)
        try container.encode(tags, forKey: .tags)
        try container.encodeIfPresent(externalID, forKey: .externalID)
        try container.encodeIfPresent(source, forKey: .source)
        try container.encodeIfPresent(publisher, forKey: .publisher)
        try container.encode(createdAt, forKey: .createdAt)
        try container.encode(updatedAt, forKey: .updatedAt)
    }
}
