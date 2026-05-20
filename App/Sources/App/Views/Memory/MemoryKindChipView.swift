// MemoryKindChipView.swift — App/Views/Memory
// Copyright 2026 sunghun.ahn — Still Hours
// Sprint 1.6 — AddMemoryView (Memory to existing Item)
// Created: 2026-05-21
//
// Reusable chip view for MemoryKind picker in AddMemoryView.
// Displays SF Symbol icon + localized label. Selected state uses accent ring.

import SwiftUI
import InventoryCore

// MARK: - MemoryKindChipView

/// A 64×72 pt selection chip for a single ``MemoryKind``.
///
/// Selected chip shows a 2pt `Color.shAccent` ring and `Color.shAccentMuted` background.
/// Unselected chip shows a 1pt muted ring and `Color.shSurface` background.
@MainActor
struct MemoryKindChipView: View {

    // MARK: Input

    let kind: MemoryKind
    let isSelected: Bool
    let onTap: () -> Void

    // MARK: Environment

    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    // MARK: Body

    var body: some View {
        Button(action: onTap) {
            VStack(spacing: FoundationTokens.Space.xs) {
                Image(systemName: iconName)
                    .font(.system(size: 28))
                    .foregroundStyle(isSelected ? Color.shAccent : Color.shTextSecondary)

                Text(kindLabel)
                    .font(.system(size: 10, weight: .medium))
                    .foregroundStyle(isSelected ? Color.shAccent : Color.shTextSecondary)
                    .lineLimit(1)
                    .minimumScaleFactor(0.8)
            }
            .frame(width: 64, height: 72)
            .background(isSelected ? Color.shAccentMuted : Color.shSurface)
            .clipShape(RoundedRectangle(cornerRadius: FoundationTokens.Radius.sm))
            .overlay(
                RoundedRectangle(cornerRadius: FoundationTokens.Radius.sm)
                    .strokeBorder(
                        isSelected
                            ? Color.shAccent
                            : Color.shTextSecondary.opacity(0.3),
                        lineWidth: isSelected ? 2 : 1
                    )
            )
        }
        .buttonStyle(.plain)
        .animation(reduceMotion ? nil : .easeInOut(duration: 0.15), value: isSelected)
        .accessibilityLabel(kindLabel)
        .accessibilityValue(
            isSelected
                ? String(localized: "memory.add.chip.selected", defaultValue: "Selected")
                : String(localized: "memory.add.chip.unselected", defaultValue: "Not selected")
        )
        .accessibilityAddTraits(isSelected ? .isSelected : [])
    }

    // MARK: Helpers

    private var iconName: String {
        switch kind {
        case .acquired:  return SemanticTokens.memory.kind.icon.acquired
        case .read:      return SemanticTokens.memory.kind.icon.read
        case .listened:  return SemanticTokens.memory.kind.icon.listened
        case .watched:   return SemanticTokens.memory.kind.icon.watched
        case .lent:      return SemanticTokens.memory.kind.icon.lent
        case .received:  return SemanticTokens.memory.kind.icon.received
        case .gifted:    return SemanticTokens.memory.kind.icon.gifted
        case .annotated: return SemanticTokens.memory.kind.icon.annotated
        }
    }

    private var kindLabel: String {
        switch kind {
        case .acquired:  return String(localized: "memory.kind.acquired",  defaultValue: "Acquired")
        case .read:      return String(localized: "memory.kind.read",      defaultValue: "Read")
        case .listened:  return String(localized: "memory.kind.listened",  defaultValue: "Listened")
        case .watched:   return String(localized: "memory.kind.watched",   defaultValue: "Watched")
        case .lent:      return String(localized: "memory.kind.lent",      defaultValue: "Lent")
        case .received:  return String(localized: "memory.kind.received",  defaultValue: "Received")
        case .gifted:    return String(localized: "memory.kind.gifted",    defaultValue: "Gifted")
        case .annotated: return String(localized: "memory.kind.annotated", defaultValue: "Annotated")
        }
    }
}
