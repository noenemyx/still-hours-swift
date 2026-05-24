// LibraryListView.swift — App/Views/Library
// Copyright 2026 sunghun.ahn — Still Hours
// Sprint 1.5 — LibraryListView + ItemDetailView + MemoryTimelineView
// Build #9c: Removed isCapturing binding + "+" toolbar button.
//   Empty state now shows soft "직접 기록하기 →" hint only.
//   Curation entry lives on Tab 1 (큐레이션 / SearchFirstView).
// Created: 2026-05-21
//
// Root library list grouped by Medium. Embedded in a NavigationStack by parent.
// Localisation keys: library.empty, library.empty.cta, library.search,
//   library.sort.recent, library.sort.oldest, library.sort.title.

import SwiftUI
import SwiftData
import UIKit
import InventoryCore

// MARK: - Sort Order

enum LibrarySortOrder: CaseIterable, Identifiable {
    case recent, oldest, title

    var id: Self { self }

    var label: String {
        switch self {
        case .recent: return String(localized: "library.sort.recent", defaultValue: "Recent first")
        case .oldest: return String(localized: "library.sort.oldest", defaultValue: "Oldest first")
        case .title:  return String(localized: "library.sort.title",  defaultValue: "Title")
        }
    }
}

// MARK: - LibraryListView

/// Root library list view.
///
/// Groups all Items by Medium in a scrollable LazyVGrid (2-col iPhone,
/// 3-col iPad). Provides search and sort. Curation entry lives on the
/// dedicated 큐레이션 tab (SearchFirstView).
@MainActor
struct LibraryListView: View {

    // MARK: SwiftData

    @Query(sort: \Item.createdAt, order: .reverse) private var items: [Item]

    // MARK: State

    @State private var searchQuery: String = ""
    @State private var sortOrder: LibrarySortOrder = .recent
    @State private var showManualCapture = false

    // MARK: Adaptive grid

    @Environment(\.horizontalSizeClass) private var sizeClass

    private var columns: [GridItem] {
        let count = sizeClass == .regular ? 3 : 2
        return Array(repeating: GridItem(.flexible(), spacing: FoundationTokens.Space.sm), count: count)
    }

    // MARK: Filtered + sorted items

    private var displayItems: [Item] {
        let filtered: [Item]
        if searchQuery.isEmpty {
            filtered = items
        } else {
            let q = searchQuery.lowercased()
            filtered = items.filter {
                $0.title.lowercased().contains(q) ||
                ($0.creator?.lowercased().contains(q) == true)
            }
        }
        switch sortOrder {
        case .recent: return filtered.sorted { $0.createdAt > $1.createdAt }
        case .oldest: return filtered.sorted { $0.createdAt < $1.createdAt }
        case .title:  return filtered.sorted { $0.title.localizedCaseInsensitiveCompare($1.title) == .orderedAscending }
        }
    }

    // MARK: Body

    var body: some View {
        Group {
            if items.isEmpty {
                emptyState
            } else {
                libraryGrid
            }
        }
        .navigationTitle(String(localized: "nav.collection", defaultValue: "내 컬렉션"))
        .navigationBarTitleDisplayMode(.large)
        .searchable(
            text: $searchQuery,
            prompt: String(localized: "library.search", defaultValue: "Search library")
        )
        .toolbar {
            ToolbarItem(placement: .secondaryAction) {
                sortMenu
            }
        }
        .sheet(isPresented: $showManualCapture) {
            ManualCaptureSheet()
        }
    }

    // MARK: Empty State

    private var emptyState: some View {
        VStack(spacing: FoundationTokens.Space.lg) {
            Spacer()
            Text(String(localized: "library.empty", defaultValue: "Your library is empty"))
                .font(.headline)
                .foregroundStyle(Color.shTextPrimary)
                .multilineTextAlignment(.center)

            Button {
                showManualCapture = true
            } label: {
                Text(String(localized: "library.empty.manual", defaultValue: "직접 기록하기 →"))
                    .font(.subheadline)
            }
            .buttonStyle(.plain)
            .foregroundStyle(.tint)
            Spacer()
        }
        .padding(.horizontal, FoundationTokens.Space.xl)
    }

    // MARK: Grid

    private var libraryGrid: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: FoundationTokens.Space.md) {
                ForEach(displayItems) { item in
                    NavigationLink(destination: ItemDetailView(item: item)) {
                        ItemCardView(item: item)
                    }
                    .buttonStyle(.plain)
                    .contextMenu {
                        if let image = CardRenderView.makeShareableImage(for: item) {
                            ShareLink(
                                item: Image(uiImage: image),
                                preview: SharePreview(
                                    item.title,
                                    image: Image(uiImage: image)
                                )
                            ) {
                                Label(
                                    String(localized: "curation.share.card",
                                           defaultValue: "카드로 공유"),
                                    systemImage: "square.and.arrow.up"
                                )
                            }
                        }
                    }
                }
            }
            .padding(.horizontal, FoundationTokens.Space.md)
            .padding(.top, FoundationTokens.Space.sm)
            .padding(.bottom, FoundationTokens.Space.xxl)
        }
        .scrollContentBackground(.hidden)
    }

    // MARK: Sort Menu

    private var sortMenu: some View {
        Menu {
            ForEach(LibrarySortOrder.allCases) { order in
                Button {
                    sortOrder = order
                } label: {
                    if sortOrder == order {
                        Label(order.label, systemImage: "checkmark")
                    } else {
                        Text(order.label)
                    }
                }
            }
        } label: {
            Image(systemName: "arrow.up.arrow.down")
        }
    }
}

// MARK: - ManualCaptureSheet (local)

@MainActor
private struct ManualCaptureSheet: View {
    @Environment(\.modelContext) private var modelContext

    var body: some View {
        CaptureSheet(library: LibraryService(context: modelContext))
    }
}
