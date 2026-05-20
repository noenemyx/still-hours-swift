// MediumBadgeView.swift — App/Views/Library
// Copyright 2026 sunghun.ahn — Still Hours
// Sprint 1.5 — LibraryListView + ItemDetailView + MemoryTimelineView
// Created: 2026-05-21
//
// Pill-shaped badge for a Medium value.
// Design.md §5.4 MediumBadge spec. ComponentTokens.MediumBadge.

import SwiftUI
import InventoryCore

// MARK: - MediumBadgeView

/// Pill-shaped label showing a medium's icon and localized name.
///
/// Design.md §5.4. ComponentTokens.MediumBadge.
@MainActor
struct MediumBadgeView: View {

    // MARK: Input

    let medium: Medium

    // MARK: Body

    var body: some View {
        HStack(spacing: ComponentTokens.MediumBadge.iconLabelGap) {
            Image(systemName: iconName)
                .font(.system(size: 12))
                .foregroundStyle(Color.shAccent)
                .accessibilityHidden(true)

            Text(medium.localizedLabel)
                .font(.subheadline)
                .fontWeight(.medium)
                .foregroundStyle(Color.shTextPrimary)
        }
        .padding(.vertical, ComponentTokens.MediumBadge.paddingVertical)
        .padding(.horizontal, ComponentTokens.MediumBadge.paddingHorizontal)
        .background(Color.shSurface)
        .clipShape(Capsule())
    }

    // MARK: Helpers

    private var iconName: String {
        switch medium {
        case .book:   return SemanticTokens.mediumIcon.book
        case .music:  return SemanticTokens.mediumIcon.music
        case .movie:  return SemanticTokens.mediumIcon.movie
        case .object: return SemanticTokens.mediumIcon.object
        }
    }
}

// MARK: - Medium+LocalizedLabel

extension Medium {
    /// Locale-aware label using the existing Localizable.xcstrings medium.* keys.
    var localizedLabel: String {
        switch self {
        case .book:   return String(localized: "medium.book",   defaultValue: "Book")
        case .music:  return String(localized: "medium.music",  defaultValue: "Music")
        case .movie:  return String(localized: "medium.movie",  defaultValue: "Movie")
        case .object: return String(localized: "medium.object", defaultValue: "Object")
        }
    }
}
