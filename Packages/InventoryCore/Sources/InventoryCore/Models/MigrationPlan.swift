// MigrationPlan.swift — InventoryCore
// Still Hours v0.1 MVP — PRD §7 Data Model
// LINT-IGNORE: Privacy — no external URL

import SwiftData

/// The SwiftData schema migration plan for Still Hours.
///
/// v0.1 baseline: a single schema version, no migration stages.
/// Add future stages here when introducing ``SchemaV2`` (Manifestation,
/// Loan, Contact, Place, Share — PRD v0.5 entities).
///
/// Usage:
/// ```swift
/// let container = try ModelContainer(
///     for: Schema(versionedSchema: SchemaV1.self),
///     migrationPlan: StillHoursMigrationPlan.self,
///     configurations: ModelConfiguration()
/// )
/// ```
@available(iOS 26, *)
public enum StillHoursMigrationPlan: SchemaMigrationPlan {

    /// All schema versions in chronological order.
    public static var schemas: [any VersionedSchema.Type] {
        [SchemaV1.self]
    }

    /// Migration stages between consecutive schema versions.
    ///
    /// Empty in v0.1 — no prior schema to migrate from.
    public static var stages: [MigrationStage] {
        []
    }
}
