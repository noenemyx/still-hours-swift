// Collection.swift — InventoryCore
// Still Hours v0.1 MVP — PRD §7 Data Model
// LINT-IGNORE: Privacy — no external URL

import Foundation
import SwiftData

// MARK: - Supporting Types

/// Declarative filter rules for a smart ``Collection``.
///
/// All conditions are AND-combined. `nil` means "no constraint on this axis."
public struct SmartFilterRule: Codable, Sendable {
    /// Restrict to items matching any of these medium types.
    public var mediumFilter: [Medium]?
    /// Restrict to items matching any of these states.
    public var stateFilter: [ItemState]?
    /// Restrict to items that carry ALL of these tags.
    public var tagFilter: [String]?
    /// Restrict to items whose first memory falls within this date range.
    public var dateRange: DateInterval?

    public init(
        mediumFilter: [Medium]? = nil,
        stateFilter: [ItemState]? = nil,
        tagFilter: [String]? = nil,
        dateRange: DateInterval? = nil
    ) {
        self.mediumFilter = mediumFilter
        self.stateFilter = stateFilter
        self.tagFilter = tagFilter
        self.dateRange = dateRange
    }
}

// MARK: - Model

/// A named, ordered group of ``Item``s — either curated or smart-filtered.
///
/// Collections support many-to-many membership with explicit ordering via
/// ``itemOrder``. A `smartFilter` turns the collection into a live query;
/// when set, ``items`` is populated at display time rather than stored.
@available(iOS 26, macOS 26, *)
@Model
public final class Collection {

    // MARK: Identity

    /// Stable, globally unique identifier.
    @Attribute(.unique) public var id: UUID

    /// Display name of the collection.
    public var title: String

    /// Optional longer description shown on the collection detail screen.
    public var collectionDescription: String?

    // MARK: Items (M:N)

    /// Items belonging to this collection (many-to-many).
    @Relationship public var items: [Item]

    /// Explicit ordering of item IDs within this collection.
    ///
    /// Maintained in parallel with ``items``; consumers must respect this
    /// array when rendering ordered lists.
    public var itemOrder: [UUID]

    // MARK: Cover

    /// The ID of the item whose cover should represent this collection.
    ///
    /// `nil` — auto-select the most-recently-added item's cover.
    public var coverItemID: UUID?

    // MARK: Home

    /// Whether this collection is pinned to the home / overview screen.
    public var pinnedToHome: Bool

    // MARK: Smart Filter

    /// When non-nil, this collection behaves as a saved smart search.
    public var smartFilter: SmartFilterRule?

    // MARK: Timestamps

    /// When this collection was created.
    public var createdAt: Date

    /// When this collection was last modified.
    public var updatedAt: Date

    // MARK: Initialiser

    public init(
        id: UUID = UUID(),
        title: String,
        collectionDescription: String? = nil,
        itemOrder: [UUID] = [],
        coverItemID: UUID? = nil,
        pinnedToHome: Bool = false,
        smartFilter: SmartFilterRule? = nil,
        createdAt: Date = Date(),
        updatedAt: Date = Date()
    ) {
        self.id = id
        self.title = title
        self.collectionDescription = collectionDescription
        self.items = []
        self.itemOrder = itemOrder
        self.coverItemID = coverItemID
        self.pinnedToHome = pinnedToHome
        self.smartFilter = smartFilter
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }
}

// MARK: - Encodable (Data Sovereignty export — Promise lint #2)

@available(iOS 26, macOS 26, *)
extension Collection: Encodable {
    enum CodingKeys: String, CodingKey {
        case id, title, collectionDescription, itemOrder, coverItemID,
             pinnedToHome, smartFilter, createdAt, updatedAt
    }

    public func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(title, forKey: .title)
        try container.encodeIfPresent(collectionDescription, forKey: .collectionDescription)
        try container.encode(itemOrder, forKey: .itemOrder)
        try container.encodeIfPresent(coverItemID, forKey: .coverItemID)
        try container.encode(pinnedToHome, forKey: .pinnedToHome)
        try container.encodeIfPresent(smartFilter, forKey: .smartFilter)
        try container.encode(createdAt, forKey: .createdAt)
        try container.encode(updatedAt, forKey: .updatedAt)
    }
}
