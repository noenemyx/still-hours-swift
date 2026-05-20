// Memory.swift — InventoryCore
// Still Hours v0.1 MVP — PRD §7 Data Model
// LINT-IGNORE: Privacy — no external URL

import Foundation
import SwiftData

// MARK: - Enumerations

/// The kind of interaction a ``Memory`` records.
public enum MemoryKind: String, Codable, CaseIterable, Sendable {
    /// Item was acquired (bought, found, received).
    case acquired
    /// A reading session or completion.
    case read
    /// A listening session or play-through.
    case listened
    /// A viewing / watch session.
    case watched
    /// Item was lent to another person.
    case lent
    /// Item was received back after a loan.
    case received
    /// Item was gifted to another person.
    case gifted
    /// An annotation, highlight, or note was added.
    case annotated
}

// MARK: - Supporting Types

/// A single revision snapshot of a memory note (10-year tool — PRD T5.5).
///
/// Stored as a Codable array on ``Memory`` — no separate entity in v0.1.
public struct HistoryEntry: Codable, Sendable {
    /// The note text at the time of this revision.
    public var note: String
    /// When this revision was saved.
    public var editedAt: Date

    public init(note: String, editedAt: Date = Date()) {
        self.note = note
        self.editedAt = editedAt
    }
}

// MARK: - Model

/// A single recorded interaction between a person and an ``Item``.
///
/// Memories are the narrative layer of Still Hours — they capture
/// *when* and *how* the user engaged with an item, along with an
/// optional freeform note, photos, and voice notes.
@available(iOS 26, macOS 26, *)
@Model
public final class Memory {

    // MARK: Identity

    /// Stable, globally unique identifier.
    @Attribute(.unique) public var id: UUID

    // MARK: Core

    /// The interaction type.
    public var kind: MemoryKind

    /// The user-specified date of the interaction (not necessarily wall-clock now).
    public var date: Date

    /// Freeform note in plain text / lightweight Markdown.
    public var note: String

    // MARK: Media

    /// Cached count of attached photos (denormalised for list-view performance).
    public var photoCount: Int

    /// Optional path to a recorded voice note in the app's container.
    public var voiceNotePath: String?

    // MARK: Edit History

    /// Ordered revisions of `note`, oldest first (PRD T5.5).
    public var noteHistory: [HistoryEntry]

    // MARK: Relationships

    /// The item this memory belongs to.
    public var item: Item?

    /// Photo attachments for this memory.
    ///
    /// Deleted together with the memory (`cascade`).
    @Relationship(deleteRule: .cascade)
    public var photos: [Attachment]

    // MARK: Timestamps

    /// When this memory record was created.
    public var createdAt: Date

    // MARK: Initialiser

    public init(
        id: UUID = UUID(),
        kind: MemoryKind,
        date: Date = Date(),
        note: String = "",
        voiceNotePath: String? = nil,
        createdAt: Date = Date()
    ) {
        self.id = id
        self.kind = kind
        self.date = date
        self.note = note
        self.photoCount = 0
        self.voiceNotePath = voiceNotePath
        self.noteHistory = []
        self.item = nil
        self.photos = []
        self.createdAt = createdAt
    }
}

// MARK: - Encodable (Data Sovereignty export — Promise lint #2)

@available(iOS 26, macOS 26, *)
extension Memory: Encodable {
    enum CodingKeys: String, CodingKey {
        case id, kind, date, note, photoCount, voiceNotePath, noteHistory, createdAt
    }

    public func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(kind, forKey: .kind)
        try container.encode(date, forKey: .date)
        try container.encode(note, forKey: .note)
        try container.encode(photoCount, forKey: .photoCount)
        try container.encodeIfPresent(voiceNotePath, forKey: .voiceNotePath)
        try container.encode(noteHistory, forKey: .noteHistory)
        try container.encode(createdAt, forKey: .createdAt)
    }
}
