// Color+StillHours.swift
// Still Hours — Semantic Color Extension v1.0
//
// R11 Cool Blue + text.tertiary (11th token). Source: Design-R11-ColdBlue.md §2, §9.
//
// SwiftUI Color extension exposing semantic aliases for all Design.md §3.1 tokens.
// Adapts automatically to Light / Dark mode via `colorScheme` environment.
//
// Naming convention: `Color.sh<Token>` (sh = Still Hours prefix).
// Design.md §3.1 + §4 Semantic Tokens.

import SwiftUI

// MARK: - Color.sh* Semantic Aliases

@available(iOS 17, macOS 14, *)
public extension Color {

    // MARK: Surface

    /// Cool off-white root background. `#f4f7fb` / `#0b1220` (dark).
    ///
    /// Use for the outermost `ZStack`/`NavigationStack` background.
    /// Design-R11 §2.1 `background`.
    static var shBackground: Color {
        Color(
            light: FoundationTokens.Color.lightBackground,
            dark: FoundationTokens.Color.darkBackground
        )
    }

    /// White card and sheet surface. `#ffffff` / `#121a2a` (dark).
    ///
    /// Item cards, Memory rows, Collection covers, popovers.
    /// Design-R11 §2.1 `surface.primary`.
    static var shSurface: Color {
        Color(
            light: FoundationTokens.Color.lightSurface,
            dark: FoundationTokens.Color.darkSurface
        )
    }

    /// Elevated hover / pressed / popover surface. `#eef3fa` / `#1a2336` (dark).
    ///
    /// Hover state, pressed card, popover-over-card. Hue lift instead of shadow.
    /// Design-R11 §2.1 `surface.elevated`.
    static var shSurfaceElevated: Color {
        Color(
            light: FoundationTokens.Color.lightSurfaceElevated,
            dark: FoundationTokens.Color.darkSurfaceElevated
        )
    }

    // MARK: Text

    /// Primary text color. `#0b1220` / `#f0f4fa` (dark).
    ///
    /// Item titles, body copy, Memory notes.
    /// Design-R11 §2.1 `text.primary`. WCAG: AAA 17.43:1 on background.
    static var shTextPrimary: Color {
        Color(
            light: FoundationTokens.Color.lightTextPrimary,
            dark: FoundationTokens.Color.darkTextPrimary
        )
    }

    /// Secondary / muted text. `#5b6b80` / `#8a98ad` (dark).
    ///
    /// Subtitles, captions, date/place/tag metadata.
    /// Design-R11 §2.1 `text.secondary`. WCAG: AA 5.07:1 on background.
    static var shTextSecondary: Color {
        Color(
            light: FoundationTokens.Color.lightTextSecondary,
            dark: FoundationTokens.Color.darkTextSecondary
        )
    }

    /// Third-tier text. `#8a98ad` / `#5b6b80` (dark). R11 token #11 (Q-D Option B).
    ///
    /// ItemDetailView subtitle line, MemoryTimelineView year-not-current label,
    /// SettingsView group footer. Deterministic contrast — eliminates per-view alpha (R10).
    /// Design-R11 §9 Option B. WCAG: AA against background in both modes.
    /// Avoid pairing with `surface.elevated` (below AA in that pairing).
    static var shTextTertiary: Color {
        Color(
            light: FoundationTokens.Color.lightTextTertiary,
            dark: FoundationTokens.Color.darkTextTertiary
        )
    }

    // MARK: Accent

    /// Interactive cool blue accent. `#1d6fe5` / `#4d8df0` (dark).
    ///
    /// CTAs, tab.active, timeline.year.active, focused borders.
    /// **Do not use for non-interactive decoration.** Use `shAccentMuted` instead.
    /// Design-R11 §2.1 `accent.default`. WCAG: AA 4.59:1 on background.
    static var shAccent: Color {
        Color(
            light: FoundationTokens.Color.lightAccentDefault,
            dark: FoundationTokens.Color.darkAccentDefault
        )
    }

    /// Selected-row wash / secondary-CTA fill. `#dbe7fa` / `#1a2940` (dark).
    ///
    /// Selected list row wash, secondary CTA background.
    /// Design-R11 §2.1 `accent.muted`. WCAG: `text.primary` on muted = AAA 16.65:1.
    static var shAccentMuted: Color {
        Color(
            light: FoundationTokens.Color.lightAccentMuted,
            dark: FoundationTokens.Color.darkAccentMuted
        )
    }

    /// Near-background accent tint. `#eff4fc` / `#15233a` (dark).
    ///
    /// Hover dim and Liquid Glass tint: `.glassEffect(.regular.tint(Color.shAccentSubtle))`.
    /// Design-R11 §2.1 `accent.subtle` + §8 Liquid Glass treatment.
    static var shAccentSubtle: Color {
        Color(
            light: FoundationTokens.Color.lightAccentSubtle,
            dark: FoundationTokens.Color.darkAccentSubtle
        )
    }

    /// White foreground on accent fills. `#ffffff` (universal — same in both modes).
    ///
    /// Use when text sits directly on `shAccent` filled button.
    /// Light mode: AA 4.71:1. Dark mode: AA Large 3.29:1 (≥17pt SF Pro Semibold required).
    /// Design-R11 §2.1 `onAccent`. Mode-invariant token.
    static var shOnAccent: Color {
        Color(
            light: FoundationTokens.Color.onAccent,
            dark: FoundationTokens.Color.onAccent
        )
    }

    /// Hairline separator. `#e2e8f0` / `#1f2a3e` (dark).
    ///
    /// List dividers, card borders at 0.5pt. Decorative only — not a text pair.
    /// Design-R11 §2.1 `separator`.
    static var shSeparator: Color {
        Color(
            light: FoundationTokens.Color.lightSeparator,
            dark: FoundationTokens.Color.darkSeparator
        )
    }

    // MARK: Convenience aliases (semantic layer — Design.md §4)

    /// Alias for `shTextSecondary`. Use for disabled text or placeholders.
    ///
    /// Design.md §4.2 `text.muted`.
    static var shTextMuted: Color { shTextSecondary }

    /// Alias for `shAccent`. Use for accent-colored text (links, interactive labels).
    ///
    /// Design.md §4.2 `text.accent`.
    static var shTextAccent: Color { shAccent }
}

// MARK: - Private Light/Dark Adaptive Initializer

@available(iOS 17, macOS 14, *)
private extension Color {

    /// Creates a `Color` that resolves to different values in light and dark mode.
    ///
    /// iOS / iPadOS: uses `UIColor.init(dynamicProvider:)` for live trait
    /// resolution. macOS host (SPM compile-check only — there is no shipped
    /// macOS target): falls back to the light variant, since the ship target
    /// is iOS-only and UIColor is unavailable.
    init(light: Color, dark: Color) {
        #if canImport(UIKit)
        self.init(
            UIColor { traitCollection in
                traitCollection.userInterfaceStyle == .dark
                    ? UIColor(dark)
                    : UIColor(light)
            }
        )
        #else
        self = light
        #endif
    }
}

// MARK: - UIColor Bridge
//
// iOS / iPadOS only — `UIColor` is unavailable on macOS host builds.
// Wrapping in `#if canImport(UIKit)` lets `swift build` succeed on the
// developer's Mac host (for the SPM test target compile-check) while
// keeping these aliases callable from device + simulator builds.

#if canImport(UIKit)
import UIKit

@available(iOS 17, *)
public extension UIColor {

    // MARK: Surface

    /// See `Color.shBackground`. Design-R11 §2.1.
    static var shBackground: UIColor {
        UIColor { $0.userInterfaceStyle == .dark
            ? UIColor(FoundationTokens.Color.darkBackground)
            : UIColor(FoundationTokens.Color.lightBackground)
        }
    }

    /// See `Color.shSurface`. Design-R11 §2.1.
    static var shSurface: UIColor {
        UIColor { $0.userInterfaceStyle == .dark
            ? UIColor(FoundationTokens.Color.darkSurface)
            : UIColor(FoundationTokens.Color.lightSurface)
        }
    }

    /// See `Color.shSurfaceElevated`. Design-R11 §2.1.
    static var shSurfaceElevated: UIColor {
        UIColor { $0.userInterfaceStyle == .dark
            ? UIColor(FoundationTokens.Color.darkSurfaceElevated)
            : UIColor(FoundationTokens.Color.lightSurfaceElevated)
        }
    }

    // MARK: Text

    /// See `Color.shTextPrimary`. Design-R11 §2.1.
    static var shTextPrimary: UIColor {
        UIColor { $0.userInterfaceStyle == .dark
            ? UIColor(FoundationTokens.Color.darkTextPrimary)
            : UIColor(FoundationTokens.Color.lightTextPrimary)
        }
    }

    /// See `Color.shTextSecondary`. Design-R11 §2.1.
    static var shTextSecondary: UIColor {
        UIColor { $0.userInterfaceStyle == .dark
            ? UIColor(FoundationTokens.Color.darkTextSecondary)
            : UIColor(FoundationTokens.Color.lightTextSecondary)
        }
    }

    /// See `Color.shTextTertiary`. Design-R11 §9 Option B (token #11).
    ///
    /// ItemDetailView subtitle, MemoryTimelineView year-not-current, SettingsView footer.
    static var shTextTertiary: UIColor {
        UIColor { $0.userInterfaceStyle == .dark
            ? UIColor(FoundationTokens.Color.darkTextTertiary)
            : UIColor(FoundationTokens.Color.lightTextTertiary)
        }
    }

    // MARK: Accent

    /// See `Color.shAccent`. Design-R11 §2.1.
    static var shAccent: UIColor {
        UIColor { $0.userInterfaceStyle == .dark
            ? UIColor(FoundationTokens.Color.darkAccentDefault)
            : UIColor(FoundationTokens.Color.lightAccentDefault)
        }
    }

    /// See `Color.shAccentMuted`. Design-R11 §2.1.
    static var shAccentMuted: UIColor {
        UIColor { $0.userInterfaceStyle == .dark
            ? UIColor(FoundationTokens.Color.darkAccentMuted)
            : UIColor(FoundationTokens.Color.lightAccentMuted)
        }
    }

    /// See `Color.shAccentSubtle`. Design-R11 §2.1 + §8 Liquid Glass.
    ///
    /// Near-background accent tint. Liquid Glass tint parameter.
    static var shAccentSubtle: UIColor {
        UIColor { $0.userInterfaceStyle == .dark
            ? UIColor(FoundationTokens.Color.darkAccentSubtle)
            : UIColor(FoundationTokens.Color.lightAccentSubtle)
        }
    }

    /// See `Color.shOnAccent`. Design-R11 §2.1 `onAccent`.
    ///
    /// White on accent fills. Light mode: AA 4.71:1. Dark mode: AA Large 3.29:1.
    /// Mode-invariant — same white in both modes.
    static var shOnAccent: UIColor {
        UIColor(FoundationTokens.Color.onAccent)
    }
}

#endif // canImport(UIKit)
