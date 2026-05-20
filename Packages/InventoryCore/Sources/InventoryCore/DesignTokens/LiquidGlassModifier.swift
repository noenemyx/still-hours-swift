// LiquidGlassModifier.swift — InventoryCore/DesignTokens
// Copyright 2026 sunghun.ahn — Still Hours
// R11.4 — Liquid Glass uniform tinting. Design-R11 §8.
// Created: 2026-05-21

import SwiftUI

// MARK: - .shGlass() View Modifier

/// Applies the Still Hours brand Liquid Glass material —
/// `.glassEffect(.regular.tint(Color.shAccentSubtle))` — with a
/// Reduce-Transparency accessibility fallback to a solid
/// `Color.shAccentMuted` fill (so the chrome retains its brand
/// hue signature even when the material is disabled).
///
/// ## Usage
///
/// ```swift
/// // Default (no explicit shape — modifier uses Rectangle which glassEffect defaults)
/// someView.shGlass()
///
/// // With an explicit shape
/// someView.shGlass(in: RoundedRectangle(cornerRadius: 16))
/// someView.shGlass(in: Capsule())
/// ```
///
/// ## Design rationale (Design-R11 §8)
///
/// Every glass plate in the Still Hours chrome carries the same faint
/// cool wash (`accent.subtle`). Uniform tinting makes the translucent
/// layer read as a single brand material throughout the app rather
/// than per-view styling choices. The sweet spot is `accent.subtle`
/// at rest value: enough hue presence that the material reads as part
/// of the Still Hours system, light enough that content seen through
/// it does not shift in apparent color.
///
/// When Reduce Transparency is enabled the glass plate falls back to
/// a solid `accent.muted` fill. The view loses the material effect
/// but keeps the brand's faint hue signature.
@available(iOS 26, *)
public extension View {

    /// Applies the Still Hours brand Liquid Glass tint
    /// (`.glassEffect(.regular.tint(Color.shAccentSubtle))`)
    /// with a solid `Color.shAccentMuted` Reduce-Transparency fallback.
    ///
    /// Design-R11 §8 — uniform tinting across all chrome surfaces.
    ///
    /// - Parameter shape: The clipping shape for the glass plate.
    ///   Defaults to a zero-radius `RoundedRectangle` (effectively a rectangle),
    ///   matching the behavior of calling `.glassEffect()` without a shape.
    func shGlass(in shape: some Shape = RoundedRectangle(cornerRadius: 0)) -> some View {
        modifier(SHGlassModifier(shape: AnyShape(shape)))
    }
}

// MARK: - SHGlassModifier (private implementation)

@available(iOS 26, *)
private struct SHGlassModifier: ViewModifier {

    let shape: AnyShape

    @Environment(\.accessibilityReduceTransparency) private var reduceTransparency

    func body(content: Content) -> some View {
        if reduceTransparency {
            content.background(Color.shAccentMuted, in: shape)
        } else {
            content.glassEffect(.regular.tint(Color.shAccentSubtle), in: shape)
        }
    }
}
