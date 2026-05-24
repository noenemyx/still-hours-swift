// ContentView.swift — App/Views/Root
// Copyright 2026 sunghun.ahn — Still Hours
// Round 7: Root NavigationStack + Tab shell
// Updated: 2026-05-21 — Sprint 1.5 wires real LibraryListView
// R9.2: DemoSeeder wired via .task on root TabView (#if DEBUG)
// Build #9c: Onboarding removed. TabView Option X:
//   Tab 1 = 큐레이션 (SearchFirstView) — search is root entry
//   Tab 2 = 내 컬렉션 (LibraryListView) — browse collection
// Created: 2026-05-21

import SwiftUI
import SwiftData
import InventoryCore

// MARK: - ContentView

/// Root content view embedded in the WindowGroup.
///
/// Two-tab shell: 큐레이션 (search-first entry) + 내 컬렉션 (library browse).
/// iOS 26 applies Liquid Glass to the tab bar automatically.
@MainActor
struct ContentView: View {

    // MARK: Environment

    @Environment(\.modelContext) private var modelContext

    // MARK: Body

    var body: some View {
        mainTabView
    }

    // MARK: - Main Tab View

    @ViewBuilder
    private var mainTabView: some View {
        TabView {
            Tab(
                String(localized: "nav.curation", defaultValue: "큐레이션"),
                systemImage: "sparkle.magnifyingglass"
            ) {
                NavigationStack {
                    CurationRootView()
                }
            }
            .accessibilityLabel(
                String(localized: "nav.curation", defaultValue: "큐레이션")
            )

            Tab(
                String(localized: "nav.collection", defaultValue: "내 컬렉션"),
                systemImage: "books.vertical"
            ) {
                NavigationStack {
                    LibraryListView()
                }
            }
            .accessibilityLabel(
                String(localized: "nav.collection", defaultValue: "내 컬렉션")
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

// MARK: - CurationRootView

/// Tab 1 root: wraps ``SearchFirstView`` with adopt → AddMemoryView push flow.
@MainActor
private struct CurationRootView: View {
    @Environment(\.modelContext) private var modelContext
    @State private var adoptedItem: Item?
    @State private var showAddMemory = false
    @State private var adoptError: Error?
    @State private var showAdoptErrorAlert = false
    @State private var showManualCapture = false
    // H1: Lifted to parent so UnifiedSearchService (an actor) is not recreated on each view rebuild.
    @State private var searchService = UnifiedSearchService()

    var body: some View {
        SearchFirstView(
            service: searchService,
            onAdopt: { result in
                Task { await adopt(result) }
            },
            onManualFallback: {
                showManualCapture = true
            }
        )
        .navigationTitle(
            String(localized: "nav.curation", defaultValue: "큐레이션")
        )
        .navigationBarTitleDisplayMode(.inline)
        .navigationDestination(isPresented: $showAddMemory) {
            if let item = adoptedItem {
                AddMemoryView(
                    item: item,
                    library: LibraryService(context: modelContext),
                    onSaved: { showAddMemory = false },
                    onCancel: { showAddMemory = false }
                )
            }
        }
        .sheet(isPresented: $showManualCapture) {
            ManualCaptureSheetWrapper()
        }
        .alert(
            String(localized: "curation.adopt.error.title", defaultValue: "저장 실패"),
            isPresented: $showAdoptErrorAlert,
            presenting: adoptError
        ) { _ in
            Button(String(localized: "curation.adopt.error.dismiss", defaultValue: "확인")) {}
        } message: { error in
            Text(error.localizedDescription)
        }
    }

    private func adopt(_ result: SearchResult) async {
        let service = CurationAdoptionService()
        do {
            let item = try await service.adopt(result, into: modelContext)
            adoptedItem = item
            showAddMemory = true
        } catch {
            adoptError = error
            showAdoptErrorAlert = true
        }
    }
}

// MARK: - ManualCaptureSheetWrapper

/// Fallback: presents the legacy ``CaptureSheet`` (manual entry + barcode + voice)
/// when the user taps "직접 기록하기" inside ``SearchFirstView``.
@MainActor
private struct ManualCaptureSheetWrapper: View {
    @Environment(\.modelContext) private var modelContext

    var body: some View {
        CaptureSheet(library: LibraryService(context: modelContext))
    }
}
