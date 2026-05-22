// ContentView.swift — App/Views/Root
// Copyright 2026 sunghun.ahn — Still Hours
// Round 7: Root NavigationStack + Tab shell
// Updated: 2026-05-21 — Sprint 1.5 wires real LibraryListView
// R9.2: DemoSeeder wired via .task on root TabView (#if DEBUG)
// R10.3: Onboarding gate — shows OnboardingFlow on first launch
// Created: 2026-05-21

import SwiftUI
import SwiftData
import InventoryCore

// MARK: - ContentView

/// Root content view embedded in the WindowGroup.
///
/// Gates first-launch onboarding via `@AppStorage("hasCompletedOnboarding")`.
/// After onboarding completes, renders the two-tab `TabView` (Library + Settings).
/// iOS 26 applies Liquid Glass to the tab bar automatically.
@MainActor
struct ContentView: View {

    // MARK: Environment

    @Environment(\.modelContext) private var modelContext

    // MARK: AppStorage — onboarding gate

    @AppStorage("hasCompletedOnboarding") private var hasCompletedOnboarding = false

    // MARK: Local state

    @State private var isCapturing = false

    // MARK: Body

    var body: some View {
        if !hasCompletedOnboarding {
            OnboardingFlow(onComplete: { hasCompletedOnboarding = true })
        } else {
            mainTabView
        }
    }

    // MARK: - Main Tab View

    @ViewBuilder
    private var mainTabView: some View {
        TabView {
            Tab(
                String(localized: "nav.library", defaultValue: "Library"),
                systemImage: "books.vertical"
            ) {
                NavigationStack {
                    LibraryListView(isCapturing: $isCapturing)
                }
            }
            .accessibilityLabel(
                String(localized: "nav.library", defaultValue: "Library")
            )

            Tab(
                String(localized: "nav.settings", defaultValue: "Settings"),
                systemImage: "gearshape"
            ) {
                NavigationStack {
                    SettingsRootView()
                }
            }
            .accessibilityLabel(
                String(localized: "nav.settings", defaultValue: "Settings")
            )
        }
        .tint(Color.shAccent)
        .sheet(isPresented: $isCapturing) {
            CaptureSheetWrapper()
        }
        #if DEBUG
        .task {
            do {
                if UserDefaults.standard.bool(forKey: "seedStressDataset") {
                    try await DemoSeederStress(context: modelContext).seedStressDataset(count: 50)
                } else {
                    try await DemoSeeder(context: modelContext).seedIfEmpty()
                }
            } catch {
                // Silently ignore — seeders are developer conveniences, not critical paths.
                print("[DemoSeeder] seed failed: \(error)")
            }
        }
        #endif
    }
}

// MARK: - CaptureSheetWrapper

/// Wrapper that vends a `CaptureSheet` with a `LibraryService`.
///
/// LibraryService is now `@MainActor` (not `actor`) so `ModelContext`
/// flows in from the SwiftUI environment without crossing isolation —
/// no `sending` diagnostic. See lessons-learned for the rationale.
@MainActor
private struct CaptureSheetWrapper: View {
    @Environment(\.modelContext) private var modelContext

    var body: some View {
        CaptureSheet(library: LibraryService(context: modelContext))
    }
}
