// Color+StillHours.swift
// Still Hours — Semantic Color Extension v1.0
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

    /// Warm parchment root background. `#F5F0E8` / `#141210` (dark).
    ///
    /// Use for the outermost `ZStack`/`NavigationStack` background.
    /// Design.md §3.1 `color.background` / §4.1 `surface.primary`.
    static var shBackground: Color {
        Color(
            light: FoundationTokens.Color.lightBackground,
            dark: FoundationTokens.Color.darkBackground
        )
    }

    /// Elevated card and sheet surface. `#FAFAF5` / `#1E1B17` (dark).
    ///
    /// Item cards, Memory rows, Collection covers, popovers.
    /// Design.md §3.1 `color.surface` / §4.1 `surface.elevated`.
    static var shSurface: Color {
        Color(
            light: FoundationTokens.Color.lightSurface,
            dark: FoundationTokens.Color.darkSurface
        )
    }

    // MARK: Text

    /// Primary text color. `#1A1812` / `#F0EBE1` (dark).
    ///
    /// Item titles, body copy, Memory notes.
    /// Design.md §3.1 `color.text.primary` / §4.2 `text.primary`.
    static var shTextPrimary: Color {
        Color(
            light: FoundationTokens.Color.lightTextPrimary,
            dark: FoundationTokens.Color.darkTextPrimary
        )
    }

    /// Secondary / muted text. `#7A7060` / `#9A9285` (dark).
    ///
    /// Subtitles, captions, date/place/tag metadata.
    /// Design.md §3.1 `color.text.secondary` / §4.2 `text.secondary`.
    static var shTextSecondary: Color {
        Color(
            light: FoundationTokens.Color.lightTextSecondary,
            dark: FoundationTokens.Color.darkTextSecondary
        )
    }

    // MARK: Accent

    /// Interactive accent — burnt sienna. `#B85C38` / `#D4734A` (dark).
    ///
    /// Buttons, links, toggle-ON states, focused borders.
    /// **Do not use for non-interactive decoration.** Use `shAccentMuted` instead.
    /// Design.md §3.1 `color.accent.default` / §4.3 `accent.default`.
    static var shAccent: Color {
        Color(
            light: FoundationTokens.Color.lightAccentDefault,
            dark: FoundationTokens.Color.darkAccentDefault
        )
    }

    /// Non-interactive warm sand accent. `#D4A574` / `#A88560` (dark).
    ///
    /// Image fallback placeholders, skeleton loading states, disabled highlights.
    /// Design.md §3.1 `color.accent.muted` / §4.3 `accent.muted`.
    static var shAccentMuted: Color {
        Color(
            light: FoundationTokens.Color.lightAccentMuted,
            dark: FoundationTokens.Color.darkAccentMuted
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
    /// Uses `UIColor.init(dynamicProvider:)` for UIKit compatibility.
    init(light: Color, dark: Color) {
        self.init(
            UIColor { traitCollection in
                traitCollection.userInterfaceStyle == .dark
                    ? UIColor(dark)
                    : UIColor(light)
            }
        )
    }
}

// MARK: - UIColor Bridge

@available(iOS 17, macOS 14, *)
public extension UIColor {

    // MARK: Surface

    /// See `Color.shBackground`. Design.md §3.1.
    static var shBackground: UIColor {
        UIColor { $0.userInterfaceStyle == .dark
            ? UIColor(FoundationTokens.Color.darkBackground)
            : UIColor(FoundationTokens.Color.lightBackground)
        }
    }

    /// See `Color.shSurface`. Design.md §3.1.
    static var shSurface: UIColor {
        UIColor { $0.userInterfaceStyle == .dark
            ? UIColor(FoundationTokens.Color.darkSurface)
            : UIColor(FoundationTokens.Color.lightSurface)
        }
    }

    // MARK: Text

    /// See `Color.shTextPrimary`. Design.md §3.1.
    static var shTextPrimary: UIColor {
        UIColor { $0.userInterfaceStyle == .dark
            ? UIColor(FoundationTokens.Color.darkTextPrimary)
            : UIColor(FoundationTokens.Color.lightTextPrimary)
        }
    }

    /// See `Color.shTextSecondary`. Design.md §3.1.
    static var shTextSecondary: UIColor {
        UIColor { $0.userInterfaceStyle == .dark
            ? UIColor(FoundationTokens.Color.darkTextSecondary)
            : UIColor(FoundationTokens.Color.lightTextSecondary)
        }
    }

    // MARK: Accent

    /// See `Color.shAccent`. Design.md §3.1.
    static var shAccent: UIColor {
        UIColor { $0.userInterfaceStyle == .dark
            ? UIColor(FoundationTokens.Color.darkAccentDefault)
            : UIColor(FoundationTokens.Color.lightAccentDefault)
        }
    }

    /// See `Color.shAccentMuted`. Design.md §3.1.
    static var shAccentMuted: UIColor {
        UIColor { $0.userInterfaceStyle == .dark
            ? UIColor(FoundationTokens.Color.darkAccentMuted)
            : UIColor(FoundationTokens.Color.lightAccentMuted)
        }
    }
}
