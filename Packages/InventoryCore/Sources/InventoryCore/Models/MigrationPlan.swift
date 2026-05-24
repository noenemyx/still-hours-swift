// MigrationPlan.swift — InventoryCore
// Still Hours — Own Your Curation
// LINT-IGNORE: Privacy — no external URL

import SwiftData

/// The SwiftData schema migration plan for Still Hours.
///
/// v0.1 baseline: SchemaV1 — four foundational entities.
/// Build #9b: SchemaV2 — adds `externalID`, `source`, `publisher` to `Item`
/// for reliable cross-source deduplication. Lightweight migration (additive
/// optional fields only — no data transformation needed).
///
/// Usage:
/// ```swift
/// let container = try ModelContainer(
///     for: SchemaV2.schema,
///     migrationPlan: StillHoursMigrationPlan.self,
///     configurations: ModelConfiguration()
/// )
/// ```
@available(iOS 26, macOS 26, *)
public enum StillHoursMigrationPlan: SchemaMigrationPlan {

    /// All schema versions in chronological order.
    public static var schemas: [any VersionedSchema.Type] {
        [SchemaV1.self, SchemaV2.self]
    }

    /// Migration stages between consecutive schema versions.
    ///
    /// v1 → v2: lightweight — only optional fields added to `Item`.
    public static var stages: [MigrationStage] {
        [
            MigrationStage.lightweight(
                fromVersion: SchemaV1.self,
                toVersion: SchemaV2.self
            )
        ]
    }
}
