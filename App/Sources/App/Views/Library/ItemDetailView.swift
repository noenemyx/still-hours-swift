// ItemDetailView.swift — App/Views/Library
// Copyright 2026 sunghun.ahn — Still Hours
// Sprint 1.5 — LibraryListView + ItemDetailView + MemoryTimelineView
// Created: 2026-05-21
//
// NavigationLink destination. Shows item hero + MemoryTimelineView.
// Localisation keys: item.detail.metadata, item.detail.year, item.detail.publisher,
//   item.detail.pages, item.detail.addMemory, item.detail.edit, item.detail.delete.

import SwiftUI
import SwiftData
import InventoryCore

// MARK: - ItemDetailView

/// Detail view for a single ``Item``.
///
/// Top: full-width cover hero (16:9) with glass overlay for title/creator/badge.
/// Below: scrollable content — metadata section, MemoryTimelineView, action buttons.
@MainActor
struct ItemDetailView: View {

    // MARK: Input

    let item: Item

    // MARK: Environment

    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    // MARK: State

    @State private var showAddMemory: Bool = false
    @State private var showDeleteConfirmation: Bool = false

    // MARK: Computed

    /// LibraryService backed by the view's SwiftData ModelContext.
    ///
    /// Constructed lazily per-body pass — fine because `@MainActor final class`
    /// is cheap to create (just stores the context reference).
    private var library: LibraryService {
        LibraryService(context: modelContext)
    }

    // MARK: Body

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 0) {
                heroSection
                contentSection
            }
        }
        .scrollContentBackground(.hidden)
        .background(Color.shBackground)
        .navigationTitle(item.title)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                Button(String(localized: "item.detail.edit", defaultValue: "Edit")) {}
                    .foregroundStyle(Color.shAccent)
            }
        }
        .onAppear {
            AccessibilityNotification.Announcement(item.title).post()
        }
        .sheet(isPresented: $showAddMemory) {
            AddMemoryView(
                item: item,
                library: library,
                onSaved: { showAddMemory = false },
                onCancel: { showAddMemory = false }
            )
        }
        .confirmationDialog(
            String(localized: "item.detail.delete", defaultValue: "Delete"),
            isPresented: $showDeleteConfirmation,
            titleVisibility: .visible
        ) {
            Button(
                String(localized: "item.detail.delete", defaultValue: "Delete"),
                role: .destructive
            ) {
                modelContext.delete(item)
                dismiss()
            }
            Button(String(localized: "nav.cancel", defaultValue: "Cancel"), role: .cancel) {}
        }
    }

    // MARK: Hero Section

    private var heroSection: some View {
        ZStack(alignment: .bottomLeading) {
            coverHeroImage
            heroOverlay
        }
        .aspectRatio(16.0 / 9.0, contentMode: .fill)
        .clipped()
    }

    @ViewBuilder
    private var coverHeroImage: some View {
        if let data = item.coverImageData, let uiImage = UIImage(data: data) {
            Image(uiImage: uiImage)
                .resizable()
                .scaledToFill()
        } else {
            ZStack {
                Color.shAccentMuted
                Image(systemName: mediumIconName)
                    .font(.system(size: 56))
                    .foregroundStyle(Color.shAccent)
                    .accessibilityHidden(true)
            }
        }
    }

    private var heroOverlay: some View {
        VStack(alignment: .leading, spacing: FoundationTokens.Space.xs) {
            Text(item.title)
                .font(.title2)
                .fontWeight(.semibold)
                .foregroundStyle(Color.shTextPrimary)
                .lineLimit(2)

            if let creator = item.creator {
                Text(creator)
                    .font(.callout)
                    .foregroundStyle(Color.shTextSecondary)
                    .lineLimit(1)
            }

            MediumBadgeView(medium: item.medium)
        }
        .padding(FoundationTokens.Space.md)
        .frame(maxWidth: .infinity, alignment: .leading)
        .glassEffect(.regular, in: RoundedRectangle(cornerRadius: 0))
    }

    // MARK: Content Section

    private var contentSection: some View {
        VStack(alignment: .leading, spacing: FoundationTokens.Space.lg) {
            if item.medium == .book {
                metadataSection
            }

            timelineSection

            actionSection
        }
        .padding(.horizontal, FoundationTokens.Space.md)
        .padding(.top, FoundationTokens.Space.lg)
        .padding(.bottom, FoundationTokens.Space.xxl)
    }

    // MARK: Metadata Section (book only)

    private var metadataSection: some View {
        VStack(alignment: .leading, spacing: FoundationTokens.Space.sm) {
            Text(String(localized: "item.detail.metadata", defaultValue: "Details"))
                .font(.subheadline)
                .fontWeight(.semibold)
                .foregroundStyle(Color.shTextSecondary)

            if let year = item.year {
                metadataRow(
                    label: String(localized: "item.detail.year", defaultValue: "Year"),
                    value: "\(year)"
                )
            }
        }
        .padding(FoundationTokens.Space.md)
        .background(Color.shSurface)
        .clipShape(RoundedRectangle(cornerRadius: FoundationTokens.Radius.md))
        .shElevatedShadow()
    }

    private func metadataRow(label: String, value: String) -> some View {
        HStack {
            Text(label)
                .font(.callout)
                .foregroundStyle(Color.shTextSecondary)
            Spacer()
            Text(value)
                .font(.callout)
                .foregroundStyle(Color.shTextPrimary)
        }
    }

    // MARK: Timeline Section

    private var timelineSection: some View {
        MemoryTimelineView(item: item, onAddMemory: { showAddMemory = true })
    }

    // MARK: Action Section

    private var actionSection: some View {
        VStack(spacing: FoundationTokens.Space.sm) {
            Button {
                showAddMemory = true
            } label: {
                Label(
                    String(localized: "item.detail.addMemory", defaultValue: "Add Memory"),
                    systemImage: "plus"
                )
                .frame(maxWidth: .infinity)
            }
            .buttonStyle(.glassProminent)
            .accessibilityLabel(
                String(localized: "item.detail.addMemory", defaultValue: "Add Memory")
            )

            Button(role: .destructive) {
                showDeleteConfirmation = true
            } label: {
                Text(String(localized: "item.detail.delete", defaultValue: "Delete"))
                    .frame(maxWidth: .infinity)
            }
            .foregroundStyle(Color.shTextSecondary)
            .font(.callout)
        }
    }

    // MARK: Helpers

    private var mediumIconName: String {
        switch item.medium {
        case .book:   return SemanticTokens.mediumIcon.book
        case .music:  return SemanticTokens.mediumIcon.music
        case .movie:  return SemanticTokens.mediumIcon.movie
        case .object: return SemanticTokens.mediumIcon.object
        }
    }
}
