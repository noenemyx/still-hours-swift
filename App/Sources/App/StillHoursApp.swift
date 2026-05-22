// StillHoursApp.swift — App
// Copyright 2026 sunghun.ahn — Still Hours
// Round 7: Replaced placeholder RootView with ContentView
// R10.2: in-memory ModelContainer for DEBUG, cloudKitDatabase=.none for Release
//         until iCloud opt-in lands.
// Created: 2026-05-21

import SwiftUI
import SwiftData
import InventoryCore

@main
struct StillHoursApp: App {

    init() {
        #if DEBUG
        if CommandLine.arguments.contains("--reset-onboarding") {
            UserDefaults.standard.removeObject(forKey: "hasCompletedOnboarding")
        }
        if CommandLine.arguments.contains("--seed-stress-50") {
            UserDefaults.standard.set(true, forKey: "seedStressDataset")
        }
        #endif
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(Self.makeContainer())
    }

    /// Builds a `ModelContainer` with isolation appropriate for the build
    /// configuration.
    ///
    /// - **DEBUG**: in-memory store only — no disk write, no CloudKit auth
    ///   prompt. `DemoSeeder` operates entirely in RAM; data vanishes on
    ///   launch. Eliminates the "Apple 계정 확인" alert that blocks first
    ///   paint when iCloud isn't signed in on a simulator (Axis M).
    ///
    /// - **Release**: local SQLite on-device only (`cloudKitDatabase: .none`).
    ///   No CloudKit sync is attempted at launch, so no account auth prompt
    ///   fires for new users. iCloud opt-in is deferred to v1.1 via a
    ///   Settings → "Sync via iCloud" toggle.
    ///   TODO (v1.1): replace `.none` with `.private("iCloud.com.ownlifelab.stillhours")`
    ///   when the user explicitly enables iCloud sync in Settings.
    ///
    /// `try!` is intentional: a `ModelContainer` that can't initialise is an
    /// unrecoverable programmer error (bad schema, disk full at first install).
    /// Crashing immediately surfaces the root cause; a `try?` or `fatalError`
    /// would hide the error message.
    @MainActor
    private static func makeContainer() -> ModelContainer {
        #if DEBUG
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        #else
        let config = ModelConfiguration(cloudKitDatabase: .none)
        #endif
        // swiftlint:disable:next force_try
        return try! ModelContainer(
            for: Item.self,
                 Memory.self,
                 InventoryCore.Collection.self,
                 InventoryCore.Attachment.self,
            configurations: config
        )
    }
}
