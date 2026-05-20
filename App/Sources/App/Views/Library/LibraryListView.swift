// LibraryListView.swift — App/Views/Library
// Copyright 2026 sunghun.ahn — Still Hours
// Sprint 1.5 — LibraryListView + ItemDetailView + MemoryTimelineView
// Created: 2026-05-21
//
// Root library list grouped by Medium. Embedded in a NavigationStack by parent.
// Localisation keys: library.empty, library.empty.cta, library.search,
//   library.sort.recent, library.sort.oldest, library.sort.title.

import SwiftUI
import SwiftData
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
/// 3-col iPad). Provides search, sort, and a toolbar "+" button that
/// sets `isCapturing` on the parent.
@MainActor
struct LibraryListView: View {

    // MARK: Input

    @Binding var isCapturing: Bool

    // MARK: SwiftData

    @Query(sort: \Item.createdAt, order: .reverse) private var items: [Item]

    // MARK: State

    @State private var searchQuery: String = ""
    @State private var sortOrder: LibrarySortOrder = .recent

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
        .navigationTitle(String(localized: "nav.library", defaultValue: "Library"))
        .navigationBarTitleDisplayMode(.large)
        .searchable(
            text: $searchQuery,
            prompt: String(localized: "library.search", defaultValue: "Search library")
        )
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Button {
                    isCapturing = true
                } label: {
                    Image(systemName: "plus")
                }
                .accessibilityLabel(
                    String(localized: "library.empty.cta", defaultValue: "Capture your first item")
                )
            }

            ToolbarItem(placement: .secondaryAction) {
                sortMenu
            }
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
                isCapturing = true
            } label: {
                Text(String(localized: "library.empty.cta", defaultValue: "Capture your first item"))
                    .fontWeight(.semibold)
            }
            .buttonStyle(.glassProminent)
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
