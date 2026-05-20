// Motion+SemanticPresets.swift
// Still Hours — Motion Semantic Presets v1.0
//
// Named animation presets over Foundation motion primitives.
// Maps directly to Design.md §3.6 (Motion) via semantic intent names.
//
// Usage: reference via `MotionPresets.tap`, `MotionPresets.sheet`, etc.
// Foundation primitives live in `FoundationTokens.Motion`.
//
// - Note: Design.md §3.6 (2026-05-20 final).
// - Important: Always respect `@Environment(\.accessibilityReduceMotion)`.
//   Use `MotionPresets.resolved(_:reduceMotion:)` at the call site.

import SwiftUI

// MARK: - MotionPresets

/// Semantic animation presets for Still Hours interactions.
///
/// Each preset maps a UX context to the appropriate ``FoundationTokens/Motion`` primitive.
/// This layer gives intent-readable names that survive timing adjustments without
/// updating every call site.
///
/// **Reduced Motion**: when `accessibilityReduceMotion` is active, pass the
/// environment value to ``resolved(_:isCrossFade:reduceMotion:)`` to get an
/// appropriate fallback. Do **not** hard-code conditional checks at call sites.
///
/// ```swift
/// @Environment(\.accessibilityReduceMotion) var reduceMotion
///
/// withAnimation(MotionPresets.resolved(.sheet, reduceMotion: reduceMotion)) {
///     isSheetVisible = true
/// }
/// ```
///
/// - Important: Design.md §3.6 defines the authoritative timing values.
///   Update ``FoundationTokens/Motion``, not this file, when timing changes.
@available(iOS 17, macOS 14, *)
public enum MotionPresets {

    // MARK: - Semantic Presets

    /// Tap / button press feedback.
    ///
    /// = ``FoundationTokens/Motion/quick`` (200ms easeOut).
    ///
    /// Snappy response; avoids feeling sluggish on repeated interactions.
    ///
    /// Design.md §3.6 `motion.tap`.
    public static let tap: Animation = FoundationTokens.Motion.quick

    /// Sheet or modal presentation / dismissal.
    ///
    /// = ``FoundationTokens/Motion/standard`` (300ms easeInOut).
    ///
    /// Balanced enter/exit — not too quick to feel abrupt,
    /// not too slow to feel ponderous.
    ///
    /// Design.md §3.6 `motion.sheet`.
    public static let sheet: Animation = FoundationTokens.Motion.standard

    /// Onboarding step transition.
    ///
    /// = ``FoundationTokens/Motion/deliberate`` (500ms easeInOut).
    ///
    /// Intentional pacing; each step lands with weight to signal importance.
    ///
    /// Design.md §3.6 `motion.onboarding`.
    public static let onboarding: Animation = FoundationTokens.Motion.deliberate

    /// Memory entry auto-add animation.
    ///
    /// = ``FoundationTokens/Motion/slow`` (800ms easeInOut).
    ///
    /// Rare, ceremonial — used only when a memory is committed to the archive.
    /// The slowness signals permanence and care.
    ///
    /// Design.md §3.6 `motion.memoryAdd`.
    public static let memoryAdd: Animation = FoundationTokens.Motion.slow

    /// Accessibility fallback — instant, zero-duration.
    ///
    /// Use when `accessibilityReduceMotion` is active and the transition
    /// is **not** a cross-fade. Cross-fades may retain `tap` timing
    /// (see ``resolved(_:isCrossFade:reduceMotion:)``).
    ///
    /// Design.md §3.6 `motion.reducedFallback`.
    public static let reducedFallback: Animation = .linear(duration: 0)

    // MARK: - Duration Constants (UIKit / CAAnimation)

    /// Raw duration values for UIKit or CAAnimation contexts.
    ///
    /// Mirrors ``FoundationTokens/Motion/Duration`` under intent-named keys.
    ///
    /// Design.md §3.6.
    public enum duration {

        /// 0.2s — tap response. Design.md §3.6 `motion.tap`.
        public static let tap: Double = FoundationTokens.Motion.Duration.quick

        /// 0.3s — sheet presentation. Design.md §3.6 `motion.sheet`.
        public static let sheet: Double = FoundationTokens.Motion.Duration.standard

        /// 0.5s — onboarding step. Design.md §3.6 `motion.onboarding`.
        public static let onboarding: Double = FoundationTokens.Motion.Duration.deliberate

        /// 0.8s — memory add ceremony. Design.md §3.6 `motion.memoryAdd`.
        public static let memoryAdd: Double = FoundationTokens.Motion.Duration.slow

        /// 0.0s — reduced motion fallback. Design.md §3.6 `motion.reducedFallback`.
        public static let reducedFallback: Double = 0
    }

    // MARK: - Accessibility-Aware Resolution

    /// Returns the appropriate animation respecting the current accessibility state.
    ///
    /// Delegates to ``FoundationTokens/Motion/resolved(_:isCrossFade:reduceMotion:)``.
    ///
    /// - Parameters:
    ///   - preset: One of the named presets (`tap`, `sheet`, `onboarding`, etc.)
    ///   - isCrossFade: Pass `true` for opacity-only transitions to preserve a
    ///     short cross-fade (`tap` timing) instead of going instant.
    ///   - reduceMotion: Pass `@Environment(\.accessibilityReduceMotion)` value.
    ///
    /// - Returns: `preset` when reduce-motion is off; `reducedFallback` (or `tap`
    ///   for cross-fades) when reduce-motion is on.
    ///
    /// Design.md §3.6. ``FoundationTokens/Motion/resolved(_:isCrossFade:reduceMotion:)``.
    public static func resolved(
        _ preset: Animation,
        isCrossFade: Bool = false,
        reduceMotion: Bool
    ) -> Animation {
        FoundationTokens.Motion.resolved(
            preset,
            isCrossFade: isCrossFade,
            reduceMotion: reduceMotion
        )
    }
}

// MARK: - View Extension

@available(iOS 17, macOS 14, *)
public extension View {

    /// Wraps `withAnimation` using a semantic motion preset, automatically
    /// respecting the `accessibilityReduceMotion` environment.
    ///
    /// Usage:
    /// ```swift
    /// @Environment(\.accessibilityReduceMotion) var reduceMotion
    ///
    /// button.onTapGesture {
    ///     withMotion(.tap, reduceMotion: reduceMotion) {
    ///         isSelected.toggle()
    ///     }
    /// }
    /// ```
    ///
    /// - Parameters:
    ///   - preset: Named motion preset from ``MotionPresets``.
    ///   - isCrossFade: `true` for opacity-only transitions.
    ///   - reduceMotion: Current `accessibilityReduceMotion` value.
    ///   - body: State mutation closure.
    func withMotion(
        _ preset: Animation,
        isCrossFade: Bool = false,
        reduceMotion: Bool,
        _ body: () -> Void
    ) -> some View {
        withAnimation(
            MotionPresets.resolved(preset, isCrossFade: isCrossFade, reduceMotion: reduceMotion),
            body
        )
        return self
    }
}
