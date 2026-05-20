// FoundationTokens.swift
// Still Hours — Design System Foundation Tokens v1.0
//
// R11 Cool Blue palette (2026-05-21). Replaces R8-R10 warm terra direction.
// Source of truth: docs/Design-R11-ColdBlue.md §2.
//
// Single source of truth for all primitive design values.
// Maps directly to Design.md §3 (Foundation Tokens).
//
// Usage: reference via `FoundationTokens.Color.lightBackground` etc.
// Semantic aliases live in `Color+StillHours.swift`.
//
// - Note: Design.md §3.1–§3.6 (2026-05-21, R11 Cool Blue update).

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

    /// Raw color palette. R11 Cool Blue. Design-R11-ColdBlue.md §2 (2026-05-21).
    ///
    /// Prefer semantic aliases (`Color.shBackground` etc.) in view code.
    /// Use these raw values only when building the semantic layer.
    ///
    /// 11 foundation tokens × 2 modes. `onAccent` is universal (same in both modes).
    public enum Color {

        // MARK: Light Mode — 11 tokens (incl. universal onAccent)

        /// Cool off-white app root background. `#f4f7fb`.
        ///
        /// Subtly cool; not pure white. Gives white cards one tonal step of separation.
        /// Design-R11 §2.1. WCAG: `text.primary` on this background = AAA 17.43:1.
        public static let lightBackground = SwiftUI.Color(
            red: 0.957, green: 0.969, blue: 0.984
        )

        /// Pure white card / sheet / list-row surface. `#ffffff`.
        ///
        /// Floated above `lightBackground`; the cool bg makes pure white read as surface.
        /// Design-R11 §2.1. WCAG: `text.primary` on surface = AAA 18.72:1.
        public static let lightSurface = SwiftUI.Color(
            red: 1.000, green: 1.000, blue: 1.000
        )

        /// Faint cool tint elevated surface. `#eef3fa`.
        ///
        /// Hover / pressed / popover-over-card. Hue lift instead of shadow.
        /// Design-R11 §2.1. WCAG: `text.primary` on elevated = AAA 16.41:1.
        public static let lightSurfaceElevated = SwiftUI.Color(
            red: 0.933, green: 0.953, blue: 0.980
        )

        /// Near-black with cool cast primary text. `#0b1220`.
        ///
        /// Headings, body copy, primary glyphs. Avoids pure black buzz on OLED.
        /// Design-R11 §2.1. WCAG: on background = AAA 17.43:1; on surface = AAA 18.72:1.
        public static let lightTextPrimary = SwiftUI.Color(
            red: 0.043, green: 0.071, blue: 0.125
        )

        /// Cool blue-gray secondary text. `#5b6b80`.
        ///
        /// Captions, metadata, year labels. AA-clean on both background and surface.primary.
        /// Design-R11 §2.1. WCAG: on background = AA 5.07:1; on surface = AA 5.45:1.
        public static let lightTextSecondary = SwiftUI.Color(
            red: 0.357, green: 0.420, blue: 0.502
        )

        /// Third-tier text — cool gray. `#8a98ad`. (R11 token #11, Q-D Option B.)
        ///
        /// ItemDetailView subtitle, MemoryTimelineView year-not-current, SettingsView footer.
        /// Deterministic contrast — avoids per-view opacity bikeshed from R10.
        /// Design-R11 §9 Option B. WCAG: on background = AA; avoid pairing with surface.elevated.
        public static let lightTextTertiary = SwiftUI.Color(
            red: 0.541, green: 0.596, blue: 0.678
        )

        /// Cool blue primary interactive accent. `#1d6fe5`.
        ///
        /// CTAs, tab.active, timeline.year.active. Slight cyan lean of Apple systemBlue.
        /// Design-R11 §2.1. WCAG: on background = AA 4.59:1; on surface = AA 4.93:1.
        public static let lightAccentDefault = SwiftUI.Color(
            red: 0.114, green: 0.435, blue: 0.898
        )

        /// Selected-row wash / secondary-CTA fill. `#dbe7fa`.
        ///
        /// Selected list row, secondary CTA background, accent-on-accent plate.
        /// Design-R11 §2.1. WCAG: `text.primary` on accent.muted = AAA 16.65:1.
        public static let lightAccentMuted = SwiftUI.Color(
            red: 0.859, green: 0.906, blue: 0.980
        )

        /// Near-background accent tint. `#eff4fc`.
        ///
        /// Hover dim, Liquid Glass tint parameter (`.glassEffect(.regular.tint(...))`).
        /// Almost-bg with faintest blue cast. Design-R11 §2.1.
        public static let lightAccentSubtle = SwiftUI.Color(
            red: 0.937, green: 0.957, blue: 0.988
        )

        /// White foreground on accent fills. `#ffffff`. Universal (same in both modes).
        ///
        /// Text / glyph on `accent.default` filled buttons. ≥17pt SF Pro Semibold required
        /// in dark mode (3.29:1 AA Large). Light mode: 4.71:1 AA normal.
        /// Design-R11 §2.1 + §2.3. `onAccent` is mode-invariant.
        public static let onAccent = SwiftUI.Color(
            red: 1.000, green: 1.000, blue: 1.000
        )

        /// Hairline separator. `#e2e8f0`.
        ///
        /// List dividers, card borders at 0.5pt. Decorative only — do not use for text.
        /// Design-R11 §2.1. WCAG: decorative (1.07:1 on background — not a text pair).
        public static let lightSeparator = SwiftUI.Color(
            red: 0.886, green: 0.910, blue: 0.941
        )

        // MARK: Dark Mode — 10 tokens (onAccent shared from above)

        /// Deep cool navy root background. `#0b1220`.
        ///
        /// Mirrors light `text.primary` — modes invert cleanly. Not pure black.
        /// Design-R11 §2.2. WCAG: `text.primary` on background = AAA 16.97:1.
        public static let darkBackground = SwiftUI.Color(
            red: 0.043, green: 0.071, blue: 0.125
        )

        /// Dark card / sheet / list-row surface. `#121a2a`.
        ///
        /// One tonal step above `darkBackground`. Card boundary reads without a border.
        /// Design-R11 §2.2. WCAG: `text.primary` on surface = AAA 15.77:1.
        public static let darkSurface = SwiftUI.Color(
            red: 0.071, green: 0.102, blue: 0.165
        )

        /// Hover / sheet-over-card elevated surface. `#1a2336`.
        ///
        /// Design-R11 §2.2. WCAG: `text.primary` on elevated = AAA 13.49:1.
        public static let darkSurfaceElevated = SwiftUI.Color(
            red: 0.102, green: 0.137, blue: 0.212
        )

        /// Cool off-white primary text. `#f0f4fa`.
        ///
        /// Not pure `#ffffff` — avoids glare on OLED. Same cool family as light mode.
        /// Design-R11 §2.2. WCAG: on background = AAA 16.97:1; on surface = AAA 15.77:1.
        public static let darkTextPrimary = SwiftUI.Color(
            red: 0.941, green: 0.957, blue: 0.980
        )

        /// Cool blue-gray secondary text (dark). `#8a98ad`.
        ///
        /// Captions, metadata. AA-clean on both dark background and surface.primary.
        /// Design-R11 §2.2. WCAG: on background = AA 6.40:1; on surface = AA 5.95:1.
        public static let darkTextSecondary = SwiftUI.Color(
            red: 0.541, green: 0.596, blue: 0.678
        )

        /// Third-tier text dark mode. `#5b6b80`. (R11 token #11, Q-D Option B.)
        ///
        /// Exact inverse of light `text.secondary` — clean inversion so modes read as same palette.
        /// Design-R11 §9 Option B. WCAG: AA against dark background.
        public static let darkTextTertiary = SwiftUI.Color(
            red: 0.357, green: 0.420, blue: 0.502
        )

        /// Lifted cool blue accent. `#4d8df0`.
        ///
        /// Same hue family as light accent, lifted ~25% in L to stay visible on navy bg.
        /// Design-R11 §2.2. WCAG: on background = AA 6.06:1; on surface = AA 5.62:1.
        public static let darkAccentDefault = SwiftUI.Color(
            red: 0.302, green: 0.553, blue: 0.941
        )

        /// Selected-row wash in dark mode. `#1a2940`.
        ///
        /// Dark-mode equivalent of light `accent.muted`.
        /// Design-R11 §2.2. WCAG: `text.primary` on accent.muted = AAA 13.39:1.
        public static let darkAccentMuted = SwiftUI.Color(
            red: 0.102, green: 0.161, blue: 0.251
        )

        /// Liquid Glass tint / hover dim (dark). `#15233a`.
        ///
        /// Dark-mode equivalent of light `accent.subtle`.
        /// Design-R11 §2.2.
        public static let darkAccentSubtle = SwiftUI.Color(
            red: 0.082, green: 0.137, blue: 0.227
        )

        /// Hairline separator (dark). `#1f2a3e`.
        ///
        /// Reads as a line, not a shadow. Decorative only.
        /// Design-R11 §2.2. WCAG: decorative (1.45:1 on background — not a text pair).
        public static let darkSeparator = SwiftUI.Color(
            red: 0.122, green: 0.165, blue: 0.243
        )
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
