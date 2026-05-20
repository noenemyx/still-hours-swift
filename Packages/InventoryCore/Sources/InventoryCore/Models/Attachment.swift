// Attachment.swift — InventoryCore
// Still Hours v0.1 MVP — PRD §7 Data Model
// LINT-IGNORE: Privacy — no external URL

import Foundation
import SwiftData

// MARK: - Enumerations

/// The kind of file an ``Attachment`` represents.
public enum AttachmentKind: String, Codable, CaseIterable, Sendable {
    /// A photo or image (JPEG, PNG, HEIC, …).
    case photo
    /// A voice / audio note (m4a, mp3, …).
    case voice
    /// A purchase receipt (PDF, image, …).
    case receipt
    /// A generic document (PDF, text, …).
    case document
}

// MARK: - Model

/// A file attached to an ``Item`` or ``Memory``.
///
/// The attachment record is lightweight: it stores a path reference
/// and optional metadata. The actual file bytes live in the app's
/// container (or a future CloudKit asset). The owning record is
/// responsible for cleaning up the file when the attachment is deleted.
@available(iOS 26, *)
@Model
public final class Attachment: @unchecked Sendable {

    // MARK: Identity

    /// Stable, globally unique identifier.
    @Attribute(.unique) public var id: UUID

    // MARK: File Reference

    /// File kind.
    public var kind: AttachmentKind

    /// Relative path inside the app's container, or a CloudKit asset record name.
    ///
    /// Resolve against `FileManager.default.urls(for: .documentDirectory, …)`
    /// for local files.
    public var path: String

    /// Optional path to a pre-generated thumbnail (for `photo` kind).
    public var thumbnailPath: String?

    /// Optional user-supplied caption or alt-text.
    public var caption: String?

    // MARK: Relationships

    /// The item this attachment belongs to.
    public var item: Item?

    // MARK: Timestamps

    /// When this attachment record was created.
    public var createdAt: Date

    // MARK: Initialiser

    public init(
        id: UUID = UUID(),
        kind: AttachmentKind,
        path: String,
        thumbnailPath: String? = nil,
        caption: String? = nil,
        createdAt: Date = Date()
    ) {
        self.id = id
        self.kind = kind
        self.path = path
        self.thumbnailPath = thumbnailPath
        self.caption = caption
        self.item = nil
        self.createdAt = createdAt
    }
}

// MARK: - Encodable (Data Sovereignty export — Promise lint #2)

@available(iOS 26, *)
extension Attachment: Encodable {
    enum CodingKeys: String, CodingKey {
        case id, kind, path, thumbnailPath, caption, createdAt
    }

    public func encode(to encoder: any Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(kind, forKey: .kind)
        try container.encode(path, forKey: .path)
        try container.encodeIfPresent(thumbnailPath, forKey: .thumbnailPath)
        try container.encodeIfPresent(caption, forKey: .caption)
        try container.encode(createdAt, forKey: .createdAt)
    }
}
