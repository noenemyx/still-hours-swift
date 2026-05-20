// SemanticTokens.swift
// Still Hours — Design System Semantic Tokens v1.0
//
// Named aliases over Foundation primitives.
// Maps directly to Design.md §4 (Semantic Tokens).
//
// Usage: reference via `SemanticTokens.surface.primary` etc.
// Component-level tokens live in `ComponentTokens.swift`.
//
// - Note: Design.md §4 (2026-05-20 final). SFSymbols-Selection.md for icon names.

import SwiftUI

// MARK: - SemanticTokens

/// Semantic naming layer over ``FoundationTokens``.
///
/// All properties resolve to Foundation primitives; this layer exists to give
/// design-intent names that survive palette changes without updating call sites.
///
/// **v1.0 baseline**: single burnt-sienna accent across all media types.
/// **v0.5 roadmap**: per-medium accent palette (see `accent.medium.*` comments).
///
/// - Important: Design.md §4 is the authoritative source.
///   Do **not** hard-code hex values here — always bridge through `FoundationTokens`.
@available(iOS 17, macOS 14, *)
public enum SemanticTokens {

    // MARK: - Surface

    /// Surface-level color tokens. Design.md §4.1.
    ///
    /// Use these instead of raw `FoundationTokens.Color.*` values in view code.
    public enum surface {

        /// Root screen background.
        ///
        /// = `FoundationTokens.Color.lightBackground` (light) /
        ///   `FoundationTokens.Color.darkBackground` (dark).
        ///
        /// Design.md §4.1 `surface.primary`.
        public static var primary: Color {
            Color(light: FoundationTokens.Color.lightBackground,
                  dark:  FoundationTokens.Color.darkBackground)
        }

        /// Cards, list rows, sheets — one step above `primary`.
        ///
        /// = `FoundationTokens.Color.lightSurface` (light) /
        ///   `FoundationTokens.Color.darkSurface` (dark).
        ///
        /// Design.md §4.1 `surface.elevated`.
        public static var elevated: Color {
            Color(light: FoundationTokens.Color.lightSurface,
                  dark:  FoundationTokens.Color.darkSurface)
        }

        /// Floating panels, popovers — `elevated` color + `shadow.floating`.
        ///
        /// = `FoundationTokens.Color.lightSurface` / `FoundationTokens.Color.darkSurface`
        ///   Apply via ``View/shFloatingShadow()`` for the shadow component.
        ///
        /// Design.md §4.1 `surface.floated`.
        public static var floated: Color {
            Color(light: FoundationTokens.Color.lightSurface,
                  dark:  FoundationTokens.Color.darkSurface)
        }
    }

    // MARK: - Text

    /// Text color tokens. Design.md §4.2.
    public enum text {

        /// Body copy, headings — highest contrast.
        ///
        /// = `FoundationTokens.Color.lightTextPrimary` / `darkTextPrimary`.
        ///
        /// Design.md §4.2 `text.primary`.
        public static var primary: Color {
            Color(light: FoundationTokens.Color.lightTextPrimary,
                  dark:  FoundationTokens.Color.darkTextPrimary)
        }

        /// Subtitles, captions, metadata — reduced contrast.
        ///
        /// = `FoundationTokens.Color.lightTextSecondary` / `darkTextSecondary`.
        ///
        /// Design.md §4.2 `text.secondary`.
        public static var secondary: Color {
            Color(light: FoundationTokens.Color.lightTextSecondary,
                  dark:  FoundationTokens.Color.darkTextSecondary)
        }

        /// Accent-colored text — interactive labels, links.
        ///
        /// = `FoundationTokens.Color.lightAccentDefault` / `darkAccentDefault`.
        ///
        /// Design.md §4.2 `text.accent`.
        public static var accent: Color {
            Color(light: FoundationTokens.Color.lightAccentDefault,
                  dark:  FoundationTokens.Color.darkAccentDefault)
        }

        /// Visually de-emphasized text — placeholder, disabled state.
        ///
        /// Aliases `text.secondary`; distinguished by intent.
        ///
        /// = `FoundationTokens.Color.lightTextSecondary` / `darkTextSecondary`.
        ///
        /// Design.md §4.2 `text.muted`.
        public static var muted: Color {
            Color(light: FoundationTokens.Color.lightTextSecondary,
                  dark:  FoundationTokens.Color.darkTextSecondary)
        }

        /// Text color for labels on accent-colored filled surfaces (CTA buttons).
        ///
        /// Always use this token — never `text.primary` or `text.muted` — when text
        /// sits directly on `accent.default` (e.g. a filled primary button).
        ///
        /// = `FoundationTokens.Color.onAccent` (`#1A1812`) for both light and dark.
        ///
        /// WCAG 2.1:
        /// - Light: `#1A1812` on `#B85C38` = 3.91:1 (AA Large; use ≥18pt or ≥14pt bold)
        /// - Dark:  `#1A1812` on `#D4734A` = **5.37:1 AA ★**
        ///
        /// Design.md §4.2 `text.onAccent` / §4.3 `accent.onAccent`.
        public static var onAccent: Color {
            Color(light: FoundationTokens.Color.onAccent,
                  dark:  FoundationTokens.Color.onAccent)
        }
    }

    // MARK: - Accent

    /// Accent color tokens. Design.md §4.3.
    ///
    /// **v1.0 baseline**: `accent.medium.*` all resolve to `accent.default`.
    /// **v0.5 roadmap**: per-medium accent tokens will diverge (see inline comments).
    public enum accent {

        /// Primary interactive accent — burnt sienna.
        ///
        /// = `FoundationTokens.Color.lightAccentDefault` / `darkAccentDefault`.
        ///
        /// Design.md §4.3 `accent.default`.
        public static var `default`: Color {
            Color(light: FoundationTokens.Color.lightAccentDefault,
                  dark:  FoundationTokens.Color.darkAccentDefault)
        }

        /// Non-interactive accent highlight — warm sand.
        ///
        /// = `FoundationTokens.Color.lightAccentMuted` / `darkAccentMuted`.
        ///
        /// Design.md §4.3 `accent.muted`.
        ///
        /// - Warning: **Do not use as a text foreground color (WCAG fail in Light mode).**
        ///   Light `#D4A574` on background = 1.96:1, on surface = 2.13:1.
        ///   Permitted uses: skeleton loading fills, disabled-state backgrounds/borders,
        ///   image placeholder backgrounds, decorative non-text icon fills.
        ///   For text over a muted background, use `text.secondary` instead.
        public static var muted: Color {
            Color(light: FoundationTokens.Color.lightAccentMuted,
                  dark:  FoundationTokens.Color.darkAccentMuted)
        }

        /// Text/icon color for labels placed on top of accent-colored filled surfaces.
        ///
        /// Use on filled `accent.default` buttons — not `text.primary`.
        ///
        /// = `FoundationTokens.Color.onAccent` (`#1A1812`) — same value for Light and Dark.
        ///
        /// WCAG 2.1:
        /// - On light `accent.default` `#B85C38`: 3.91:1 (AA Large — ≥18pt or ≥14pt bold)
        /// - On dark `accent.default` `#D4734A`: **5.37:1 AA ★**
        ///
        /// Design.md §4.3 `accent.onAccent`.
        public static var onAccent: Color {
            Color(light: FoundationTokens.Color.onAccent,
                  dark:  FoundationTokens.Color.onAccent)
        }

        /// Per-medium accent namespace. Design.md §4.3.
        ///
        /// **v1.0 baseline**: all four resolve to `accent.default` (single palette).
        /// **v0.5 roadmap**: each medium receives a distinct hue to reinforce content category.
        ///
        /// - Note: In **Light mode**, all `accent.medium.*` values resolve to `accent.default`
        ///   (`#B85C38`), which achieves 4.00:1 on background and 4.34:1 on surface —
        ///   **AA Large only**. Use only for ≥18pt text or ≥14pt bold. For normal-size text,
        ///   prefer `text.primary` or `text.secondary`; use `text.accent` only as an indicator.
        public enum medium {

            /// Book medium accent.
            ///
            /// v1.0: = `accent.default` (burnt sienna).
            /// v0.5 TBD: warm amber — e.g. `#C97B2A` — to evoke aged paper / leather binding.
            ///
            /// Design.md §4.3 `accent.medium.book`.
            public static var book: Color { accent.default }

            /// Music medium accent.
            ///
            /// v1.0: = `accent.default` (burnt sienna).
            /// v0.5 TBD: deep teal — e.g. `#2A7C8A` — to evoke vinyl grooves / concert darkness.
            ///
            /// Design.md §4.3 `accent.medium.music`.
            public static var music: Color { accent.default }

            /// Movie medium accent.
            ///
            /// v1.0: = `accent.default` (burnt sienna).
            /// v0.5 TBD: muted burgundy — e.g. `#8A2A3C` — to evoke cinema drapes / film grain.
            ///
            /// Design.md §4.3 `accent.medium.movie`.
            public static var movie: Color { accent.default }

            /// Object medium accent.
            ///
            /// v1.0: = `accent.default` (burnt sienna).
            /// v0.5 TBD: slate blue — e.g. `#4A5B8A` — to evoke curio cabinet patina.
            ///
            /// Design.md §4.3 `accent.medium.object`.
            public static var object: Color { accent.default }
        }
    }

    // MARK: - Memory Kind Icons

    /// SF Symbol names for each memory kind.
    ///
    /// Matches SFSymbols-Selection.md (SF Symbols 7 library).
    /// Use with `Image(systemName:)` — never hard-code the string at call sites.
    ///
    /// Design.md §4.4. SFSymbols-Selection.md §Memory Kind.
    public enum memory {
        public enum kind {
            public enum icon {

                /// Item acquired (purchased). `"shippingbox.fill"`.
                ///
                /// SFSymbols-Selection.md: `shippingbox.fill`.
                public static let acquired = "shippingbox.fill"

                /// Book or article read. `"text.book.closed.fill"`.
                ///
                /// SFSymbols-Selection.md: `text.book.closed.fill`.
                public static let read = "text.book.closed.fill"

                /// Album or track listened. `"headphones"`.
                ///
                /// SFSymbols-Selection.md: `headphones`.
                public static let listened = "headphones"

                /// Film or series watched. `"film.fill"`.
                ///
                /// SFSymbols-Selection.md: `film.fill`.
                public static let watched = "film.fill"

                /// Item lent to someone. `"arrow.uturn.left"`.
                ///
                /// SFSymbols-Selection.md: `arrow.uturn.left`.
                public static let lent = "arrow.uturn.left"

                /// Gift received. `"arrow.down.left.square.fill"`.
                ///
                /// SFSymbols-Selection.md: `arrow.down.left.square.fill`.
                public static let received = "arrow.down.left.square.fill"

                /// Item gifted to someone. `"gift.fill"`.
                ///
                /// SFSymbols-Selection.md: `gift.fill`.
                public static let gifted = "gift.fill"

                /// Annotation or marginalia added. `"pencil.line"`.
                ///
                /// SFSymbols-Selection.md: `pencil.line`.
                public static let annotated = "pencil.line"
            }
        }
    }

    // MARK: - Medium Icons

    /// SF Symbol names for each content medium.
    ///
    /// Matches SFSymbols-Selection.md (SF Symbols 7 library).
    /// Design.md §4.5. SFSymbols-Selection.md §Medium.
    public enum mediumIcon {

        /// Book / reading medium. `"book.closed.fill"`.
        ///
        /// SFSymbols-Selection.md: `book.closed.fill`.
        public static let book = "book.closed.fill"

        /// Music / audio medium. `"music.note"`.
        ///
        /// SFSymbols-Selection.md: `music.note`.
        public static let music = "music.note"

        /// Movie / video medium. `"film.fill"`.
        ///
        /// SFSymbols-Selection.md: `film.fill`.
        public static let movie = "film.fill"

        /// Physical object / collectible medium. `"cube.fill"`.
        ///
        /// SFSymbols-Selection.md: `cube.fill`.
        public static let object = "cube.fill"
    }
}

// MARK: - Color(light:dark:) Helper

@available(iOS 17, macOS 14, *)
private extension Color {

    /// Constructs an adaptive color that resolves to `light` in light mode
    /// and `dark` in dark mode.
    ///
    /// Used internally by ``SemanticTokens`` to bridge Foundation primitives
    /// into adaptive semantic tokens.
    init(light: Color, dark: Color) {
        self.init(uiColor: UIColor { traits in
            traits.userInterfaceStyle == .dark
                ? UIColor(dark)
                : UIColor(light)
        })
    }
}
