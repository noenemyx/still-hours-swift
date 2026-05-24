// CardRenderView.swift — App/Views/Sharing
// Copyright 2026 sunghun.ahn — Still Hours
// Build #9e: Share Card v1.0 — 3:4 image, native ShareLink.
// Pure presentation view — no state, no fetch, no logic.

import SwiftUI
import UIKit
import InventoryCore

// MARK: - CardRenderView

/// Renders a single ``Item`` as a 3:4 shareable card (300 × 400 pt base).
///
/// Layout (top → bottom):
/// 1. Cover image area (75% height) — uses `coverImageData` or SF Symbol placeholder
/// 2. Title (semibold body, lineLimit 2)
/// 3. Creator (secondary, lineLimit 1)
/// 4. Footer brand line (caption2, tertiary)
@MainActor
struct CardRenderView: View {

    let item: Item

    // Card base dimensions
    private let cardWidth: CGFloat  = 300
    private let cardHeight: CGFloat = 400
    private let coverFraction: CGFloat = 0.75

    var body: some View {
        VStack(spacing: 0) {
            coverArea
            infoArea
        }
        .frame(width: cardWidth, height: cardHeight)
        .background(Color.shBackground)
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }

    // MARK: Cover (75%)

    private var coverArea: some View {
        Group {
            if let data = item.coverImageData, let uiImage = UIImage(data: data) {
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFill()
            } else {
                ZStack {
                    Color.shAccentMuted
                    Image(systemName: mediumIconName)
                        .font(.system(size: 48))
                        .foregroundStyle(Color.shAccent)
                        .accessibilityHidden(true)
                }
            }
        }
        .frame(width: cardWidth, height: cardHeight * coverFraction)
        .clipped()
    }

    // MARK: Info (25%)

    private var infoArea: some View {
        VStack(alignment: .leading, spacing: 2) {
            Text(item.title)
                .font(.body)
                .fontWeight(.semibold)
                .foregroundStyle(Color.shTextPrimary)
                .lineLimit(2)
                .frame(maxWidth: .infinity, alignment: .leading)

            if let creator = item.creator {
                Text(creator)
                    .font(.subheadline)
                    .foregroundStyle(Color.shTextSecondary)
                    .lineLimit(1)
                    .frame(maxWidth: .infinity, alignment: .leading)
            }

            Spacer(minLength: 0)

            Text(String(localized: "curation.share.footer.brand",
                        defaultValue: "큐레이션 by Own Your Curation"))
                .font(.caption2)
                .foregroundStyle(Color.shTextTertiary)
                .lineLimit(1)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
        .padding(16)
        .frame(width: cardWidth, height: cardHeight * (1 - coverFraction))
        .background(Color.shBackground)
    }

    // MARK: Medium icon helper

    private var mediumIconName: String {
        switch item.medium {
        case .book:   return SemanticTokens.mediumIcon.book
        case .music:  return SemanticTokens.mediumIcon.music
        case .movie:  return SemanticTokens.mediumIcon.movie
        case .object: return SemanticTokens.mediumIcon.object
        case .place:  return SemanticTokens.mediumIcon.place
        }
    }
}

// MARK: - Share Image Factory

extension CardRenderView {

    /// Renders `CardRenderView` for `item` into a `UIImage` using `ImageRenderer`.
    ///
    /// - Parameters:
    ///   - item: The item to render.
    ///   - displayScale: Scale factor for retina output (default 3.0 for @3x).
    /// - Returns: A `UIImage`, or `nil` if rendering fails.
    @MainActor
    static func makeShareableImage(for item: Item, displayScale: CGFloat = 3.0) -> UIImage? {
        let renderer = ImageRenderer(content: CardRenderView(item: item))
        renderer.scale = displayScale
        return renderer.uiImage
    }
}
