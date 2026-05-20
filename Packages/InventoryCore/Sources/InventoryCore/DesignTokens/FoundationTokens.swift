// FoundationTokens.swift
// Still Hours — Design System Foundation Tokens v1.0
//
// Single source of truth for all primitive design values.
// Maps directly to Design.md §3 (Foundation Tokens).
//
// Usage: reference via `FoundationTokens.Color.Light.background` etc.
// Semantic aliases live in `Color+StillHours.swift`.
//
// - Note: Design.md §3.1–§3.6 (2026-05-20 final).

import SwiftUI

// MARK: - FoundationTokens

/// Primitive design tokens for Still Hours.
///
/// All values are static constants. Do **not** instantiate this type.
/// Semantic aliases are in ``Color+StillHours`` and ``StillHoursTypeface``.
///
/// - Important: Design.md §3 is the authoritative source.
///   Update this file only after updating that document.
@available(iOS 17, macOS 14, *)
public enum FoundationTokens {

    // MARK: Color

    /// Raw color palette. Design.md §3.1 (v1.0 Final).
    ///
    /// Prefer semantic aliases (`Color.shBackground` etc.) in view code.
    /// Use these raw values only when building the semantic layer.
    public enum Color {

        // MARK: Light Mode — 6 tokens

        /// Warm parchment background. `#F5F0E8`.
        ///
        /// Still Hours identity color. Avoids cold white; evokes library paper.
        /// Use as root screen background. Design.md §3.1 Light Mode.
        public static let lightBackground = SwiftUI.Color(hex: 0xF5F0E8)

        /// Near-white card surface with warmth. `#FAFAF5`.
        ///
        /// Cards, sheets, popovers — floated above `lightBackground`.
        /// Design.md §3.1 Light Mode.
        public static let lightSurface = SwiftUI.Color(hex: 0xFAFAF5)

        /// Near-black primary text with warmth. `#1A1812`.
        ///
        /// Avoids pure black; evokes diluted ink.
        /// Design.md §3.1 Light Mode.
        public static let lightTextPrimary = SwiftUI.Color(hex: 0x1A1812)

        /// Muted warm gray secondary text. `#7A7060`.
        ///
        /// Subtitles, captions, metadata. Design.md §3.1 Light Mode.
        public static let lightTextSecondary = SwiftUI.Color(hex: 0x7A7060)

        /// Burnt sienna accent. `#B85C38`.
        ///
        /// Library leather binding color, Curio cabinet tone.
        /// Interactive elements only: buttons, links, toggle-ON states.
        /// Design.md §3.1 Light Mode.
        public static let lightAccentDefault = SwiftUI.Color(hex: 0xB85C38)

        /// Warm sand muted accent. `#D4A574`.
        ///
        /// Image fallback, skeleton states, non-interactive accent highlights.
        /// Design.md §3.1 Light Mode.
        public static let lightAccentMuted = SwiftUI.Color(hex: 0xD4A574)

        // MARK: Dark Mode — 4 primary + 2 inferred tokens

        /// Warm dark background. `#141210`.
        ///
        /// Avoids pure black; maintains warmth in dark context.
        /// Design.md §3.1 Dark Mode.
        public static let darkBackground = SwiftUI.Color(hex: 0x141210)

        /// Slightly elevated dark surface. `#1E1B17`.
        ///
        /// Cards and sheets in dark mode. Design.md §3.1 Dark Mode.
        public static let darkSurface = SwiftUI.Color(hex: 0x1E1B17)

        /// Warm off-white primary text (dark). `#F0EBE1`.
        ///
        /// Design.md §3.1 Dark Mode.
        public static let darkTextPrimary = SwiftUI.Color(hex: 0xF0EBE1)

        /// Muted warm light gray secondary text (dark). `#9A9285`.
        ///
        /// Inferred to maintain contrast ratio on `darkBackground`.
        /// Design.md §3.1 Dark Mode.
        public static let darkTextSecondary = SwiftUI.Color(hex: 0x9A9285)

        /// Burnt sienna accent at +30% lightness. `#D4734A`.
        ///
        /// Maintains contrast against dark background.
        /// Design.md §3.1 Dark Mode.
        public static let darkAccentDefault = SwiftUI.Color(hex: 0xD4734A)

        /// Warm sand dark variant. `#A88560`.
        ///
        /// Inferred dark mode variant of `lightAccentMuted`.
        /// Design.md §3.1 Dark Mode.
        public static let darkAccentMuted = SwiftUI.Color(hex: 0xA88560)
    }

    // MARK: Spacing

    /// 4pt/8pt grid spacing scale. Design.md §3.3 (v1.0 Final).
    public enum Space {

        /// 4pt — inline icon spacing. Design.md §3.3.
        public static let xs: CGFloat = 4

        /// 8pt — tight vertical gap, Memory row vertical padding. Design.md §3.3.
        public static let sm: CGFloat = 8

        /// 16pt — default card internal padding. Design.md §3.3.
        public static let md: CGFloat = 16

        /// 24pt — section gap. Design.md §3.3.
        public static let lg: CGFloat = 24

        /// 32pt — major section divider. Design.md §3.3.
        public static let xl: CGFloat = 32

        /// 48pt — empty state generous padding. Design.md §3.3.
        public static let xxl: CGFloat = 48
    }

    // MARK: Radius

    /// Corner radius scale. Design.md §3.4 (v1.0 Final).
    ///
    /// iOS 26 Liquid Glass forms refractive edges on rounded rects;
    /// radius is part of the visual identity.
    public enum Radius {

        /// 8pt — small button, chip, tag. Design.md §3.4.
        public static let sm: CGFloat = 8

        /// 12pt — card (Item / Memory / Collection cover). Design.md §3.4.
        public static let md: CGFloat = 12

        /// 16pt — sheet, popover. Design.md §3.4.
        public static let lg: CGFloat = 16

        /// 24pt — modal, large surface. Design.md §3.4.
        public static let xl: CGFloat = 24
    }

    // MARK: Shadow

    /// Shadow token parameters. Design.md §3.5 (v1.0 Final).
    ///
    /// In dark mode, use border + lighter surface instead of shadows —
    /// Liquid Glass dark variant provides depth natively.
    public enum Shadow {

        /// Warm gray shadow color used for all shadow tokens.
        static let color = SwiftUI.Color(hex: 0x7A7060)

        /// Card elevated above surface.
        ///
        /// `y: 2, blur: 8, opacity: 0.06`. Design.md §3.5.
        public struct elevated {
            public static let y: CGFloat = 2
            public static let blur: CGFloat = 8
            public static let opacity: Double = 0.06
            public static let color: SwiftUI.Color = Shadow.color
        }

        /// Sheet or popover floating above view hierarchy.
        ///
        /// `y: 4, blur: 16, opacity: 0.10`. Design.md §3.5.
        public struct floating {
            public static let y: CGFloat = 4
            public static let blur: CGFloat = 16
            public static let opacity: Double = 0.10
            public static let color: SwiftUI.Color = Shadow.color
        }
    }

    // MARK: Motion

    /// Animation timing tokens. Design.md §3.6 (v1.0 Final).
    ///
    /// Principle: calm motion — not fast, not sluggish. Slow + intentional.
    ///
    /// **Prohibited**: excessive spring (overshoot feels giddy),
    /// parallax overuse (distracting), auto-play video.
    ///
    /// **Reduced Motion**: when `accessibilityReduceMotion` is active,
    /// set all durations to 0 (instant). Keep cross-fade at 200ms max.
    public enum Motion {

        /// 200ms easeOut — tap response, button press. Design.md §3.6.
        public static let quick = Animation.easeOut(duration: 0.2)

        /// 300ms easeInOut — sheet present, navigation push. Design.md §3.6.
        public static let standard = Animation.easeInOut(duration: 0.3)

        /// 500ms easeInOut — onboarding step, Time Travel transition. Design.md §3.6.
        public static let deliberate = Animation.easeInOut(duration: 0.5)

        /// 800ms easeInOut — Memory entry auto-add animation (rare). Design.md §3.6.
        public static let slow = Animation.easeInOut(duration: 0.8)

        /// Raw durations for UIKit / CAAnimation contexts.
        public enum Duration {
            public static let quick: Double = 0.2
            public static let standard: Double = 0.3
            public static let deliberate: Double = 0.5
            public static let slow: Double = 0.8
        }

        /// Returns the appropriate animation for the current accessibility state.
        ///
        /// When Reduce Motion is enabled, returns an instant `.linear(duration: 0)`
        /// except for cross-fades which use a shortened `quick` timing.
        ///
        /// - Parameters:
        ///   - token: The preferred animation when reduce-motion is off.
        ///   - isCrossFade: Pass `true` for opacity-only transitions to preserve
        ///     the cross-fade (shortened to `quick`).
        public static func resolved(
            _ token: Animation,
            isCrossFade: Bool = false,
            reduceMotion: Bool
        ) -> Animation {
            guard reduceMotion else { return token }
            return isCrossFade ? quick : .linear(duration: 0)
        }
    }
}

// MARK: - SwiftUI View Modifiers

@available(iOS 17, macOS 14, *)
extension View {

    /// Applies the Still Hours elevated card shadow (light mode).
    ///
    /// Design.md §3.5 `shadow.elevated`.
    public func shElevatedShadow() -> some View {
        self.shadow(
            color: FoundationTokens.Shadow.elevated.color
                .opacity(FoundationTokens.Shadow.elevated.opacity),
            radius: FoundationTokens.Shadow.elevated.blur / 2,
            x: 0,
            y: FoundationTokens.Shadow.elevated.y
        )
    }

    /// Applies the Still Hours floating sheet shadow (light mode).
    ///
    /// Design.md §3.5 `shadow.floating`.
    public func shFloatingShadow() -> some View {
        self.shadow(
            color: FoundationTokens.Shadow.floating.color
                .opacity(FoundationTokens.Shadow.floating.opacity),
            radius: FoundationTokens.Shadow.floating.blur / 2,
            x: 0,
            y: FoundationTokens.Shadow.floating.y
        )
    }
}

// MARK: - Hex Color Initializer (SwiftUI + UIKit compatible)

extension SwiftUI.Color {

    /// Initializes a `Color` from a 24-bit hex integer.
    ///
    /// Example: `Color(hex: 0xF5F0E8)`
    ///
    /// Compatible with both SwiftUI and UIKit (via `UIColor` bridge).
    /// Design.md §3.1 — all palette values use this initializer.
    public init(hex: UInt32) {
        let r = Double((hex >> 16) & 0xFF) / 255.0
        let g = Double((hex >> 8) & 0xFF) / 255.0
        let b = Double(hex & 0xFF) / 255.0
        self.init(red: r, green: g, blue: b)
    }
}
