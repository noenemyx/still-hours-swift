// ItemCardView.swift — App/Views/Library
// Copyright 2026 sunghun.ahn — Still Hours
// Sprint 1.5 — LibraryListView + ItemDetailView + MemoryTimelineView
// Created: 2026-05-21
// R11.4: Liquid Glass uniformly tinted via .shGlass() — Design-R11 §8.
//
// Reusable 3:4 portrait card for a single Item.
// Design.md §5.1 ItemCard spec.

import SwiftUI
import InventoryCore

// MARK: - ItemCardView

/// 3:4 portrait card displaying a single ``Item``'s cover, title, creator,
/// medium badge, and memory-count badge.
///
/// Design.md §5.1. ComponentTokens.ItemCard.
@MainActor
struct ItemCardView: View {

    // MARK: Input

    let item: Item

    // MARK: Body

    var body: some View {
        GeometryReader { geo in
            ZStack(alignment: .topTrailing) {
                VStack(spacing: 0) {
                    coverArea(width: geo.size.width)
                    infoArea
                }
                .background(Color.shSurface)
                .clipShape(RoundedRectangle(cornerRadius: ComponentTokens.ItemCard.radius))
                .shElevatedShadow()

                if item.memories.count > 0 {
                    memoryCountBadge
                        .padding(FoundationTokens.Space.xs)
                }
            }
        }
        .aspectRatio(ComponentTokens.ItemCard.aspectRatio, contentMode: .fit)
        .accessibilityElement(children: .ignore)
        .accessibilityLabel(cardAccessibilityLabel)
        .accessibilityAddTraits(.isButton)
    }

    // MARK: Subviews

    @ViewBuilder
    private func coverArea(width: CGFloat) -> some View {
        let coverHeight = width / ComponentTokens.ItemCard.aspectRatio * 0.8
        Group {
            if let data = item.coverImageData,
               let uiImage = UIImage(data: data) {
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFill()
                    .frame(width: width, height: coverHeight)
                    .clipped()
            } else {
                ZStack {
                    Color.shAccentMuted
                    Image(systemName: mediumIconName)
                        .font(.system(size: 40))
                        .foregroundStyle(Color.shAccent)
                        .accessibilityHidden(true)
                }
                .frame(width: width, height: coverHeight)
            }
        }
    }

    private var infoArea: some View {
        VStack(alignment: .leading, spacing: FoundationTokens.Space.xs) {
            Text(item.title)
                .font(.headline)
                .foregroundStyle(Color.shTextPrimary)
                .lineLimit(1)
                .minimumScaleFactor(0.8)

            if let creator = item.creator {
                Text(creator)
                    .font(.caption)
                    .foregroundStyle(Color.shTextSecondary)
                    .lineLimit(1)
            }

            MediumBadgeView(medium: item.medium)
        }
        .padding(FoundationTokens.Space.sm)
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    private var memoryCountBadge: some View {
        Text("\(item.memories.count)")
            .font(.caption2)
            .fontWeight(.semibold)
            .foregroundStyle(Color.shTextPrimary)
            .padding(.horizontal, FoundationTokens.Space.sm)
            .padding(.vertical, FoundationTokens.Space.xs)
            .background {
                Capsule()
                    .shGlass(in: Capsule())
            }
    }

    // MARK: Helpers

    private var mediumIconName: String {
        switch item.medium {
        case .book:   return SemanticTokens.mediumIcon.book
        case .music:  return SemanticTokens.mediumIcon.music
        case .movie:  return SemanticTokens.mediumIcon.movie
        case .object: return SemanticTokens.mediumIcon.object
        case .place:  return SemanticTokens.mediumIcon.place
        }
    }

    private var cardAccessibilityLabel: String {
        let mediumLabel = item.medium.localizedLabel
        let memCount = item.memories.count
        let countPart = memCount == 0
            ? ""
            : ", \(memCount) \(memCount == 1 ? "memory" : "memories")"
        return "\(item.title), \(mediumLabel)\(countPart)"
    }
}
