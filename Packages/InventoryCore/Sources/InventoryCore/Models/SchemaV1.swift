// SchemaV1.swift — InventoryCore
// Still Hours v0.1 MVP — PRD §7 Data Model
// LINT-IGNORE: Privacy — no external URL

import SwiftData

/// The initial persisted schema for Still Hours (version 1.0.0).
///
/// Contains the four foundational entities shipped in v0.1:
/// ``Item``, ``Memory``, ``Collection``, and ``Attachment``.
///
/// Future schema versions (Manifestation, Loan, Contact, Place, Share —
/// PRD v0.5) will be defined as `SchemaV2`, `SchemaV3`, etc. and wired
/// into ``StillHoursMigrationPlan``.
@available(iOS 26, macOS 26, *)
public enum SchemaV1: VersionedSchema {

    /// Schema version 1.0.0 — Still Hours v0.1 baseline.
    public static var versionIdentifier: Schema.Version {
        Schema.Version(1, 0, 0)
    }

    /// All persistent model types registered in this schema version.
    public static var models: [any PersistentModel.Type] {
        [
            Item.self,
            Memory.self,
            Collection.self,
            Attachment.self,
        ]
    }

    /// Convenience: a `Schema` instance pre-populated with `models` and
    /// stamped with `versionIdentifier`. Used by ``ModelContainer``
    /// construction and by test fixtures so each call site doesn't have to
    /// rebuild the schema literal.
    public static var schema: Schema {
        Schema(models, version: versionIdentifier)
    }
}
