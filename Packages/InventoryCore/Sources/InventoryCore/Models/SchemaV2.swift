// SchemaV2.swift — InventoryCore
// Own Your Curation — Build #9b
// Adds externalID, source, publisher to Item for stable dedup.

import SwiftData

/// Schema version 2.0.0 — adds ``Item/externalID``, ``Item/source``,
/// and ``Item/publisher`` fields for reliable cross-source deduplication.
///
/// Lightweight migration from ``SchemaV1`` — only optional fields added,
/// no data transformation required.
@available(iOS 26, macOS 26, *)
public enum SchemaV2: VersionedSchema {

    public static var versionIdentifier: Schema.Version {
        Schema.Version(2, 0, 0)
    }

    public static var models: [any PersistentModel.Type] {
        [
            Item.self,
            Memory.self,
            Collection.self,
            Attachment.self,
        ]
    }

    // VERIFIED: Schema(models, version:) compiles + correctly tags version
    public static var schema: Schema {
        Schema(models, version: versionIdentifier)
    }
}
