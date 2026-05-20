// SemanticTokens.swift
// Still Hours — Design System Semantic Tokens
//
// R11 Cool Blue semantic mappings (2026-05-21).
// Source: docs/Design-R11-ColdBlue.md §3. 26 tokens.
//
// Named aliases over Foundation primitives via Color.sh* extension.
// Maps directly to Design-R11 §3 (Semantic Color tokens).
//
// Usage: reference via `SemanticTokens.nav.tint` etc.
// Component-level tokens live in `ComponentTokens.swift`.
//
// - Note: Design-R11-ColdBlue.md §3 is the authoritative source.
//   All Color.sh* aliases are defined in Color+StillHours.swift.
//   Foundation primitives live in FoundationTokens.swift (R11.1 owns).

import SwiftUI

// MARK: - SemanticTokens

// NOTE on Color.sh* aliases:
// SemanticTokens uses `Color.sh*` aliases from `Color+StillHours.swift` where available.
// Three R11 aliases (`shSurfaceElevated`, `shAccentSubtle`, `shSeparator`) are added by
// R11.1 to Color+StillHours.swift. Until R11.1 lands, they are bridged locally in the
// `SemanticTokens.Foundation` private helper below to keep this file independently buildable.
// Once R11.1 is merged, the local helper may be removed and calls updated to `Color.sh*`.


/// Semantic naming layer over the Cool Blue foundation palette.
///
/// All properties resolve to `Color.sh*` aliases from
/// `Color+StillHours.swift`, which in turn bridge to the foundation
/// primitives in `FoundationTokens`. This layer gives design-intent
/// names that survive palette changes without updating call sites.
///
/// **R11 pivot** (2026-05-21): replaced warm burnt-sienna mappings
/// with the Cool Blue palette. 26 tokens per Design-R11 §3.
///
/// - Important: Design-R11-ColdBlue.md §3 is the authoritative source.
///   Do **not** hard-code hex values here — always bridge through
///   the `Color.sh*` semantic aliases.
@available(iOS 17, macOS 14, *)
public enum SemanticTokens {

    // MARK: - Navigation

    /// Navigation and tab-bar color tokens. Design-R11 §3 tokens 1–5.
    public enum nav {

        /// NavigationStack accent. Back-chevron, large-title accent glyphs.
        ///
        /// = `Color.shAccent` (`accent.default`).
        ///
        /// Design-R11 §3 token 1 `nav.tint`.
        public static var tint: Color { Color.shAccent }

        /// Navigation bar background, translucent over Liquid Glass.
        ///
        /// Raw background value when material is disabled.
        /// = `Color.shBackground` (`background`).
        ///
        /// Design-R11 §3 token 2 `nav.background`.
        public static var background: Color { Color.shBackground }
    }

    // MARK: - Tab Bar

    /// Tab bar color tokens. Design-R11 §3 tokens 3–5.
    public enum tab {

        /// Selected tab icon + label.
        ///
        /// = `Color.shAccent` (`accent.default`).
        ///
        /// Design-R11 §3 token 3 `tab.active.tint`.
        public enum active {
            public static var tint: Color { Color.shAccent }
        }

        /// Inactive tab icon + label. Not a third-tier grey —
        /// type hierarchy stays at 2 levels (Design-R11 §9 Q-D).
        ///
        /// = `Color.shTextSecondary` (`text.secondary`).
        ///
        /// Design-R11 §3 token 4 `tab.inactive.tint`.
        public enum inactive {
            public static var tint: Color { Color.shTextSecondary }
        }

        /// Tab bar plate beneath Liquid Glass.
        ///
        /// = `Color.shSurface` (`surface.primary`).
        ///
        /// Design-R11 §3 token 5 `tab.background`.
        public static var background: Color { Color.shSurface }
    }

    // MARK: - Card

    /// Card color tokens. Design-R11 §3 tokens 6–8.
    public enum card {

        /// ItemCardView base surface.
        ///
        /// = `Color.shSurface` (`surface.primary`).
        ///
        /// Design-R11 §3 token 6 `card.background`.
        public static var background: Color { Color.shSurface }

        /// ItemCardView hover, drag-source ghost, popover sheet behind a card.
        ///
        /// = `Color.shSurfaceElevated` (`surface.elevated`).
        ///
        /// Design-R11 §3 token 7 `card.elevated`.
        public static var elevated: Color { Color.shSurfaceElevated }

        /// 0.5pt hairline on cards in dense grids; omitted in 1-up detail.
        ///
        /// = `Color.shSeparator` (`separator`).
        ///
        /// Design-R11 §3 token 8 `card.border`.
        public static var border: Color { Color.shSeparator }
    }

    // MARK: - CTA

    /// Call-to-action color tokens. Design-R11 §3 tokens 9–12.
    public enum cta {

        /// Primary CTA button tokens ("Add memory", "Save").
        public enum primary {

            /// Primary CTA button background fill.
            ///
            /// = `Color.shAccent` (`accent.default`).
            ///
            /// Design-R11 §3 token 9 `cta.primary.fill`.
            public static var fill: Color { Color.shAccent }

            /// Text / glyph on primary CTA.
            ///
            /// ≥17pt SF Pro Semibold required for AA Large in dark mode (3.29:1).
            /// = `Color.shOnAccent` (`onAccent`).
            ///
            /// Design-R11 §3 token 10 `cta.primary.text`.
            public static var text: Color { Color.shOnAccent }
        }

        /// Secondary CTA button tokens ("Cancel", "Later").
        public enum secondary {

            /// Secondary CTA button background fill.
            ///
            /// = `Color.shAccentMuted` (`accent.muted`).
            ///
            /// Design-R11 §3 token 11 `cta.secondary.fill`.
            public static var fill: Color { Color.shAccentMuted }

            /// Text on secondary CTA. AA clean.
            ///
            /// = `Color.shAccent` (`accent.default`).
            ///
            /// Design-R11 §3 token 12 `cta.secondary.text`.
            public static var text: Color { Color.shAccent }
        }
    }

    // MARK: - List Row

    /// List row interaction color tokens. Design-R11 §3 tokens 13–14.
    public enum list {

        public enum row {

            /// Selected list row wash.
            ///
            /// = `Color.shAccentMuted` (`accent.muted`).
            ///
            /// Design-R11 §3 token 13 `list.row.selected.fill`.
            public enum selected {
                public static var fill: Color { Color.shAccentMuted }
            }

            /// Momentary press state.
            ///
            /// = `Color.shAccentSubtle` (`accent.subtle`).
            ///
            /// Design-R11 §3 token 14 `list.row.pressed.fill`.
            public enum pressed {
                public static var fill: Color { Color.shAccentSubtle }
            }
        }
    }

    // MARK: - Liquid Glass

    /// Liquid Glass material color tokens. Design-R11 §3 token 15, §8.
    public enum liquidGlass {

        /// Tint passed to `.glassEffect(.regular.tint(_))` in tab bar
        /// and memory-count badge. Always the same tint — no per-view
        /// variation. See Design-R11 §8 for the full treatment rationale.
        ///
        /// = `Color.shAccentSubtle` (`accent.subtle`).
        ///
        /// Design-R11 §3 token 15 `liquidGlass.tint.subtle`.
        public enum tint {
            public static var subtle: Color { Color.shAccentSubtle }
        }
    }

    // MARK: - Medium Tints

    /// Per-medium icon tint tokens. Design-R11 §3 tokens 16–19.
    ///
    /// All 4 medium types share `accent.default`. The SF Symbol shape
    /// is the differentiator, not hue. Design-R11 §3.1.
    public enum medium {

        /// Book medium icon tint.
        ///
        /// Single accent for all medium tints — shape (SF Symbol) is the
        /// differentiator, not hue. Design-R11 §3.1.
        ///
        /// = `Color.shAccent` (`accent.default`).
        ///
        /// Design-R11 §3 token 16 `medium.book.tint`.
        public enum book {
            public static var tint: Color { Color.shAccent }
        }

        /// Music medium icon tint.
        ///
        /// Single accent for all medium tints — shape (SF Symbol) is the
        /// differentiator, not hue. Design-R11 §3.1.
        ///
        /// = `Color.shAccent` (`accent.default`).
        ///
        /// Design-R11 §3 token 17 `medium.music.tint`.
        public enum music {
            public static var tint: Color { Color.shAccent }
        }

        /// Movie medium icon tint.
        ///
        /// Single accent for all medium tints — shape (SF Symbol) is the
        /// differentiator, not hue. Design-R11 §3.1.
        ///
        /// = `Color.shAccent` (`accent.default`).
        ///
        /// Design-R11 §3 token 18 `medium.movie.tint`.
        public enum movie {
            public static var tint: Color { Color.shAccent }
        }

        /// Object medium icon tint.
        ///
        /// Single accent for all medium tints — shape (SF Symbol) is the
        /// differentiator, not hue. Design-R11 §3.1.
        ///
        /// = `Color.shAccent` (`accent.default`).
        ///
        /// Design-R11 §3 token 19 `medium.object.tint`.
        public enum object {
            public static var tint: Color { Color.shAccent }
        }
    }

    // MARK: - Memory Kind Tint

    /// Memory kind icon tint. Design-R11 §3 token 20.
    ///
    /// Applied to all 8 memory kinds (acquired, read, listened, watched,
    /// lent, received, gifted, annotated). Single tint keeps the timeline
    /// quiet — icon glyph and row metadata identify the kind, not color.
    /// Design-R11 §3.1.
    public enum memory {

        public enum kind {

            /// Tint color for all 8 memory-kind glyphs.
            ///
            /// Single accent for all memory kinds — icon glyph and row metadata
            /// are the differentiators, not hue. Design-R11 §3.1.
            ///
            /// = `Color.shAccent` (`accent.default`).
            ///
            /// Design-R11 §3 token 20 `memory.kind.tint`.
            public static var tint: Color { Color.shAccent }

            /// SF Symbol names for each memory kind.
            ///
            /// Matches SFSymbols-Selection.md (SF Symbols 7 library).
            /// Use with `Image(systemName:)` — never hard-code the string at call sites.
            public enum icon {

                /// Item acquired (purchased). `"shippingbox.fill"`.
                public static let acquired = "shippingbox.fill"

                /// Book or article read. `"text.book.closed.fill"`.
                public static let read = "text.book.closed.fill"

                /// Album or track listened. `"headphones"`.
                public static let listened = "headphones"

                /// Film or series watched. `"film.fill"`.
                public static let watched = "film.fill"

                /// Item lent to someone. `"arrow.uturn.left"`.
                public static let lent = "arrow.uturn.left"

                /// Gift received. `"arrow.down.left.square.fill"`.
                public static let received = "arrow.down.left.square.fill"

                /// Item gifted to someone. `"gift.fill"`.
                public static let gifted = "gift.fill"

                /// Annotation or marginalia added. `"pencil.line"`.
                public static let annotated = "pencil.line"
            }
        }
    }

    // MARK: - Timeline

    /// MemoryTimelineView rail and year-header color tokens. Design-R11 §3 tokens 21–23.
    public enum timeline {

        /// 1pt vertical rail down MemoryTimelineView.
        ///
        /// Tinted accent at 18% alpha — reads as system rail, not a paint stroke.
        /// Using `separator` makes the rail inert grey; `accent.subtle` blends into
        /// the surface. 18% accent gives a faint blue cast that reads as "the brand
        /// spine of the view." Design-R11 §3.1 `timeline.rail` decision rationale.
        ///
        /// = `Color.shAccent.opacity(0.18)`.
        ///
        /// Design-R11 §3 token 21 `timeline.rail`.
        public static var rail: Color { Color.shAccent.opacity(0.18) }

        /// Current-month / scroll-locked year header text.
        ///
        /// = `Color.shAccent` (`accent.default`).
        ///
        /// Design-R11 §3 token 22 `timeline.year.active`.
        public enum year {
            public static var active: Color { Color.shAccent }

            /// Off-screen year labels in the sticky header.
            ///
            /// = `Color.shTextSecondary` (`text.secondary`).
            ///
            /// Design-R11 §3 token 23 `timeline.year.inactive`.
            public static var inactive: Color { Color.shTextSecondary }
        }
    }

    // MARK: - Status

    /// System status color tokens. Design-R11 §3 tokens 24–26.
    ///
    /// Uses Apple system colors — a brand variant would compete with content
    /// for hue space and impose a learnability cost on the decade-long
    /// systemRed = destructive affordance. Design-R11 §3.
    public enum status {

        /// Destructive / error state fill.
        ///
        /// Uses Apple systemRed (`#ff3b30` light / `#ff453a` dark).
        /// Kept system — brand red would compete with content. Design-R11 §3.
        ///
        /// Design-R11 §3 token 24 `error.fill`.
        public static var error: Color { Color.red }

        /// Warning state fill.
        ///
        /// Uses Apple systemOrange (`#ff9500` light / `#ff9f0a` dark).
        /// The only warm tone in the chrome, reserved exclusively for warnings.
        /// Design-R11 §3.
        ///
        /// Design-R11 §3 token 25 `warning.fill`.
        public static var warning: Color { Color.orange }

        /// Success / confirmatory state fill.
        ///
        /// Uses Apple systemGreen (`#34c759` light / `#30d158` dark).
        /// Kept system. Design-R11 §3.
        ///
        /// Design-R11 §3 token 26 `success.fill`.
        public static var success: Color { Color.green }
    }

    // MARK: - Medium Icons (SF Symbol names)

    /// SF Symbol names for each content medium.
    ///
    /// Matches SFSymbols-Selection.md (SF Symbols 7 library).
    /// Design-R11 §3. SFSymbols-Selection.md §Medium.
    public enum mediumIcon {

        /// Book / reading medium. `"book.closed.fill"`.
        public static let book = "book.closed.fill"

        /// Music / audio medium. `"music.note"`.
        public static let music = "music.note"

        /// Movie / video medium. `"film.fill"`.
        public static let movie = "film.fill"

        /// Physical object / collectible medium. `"cube.fill"`.
        public static let object = "cube.fill"
    }

    // MARK: - Private Foundation Bridge

    /// Internal bridge for R11 foundation tokens not yet exposed via `Color.sh*` aliases.
    ///
    /// `Color.shSurfaceElevated`, `Color.shAccentSubtle`, and `Color.shSeparator` are
    /// added to `Color+StillHours.swift` by R11.1. Until that lands, this internal helper
    /// bridges directly to `FoundationTokens` using the same `Color(light:dark:)` pattern
    /// used by `Color+StillHours.swift`. Once R11.1 is merged, this enum can be removed
    /// and the call sites updated to `Color.shSurfaceElevated` etc.
    internal enum Foundation {

        /// `surface.elevated` — hover, pressed, popover-over-card.
        /// Bridges `FoundationTokens.Color.lightSurfaceElevated/darkSurfaceElevated`.
        static var surfaceElevated: Color {
            Color(light: FoundationTokens.Color.lightSurfaceElevated,
                  dark:  FoundationTokens.Color.darkSurfaceElevated)
        }

        /// `accent.subtle` — Liquid Glass tint, hover dim.
        /// Bridges `FoundationTokens.Color.lightAccentSubtle/darkAccentSubtle`.
        static var accentSubtle: Color {
            Color(light: FoundationTokens.Color.lightAccentSubtle,
                  dark:  FoundationTokens.Color.darkAccentSubtle)
        }

        /// `separator` — hairlines, card borders.
        /// Bridges `FoundationTokens.Color.lightSeparator/darkSeparator`.
        static var separator: Color {
            Color(light: FoundationTokens.Color.lightSeparator,
                  dark:  FoundationTokens.Color.darkSeparator)
        }
    }
}

// MARK: - Color(light:dark:) Helper

@available(iOS 17, macOS 14, *)
private extension Color {

    /// Constructs an adaptive color that resolves to `light` in light mode
    /// and `dark` in dark mode.
    ///
    /// Used internally by ``SemanticTokens`` to bridge Foundation primitives
    /// into adaptive semantic tokens. iOS / iPadOS only — see the matching
    /// helper in Color+StillHours.swift for the macOS host fallback rationale.
    init(light: Color, dark: Color) {
        #if canImport(UIKit)
        self.init(uiColor: UIColor { traits in
            traits.userInterfaceStyle == .dark
                ? UIColor(dark)
                : UIColor(light)
        })
        #else
        self = light
        #endif
    }
}
