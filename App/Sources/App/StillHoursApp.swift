// StillHoursApp.swift — App
// Copyright 2026 sunghun.ahn — Still Hours
// Round 7: Replaced placeholder RootView with ContentView
// Created: 2026-05-21

import SwiftUI
import SwiftData
import InventoryCore

@main
struct StillHoursApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(
            for: [
                Item.self,
                Memory.self,
                InventoryCore.Collection.self,
                InventoryCore.Attachment.self,
            ]
        )
    }
}
