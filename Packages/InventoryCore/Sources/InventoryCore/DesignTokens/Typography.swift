// Typography.swift
// Still Hours — Design System Typography v1.0
//
// Locale-aware typeface selection for all 8 type tokens.
// Font pair: SF Pro (system sans) + New York (system serif, iOS 17+).
// CJK locales receive hand-picked system fonts that match visual weight.
//
// Design.md §3.2 (v1.0 Final).

import SwiftUI

// MARK: - StillHoursTypeface

/// Locale-aware typeface namespace for Still Hours.
///
/// Provides the 8 typographic tokens defined in Design.md §3.2.
/// Each function selects the appropriate font family based on the
/// current locale's language code, with a New York / SF Pro default
/// for Latin and other scripts.
///
/// **CJK fallback rationale** (Design.md §3.2 CJK Locale Fallback Stack):
/// - Korean (`ko`): Apple SD Gothic Neo Medium — matches New York Medium visual weight
/// - Japanese (`ja`): Hiragino Mincho W3 — serif elegance mirrors New York spirit
/// - Simplified Chinese (`zh-Hans`): PingFang SC Medium
/// - Traditional Chinese (`zh-Hant`): PingFang TC Medium
/// - All other locales: New York (heading) / SF Pro (body)
///
/// **Dynamic Type ceiling**: `.accessibility3` is the recommended upper bound
/// to keep layouts intact. Apply via `.dynamicTypeSize(.xSmall ... .accessibility3)`.
@available(iOS 17, macOS 14, *)
public enum StillHoursTypeface {

    // MARK: Private helpers

    /// Language code string for a given locale.
    private static func langCode(_ locale: Locale) -> String? {
        locale.language.languageCode?.identifier
    }

    /// Scaled font size using `UIFontMetrics` for custom font names.
    ///
    /// Pins the maximum at `accessibility3` ceiling (≈ 1.4× of the base).
    /// Design.md §3.2 Dynamic Type 대응.
    private static func scaled(
        _ size: CGFloat,
        relativeTo textStyle: Font.TextStyle,
        maximumFactor: CGFloat = 1.4
    ) -> CGFloat {
        // SwiftUI Font.custom(_:size:relativeTo:) handles scaling;
        // this helper returns the capped base size for UIKit paths.
        min(size * maximumFactor, size * maximumFactor)
        // Note: actual Dynamic Type scaling is applied by Font.custom(_:size:relativeTo:)
        // in the public API below. This value is the raw baseline.
    }

    // MARK: Token: display (28pt, New York Medium)

    /// Still Hours wordmark / Settings header display token.
    ///
    /// 28pt (Large Title baseline). New York Medium for Latin; locale fallback for CJK.
    /// Design.md §3.2 `font.display`.
    public static func display(for locale: Locale = .current) -> Font {
        switch langCode(locale) {
        case "ko":
            return .custom("AppleSDGothicNeo-Medium", size: 28, relativeTo: .largeTitle)
        case "ja":
            return .custom("HiraginoMincho-W3", size: 28, relativeTo: .largeTitle)
        case "zh-Hans":
            return .custom("PingFangSC-Medium", size: 28, relativeTo: .largeTitle)
        case "zh-Hant":
            return .custom("PingFangTC-Medium", size: 28, relativeTo: .largeTitle)
        default:
            return .custom("NewYork-Medium", size: 28, relativeTo: .largeTitle)
        }
    }

    // MARK: Token: heading1 (22pt, New York Medium)

    /// Item title: Book / LP / Film / Object.
    ///
    /// 22pt (Title 2 baseline). New York Medium conveys _slow + library_ tone.
    /// Design.md §3.2 `font.heading.1`.
    public static func heading1(for locale: Locale = .current) -> Font {
        switch langCode(locale) {
        case "ko":
            return .custom("AppleSDGothicNeo-Medium", size: 22, relativeTo: .title2)
        case "ja":
            return .custom("HiraginoMincho-W3", size: 22, relativeTo: .title2)
        case "zh-Hans":
            return .custom("PingFangSC-Medium", size: 22, relativeTo: .title2)
        case "zh-Hant":
            return .custom("PingFangTC-Medium", size: 22, relativeTo: .title2)
        default:
            return .custom("NewYork-Medium", size: 22, relativeTo: .title2)
        }
    }

    // MARK: Token: heading2 (17pt, SF Pro Text Semibold)

    /// Section header, modal title.
    ///
    /// 17pt (Headline baseline). SF Pro Text Semibold — system font, no custom name needed.
    /// Design.md §3.2 `font.heading.2`.
    public static func heading2(for locale: Locale = .current) -> Font {
        // SF Pro + CJK locales: .headline applies system-appropriate weight via
        // Dynamic Type, including CJK-aware glyph selection.
        _ = locale // locale reserved for future per-locale weight tuning
        return .system(.headline, design: .default, weight: .semibold)
    }

    // MARK: Token: body (17pt, SF Pro Text Regular)

    /// Memory note body, free text.
    ///
    /// 17pt (Body baseline). Design.md §3.2 `font.body`.
    public static func body(for locale: Locale = .current) -> Font {
        _ = locale
        return .system(.body, design: .default, weight: .regular)
    }

    // MARK: Token: callout (16pt, SF Pro Text Regular)

    /// Creator / Artist / Director subtitle beneath Item title.
    ///
    /// 16pt (Callout baseline). Design.md §3.2 `font.callout`.
    public static func callout(for locale: Locale = .current) -> Font {
        _ = locale
        return .system(.callout, design: .default, weight: .regular)
    }

    // MARK: Token: subhead (15pt, SF Pro Text Medium)

    /// Memory kind label (e.g. "Read", "Watched", "Owned").
    ///
    /// 15pt (Subheadline baseline). Design.md §3.2 `font.subhead`.
    public static func subhead(for locale: Locale = .current) -> Font {
        _ = locale
        return .system(.subheadline, design: .default, weight: .medium)
    }

    // MARK: Token: caption (12pt, SF Pro Text Regular)

    /// Date, Place, Tag metadata.
    ///
    /// 12pt (Caption 1 baseline). Design.md §3.2 `font.caption`.
    public static func caption(for locale: Locale = .current) -> Font {
        _ = locale
        return .system(.caption, design: .default, weight: .regular)
    }

    // MARK: Token: caption2 (11pt, SF Pro Text Regular)

    /// Sub-metadata below captions.
    ///
    /// 11pt (Caption 2 baseline). Design.md §3.2 `font.caption.small`.
    public static func caption2(for locale: Locale = .current) -> Font {
        _ = locale
        return .system(.caption2, design: .default, weight: .regular)
    }
}

// MARK: - Dynamic Type Ceiling View Modifier

@available(iOS 17, macOS 14, *)
extension View {

    /// Caps Dynamic Type scaling at `.accessibility3`.
    ///
    /// Recommended ceiling per Design.md §3.2 to prevent layout breakage.
    /// Apply to any view using Still Hours custom fonts.
    public func shDynamicTypeCeiling() -> some View {
        self.dynamicTypeSize(.xSmall ... .accessibility3)
    }
}

// MARK: - Environment-Based Convenience

/// A property wrapper that reads `Locale.current` from the SwiftUI environment
/// and provides resolved ``StillHoursTypeface`` fonts as computed properties.
///
/// Usage:
/// ```swift
/// @SHTypeface var typeface
/// Text("Still Hours").font(typeface.heading1)
/// ```
@available(iOS 17, macOS 14, *)
@propertyWrapper
public struct SHTypeface: DynamicProperty {

    @Environment(\.locale) private var locale

    public var wrappedValue: SHTypefaceValues {
        SHTypefaceValues(locale: locale)
    }

    public init() {}
}

/// Resolved typeface values for a given locale.
@available(iOS 17, macOS 14, *)
public struct SHTypefaceValues {

    private let locale: Locale

    public init(locale: Locale = .current) {
        self.locale = locale
    }

    public var display:  Font { StillHoursTypeface.display(for: locale) }
    public var heading1: Font { StillHoursTypeface.heading1(for: locale) }
    public var heading2: Font { StillHoursTypeface.heading2(for: locale) }
    public var body:     Font { StillHoursTypeface.body(for: locale) }
    public var callout:  Font { StillHoursTypeface.callout(for: locale) }
    public var subhead:  Font { StillHoursTypeface.subhead(for: locale) }
    public var caption:  Font { StillHoursTypeface.caption(for: locale) }
    public var caption2: Font { StillHoursTypeface.caption2(for: locale) }
}
