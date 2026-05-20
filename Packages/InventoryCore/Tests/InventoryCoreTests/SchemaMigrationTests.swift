// SchemaMigrationTests.swift — InventoryCoreTests
// Still Hours v0.1 MVP — Pre-flight Round 4 unit tests
// Date: 2026-05-20

import Testing
import SwiftData
import Foundation
@testable import InventoryCore

struct SchemaMigrationTests {

    // MARK: - SchemaV1 Sanity

    @Test func schemaV1_versionIs_1_0_0() {
        let v = SchemaV1.versionIdentifier
        #expect(v == Schema.Version(1, 0, 0))
    }

    @Test func schemaV1_registersExactlyFourModels() {
        #expect(SchemaV1.models.count == 4)
    }

    @Test func schemaV1_registersItemModel() {
        let hasItem = SchemaV1.models.contains { $0 == Item.self }
        #expect(hasItem)
    }

    @Test func schemaV1_registersMemoryModel() {
        let hasMemory = SchemaV1.models.contains { $0 == Memory.self }
        #expect(hasMemory)
    }

    @Test func schemaV1_registersCollectionModel() {
        let hasCollection = SchemaV1.models.contains { $0 == Collection.self }
        #expect(hasCollection)
    }

    @Test func schemaV1_registersAttachmentModel() {
        let hasAttachment = SchemaV1.models.contains { $0 == Attachment.self }
        #expect(hasAttachment)
    }

    // MARK: - StillHoursMigrationPlan Sanity

    @Test func migrationPlan_schemasContainsSchemaV1AsFirst() throws {
        let schemas = StillHoursMigrationPlan.schemas
        #expect(!schemas.isEmpty)
        // The first (and currently only) schema must be SchemaV1.
        // Use ObjectIdentifier for metatype comparison across protocol erasure.
        let firstSchema = try #require(schemas.first)
        #expect(ObjectIdentifier(firstSchema) == ObjectIdentifier(SchemaV1.self))
    }

    @Test func migrationPlan_currentRevisionIsSchemaV1() throws {
        // Verify that the plan's leading schema matches SchemaV1 version.
        let firstSchema = try #require(StillHoursMigrationPlan.schemas.first)
        #expect(ObjectIdentifier(firstSchema) == ObjectIdentifier(SchemaV1.self))
    }

    @Test func migrationPlan_stagesAreEmptyAtV1Baseline() {
        // v0.1 baseline: no prior schema to migrate from.
        #expect(StillHoursMigrationPlan.stages.isEmpty)
    }

    // MARK: - V1 → V2 Placeholder (structural guard for future migration)
    //
    // There is no SchemaV2 yet. This test documents the contract that
    // when v2 ships:
    //   1. StillHoursMigrationPlan.schemas must contain SchemaV1.self at index 0
    //   2. StillHoursMigrationPlan.stages must contain exactly 1 MigrationStage
    //
    // Today the assertions verify v1 baseline remains stable.
    // When SchemaV2 is introduced, extend this test to cover the new stage.

    @Test func migrationPlanV1ToV2_placeholder_schemasCountIsOne() {
        // Currently 1 schema. Increment to 2 when SchemaV2 is introduced.
        #expect(StillHoursMigrationPlan.schemas.count == 1)
    }

    @Test func migrationPlanV1ToV2_placeholder_stagesCountIsZero() {
        // Currently 0 stages. Increment to 1 when v1→v2 stage is added.
        #expect(StillHoursMigrationPlan.stages.count == 0)
    }

    // MARK: - In-Memory Container Bootstraps with V1 Schema

    @MainActor
    @Test func schemaV1_inMemoryContainerBootstraps() throws {
        let container = try ModelContainer(
            for: SchemaV1.schema,
            configurations: ModelConfiguration(isStoredInMemoryOnly: true)
        )
        // If we reach here, the schema is valid and the container launched.
        let context = container.mainContext
        let descriptor = FetchDescriptor<Item>()
        let items = try context.fetch(descriptor)
        #expect(items.isEmpty) // fresh store
    }

    @MainActor
    @Test func schemaV1_containerWithMigrationPlanBootstraps() throws {
        // Verify that wiring the migration plan into ModelContainer works.
        let container = try ModelContainer(
            for: SchemaV1.schema,
            migrationPlan: StillHoursMigrationPlan.self,
            configurations: ModelConfiguration(isStoredInMemoryOnly: true)
        )
        let context = container.mainContext
        let descriptor = FetchDescriptor<Memory>()
        let memories = try context.fetch(descriptor)
        #expect(memories.isEmpty)
    }
}
