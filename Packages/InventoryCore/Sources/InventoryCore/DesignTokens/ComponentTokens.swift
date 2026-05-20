// ComponentTokens.swift
// Still Hours — Design System Component Tokens
//
// R11 ComponentTokens routes color through semantic layer (post-Cool-Blue pivot).
// Component-scoped layout constants derived from Foundation tokens.
// Maps directly to Design.md §5 (Component Library).
//
// Color references in components use SemanticTokens (e.g. SemanticTokens.card.background)
// not raw FoundationTokens or hex values. Geometric / spacing values are unchanged from v1.0.
//
// Usage: reference via `ComponentTokens.ItemCard.aspectRatio` etc.
// Do **not** hard-code these values in view files.
//
// - Note: Design-R11-ColdBlue.md §3 + Design.md §5.1–§5.4.

import SwiftUI

// MARK: - ComponentTokens

/// Layout and appearance tokens for Still Hours UI components.
///
/// Each nested type corresponds to one component section in Design.md §5.
/// All raw numeric values are derived from ``FoundationTokens`` where possible;
/// component-specific values are documented with their Design.md reference.
///
/// - Important: Design.md §5 is the authoritative source.
///   Never duplicate these constants in feature code — always import and reference.
@available(iOS 17, macOS 14, *)
public enum ComponentTokens {

    // MARK: - ItemCard (Design.md §5.1)

    /// Tokens for the `ItemCard` component — portrait-oriented item cover card.
    ///
    /// Design.md §5.1.
    public enum ItemCard {

        /// Portrait aspect ratio — width:height = 3:4.
        ///
        /// Fixed ratio; do **not** stretch to fill available width.
        /// Use with `.aspectRatio(aspectRatio, contentMode: .fit)`.
        ///
        /// Design.md §5.1 `itemCard.aspectRatio`.
        public static let aspectRatio: CGFloat = 3.0 / 4.0

        /// Internal padding on all edges of the card content.
        ///
        /// = ``FoundationTokens/Space/md`` (16pt).
        ///
        /// Design.md §5.1 `itemCard.padding`.
        public static let padding: CGFloat = FoundationTokens.Space.md

        /// Corner radius of the card surface.
        ///
        /// = ``FoundationTokens/Radius/md`` (12pt).
        ///
        /// Design.md §5.1 `itemCard.radius`.
        public static let radius: CGFloat = FoundationTokens.Radius.md

        /// Shadow specification applied to the card.
        ///
        /// Uses ``FoundationTokens/Shadow/elevated``:
        /// `y: 2, blur: 8, opacity: 0.06`.
        ///
        /// Apply via ``View/shElevatedShadow()``.
        ///
        /// Design.md §5.1 `itemCard.shadow`.
        public enum shadow {
            public static let y:       CGFloat = FoundationTokens.Shadow.elevated.y
            public static let blur:    CGFloat = FoundationTokens.Shadow.elevated.blur
            public static let opacity: Double  = FoundationTokens.Shadow.elevated.opacity
            public static let color:   Color   = FoundationTokens.Shadow.elevated.color
        }

        /// When `true`, cover images are center-cropped to fill the card area.
        ///
        /// Use `.scaledToFill()` + `.clipped()` on `AsyncImage` or `Image`.
        ///
        /// Design.md §5.1 `itemCard.coverCenterCropEnabled`.
        public static let coverCenterCropEnabled: Bool = true
    }

    // MARK: - MemoryRow (Design.md §5.2)

    /// Tokens for the `MemoryRow` component — inline memory event row.
    ///
    /// Design.md §5.2.
    public enum MemoryRow {

        /// Vertical gap between consecutive memory rows.
        ///
        /// = ``FoundationTokens/Space/sm`` (8pt).
        ///
        /// Design.md §5.2 `memoryRow.verticalGap`.
        public static let verticalGap: CGFloat = FoundationTokens.Space.sm

        /// Stroke width of the left accent line indicator.
        ///
        /// 1pt — hairline rule; thicker lines feel too heavy against parchment.
        ///
        /// Design.md §5.2 `memoryRow.accentLineWidth`.
        public static let accentLineWidth: CGFloat = 1

        /// Horizontal leading indent of the accent line from the row edge.
        ///
        /// 16pt — aligns with the leading padding of `ItemCard`.
        ///
        /// Design.md §5.2 `memoryRow.accentLineIndent`.
        public static let accentLineIndent: CGFloat = 16

        /// Size (width = height) of the memory kind icon.
        ///
        /// 16pt — matches caption text cap-height at SF body.
        ///
        /// Design.md §5.2 `memoryRow.iconSize`.
        public static let iconSize: CGFloat = 16

        /// Horizontal gap between the kind icon and the label text.
        ///
        /// = ``FoundationTokens/Space/sm`` (8pt).
        ///
        /// Design.md §5.2 `memoryRow.iconTextGap`.
        public static let iconTextGap: CGFloat = FoundationTokens.Space.sm

        /// Square size of the photo thumbnail when a photo is attached.
        ///
        /// 96pt — large enough for visual anchoring; small enough to not dominate.
        ///
        /// Design.md §5.2 `memoryRow.photoThumbSize`.
        public static let photoThumbSize: CGFloat = 96

        /// Range of animated waveform bars for voice memo rows.
        ///
        /// 3–7 bars rendered dynamically to reflect voice amplitude.
        /// Minimum 3 ensures waveform is recognizable; maximum 7 avoids clutter.
        ///
        /// Design.md §5.2 `memoryRow.voiceWaveBars`.
        public static let voiceWaveBars: ClosedRange<Int> = 3...7
    }

    // MARK: - CollectionCover (Design.md §5.3)

    /// Tokens for the `CollectionCover` component — wide hero banner for a collection.
    ///
    /// Design.md §5.3.
    public enum CollectionCover {

        /// Landscape aspect ratio — width:height = 16:9.
        ///
        /// Standard cinematic widescreen. Use with `.aspectRatio(aspectRatio, contentMode: .fit)`.
        ///
        /// Design.md §5.3 `collectionCover.aspectRatio`.
        public static let aspectRatio: CGFloat = 16.0 / 9.0

        /// When `true`, a hero image must be supplied; blank fallback is not acceptable.
        ///
        /// Collections without a user-chosen image should display a generated
        /// gradient or color-field rather than an empty rectangle.
        ///
        /// Design.md §5.3 `collectionCover.heroImageRequired`.
        public static let heroImageRequired: Bool = true
    }

    // MARK: - MediumBadge (Design.md §5.4)

    /// Tokens for the `MediumBadge` component — pill-shaped medium label.
    ///
    /// Design.md §5.4.
    public enum MediumBadge {

        /// Badge shape is pill (fully rounded capsule).
        ///
        /// Implemented via `.clipShape(Capsule())` or `Capsule()` stroke.
        ///
        /// Design.md §5.4 `mediumBadge.shape`.
        public static let shape: String = "pill"  // Descriptor — use Capsule() in SwiftUI

        /// Corner radius for badge background rectangle.
        ///
        /// = ``FoundationTokens/Radius/sm`` (8pt).
        /// Prefer `Capsule()` shape; radius is a fallback for explicit `RoundedRectangle`.
        ///
        /// Design.md §5.4 `mediumBadge.radius`.
        public static let radius: CGFloat = FoundationTokens.Radius.sm

        /// Vertical padding (top and bottom) inside the badge.
        ///
        /// 4pt — tight pill; avoids over-tall badges in list rows.
        ///
        /// Design.md §5.4 `mediumBadge.padding` (vertical).
        public static let paddingVertical: CGFloat = 4

        /// Horizontal padding (leading and trailing) inside the badge.
        ///
        /// 8pt — provides breathing room around icon + label.
        ///
        /// Design.md §5.4 `mediumBadge.padding` (horizontal).
        public static let paddingHorizontal: CGFloat = 8

        /// Horizontal gap between the medium icon and the label text.
        ///
        /// 4pt — = ``FoundationTokens/Space/xs`` — tight icon-label pair.
        ///
        /// Design.md §5.4 `mediumBadge.iconLabelGap`.
        public static let iconLabelGap: CGFloat = FoundationTokens.Space.xs
    }
}
