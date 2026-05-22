// MemoryRowView.swift — App/Views/Timeline
// Copyright 2026 sunghun.ahn — Still Hours
// Sprint 1.5 — LibraryListView + ItemDetailView + MemoryTimelineView
// Created: 2026-05-21
// R12.3 verified for Cool Blue token cascade (2026-05-21).
//
// Single memory row. Design.md §5.2 MemoryRow spec.
// MemoryTimeline-Design.md §B.4, §C, §D.

import SwiftUI
import InventoryCore

// MARK: - MemoryRowView

/// Single row in the Memory Timeline.
///
/// Shows: kind icon · date · note preview · photo thumbnail if attached.
/// Design.md §5.2. MemoryTimeline-Design.md §B.4.
///
/// R14.2: Tapping the row calls ``onTap``; swipe-left shows a Delete action
/// that calls ``onDelete``.
@MainActor
struct MemoryRowView: View {

    // MARK: Input

    let memory: Memory
    var onTap: (() -> Void)?
    var onDelete: (() async -> Void)?

    // MARK: Scaled metric (accessibility ceiling per spec §H.2)

    @ScaledMetric(relativeTo: .body) private var iconSize: CGFloat = 16

    // MARK: Environment

    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    // MARK: Body

    var body: some View {
        Button {
            onTap?()
        } label: {
            rowContent
        }
        .buttonStyle(.plain)
        .swipeActions(edge: .trailing, allowsFullSwipe: false) {
            Button(role: .destructive) {
                Task { await onDelete?() }
            } label: {
                Label(
                    String(localized: "memory.row.action.delete", defaultValue: "Delete"),
                    systemImage: "trash"
                )
            }
            .accessibilityLabel(
                String(localized: "memory.row.action.delete", defaultValue: "Delete")
            )
        }
    }

    // MARK: Row Content

    private var rowContent: some View {
        HStack(alignment: .top, spacing: ComponentTokens.MemoryRow.iconTextGap) {
            kindIcon
            textArea
            if memory.photoCount > 0 {
                photoThumb
            }
        }
        .padding(.vertical, FoundationTokens.Space.sm)
        .accessibilityElement(children: .ignore)
        .accessibilityLabel(rowAccessibilityLabel)
        .accessibilityHint(
            String(localized: "memory.row.action.edit", defaultValue: "Edit")
        )
    }

    // MARK: Kind Icon

    private var kindIcon: some View {
        Image(systemName: memory.kind.symbolName)
            .font(.system(size: min(iconSize, 24)))
            .foregroundStyle(SemanticTokens.memory.kind.tint)
            .frame(width: min(iconSize, 24), height: min(iconSize, 24))
            .accessibilityHidden(true)
    }

    // MARK: Text Area

    private var textArea: some View {
        VStack(alignment: .leading, spacing: FoundationTokens.Space.xs) {
            if !memory.note.isEmpty {
                Text(memory.note)
                    .font(.body)
                    .foregroundStyle(Color.shTextPrimary)
                    .lineLimit(2)
                    .dynamicTypeSize(.xSmall ... .accessibility3)
            }

            Text(formattedDate)
                .font(.caption)
                .foregroundStyle(Color.shTextSecondary)
                .dynamicTypeSize(.xSmall ... .accessibility2)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    // MARK: Photo Thumbnail

    private var photoThumb: some View {
        let size = ComponentTokens.MemoryRow.photoThumbSize / 2  // 48pt as spec §B.6 says 48pt for single
        return SemanticTokens.card.elevated
            .frame(width: size, height: size)
            .clipShape(RoundedRectangle(cornerRadius: FoundationTokens.Radius.sm))
            .accessibilityLabel("Photo attachment, \(memory.photoCount) photo\(memory.photoCount == 1 ? "" : "s")")
    }

    // MARK: Helpers

    private var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return formatter.string(from: memory.date)
    }

    private var rowAccessibilityLabel: String {
        let kindLabel = memory.kind.accessibilityLabel
        let date = formattedDate
        let notePart = memory.note.isEmpty
            ? ""
            : ". " + String(memory.note.prefix(50))
        return "\(kindLabel) on \(date)\(notePart)"
    }
}

// MARK: - MemoryKind helpers

extension MemoryKind {
    /// SF Symbol name for this kind. Matches SemanticTokens.memory.kind.icon.
    var symbolName: String {
        switch self {
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

    /// VoiceOver-readable label. MemoryTimeline-Design.md §H.1.
    var accessibilityLabel: String {
        switch self {
        case .acquired:  return "Acquired"
        case .read:      return "Read"
        case .listened:  return "Listened"
        case .watched:   return "Watched"
        case .lent:      return "Lent"
        case .received:  return "Received"
        case .gifted:    return "Gifted"
        case .annotated: return "Annotated"
        }
    }
}
