// CapturePreviewView.swift — App/Views/Capture
// Copyright 2026 sunghun.ahn — Still Hours
// Sprint 1.1 — CaptureSheet shell + state machine + manual mode
// Created: 2026-05-21
//
// Localization keys used in this file:
//   "capture.preview.ready"  — VoiceOver announcement "Ready to save: <title>, <medium>"
//   "capture.preview.edit"   — Edit button label
//   "capture.preview.save"   — Save button label
//   "capture.preview.memory" — first memory section header
//   "capture.preview.acquired_note" — placeholder first memory note

import SwiftUI
import SwiftData
import InventoryCore

// MARK: - CapturePreviewView

/// Displays the to-be-saved Item and its first Memory, allowing the user
/// to go back to edit or confirm and save.
@MainActor
struct CapturePreviewView: View {

    // MARK: Input

    let payload: CapturePayload
    let onEdit: () -> Void
    let onSave: () -> Void

    // MARK: Environment

    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    // MARK: Body

    var body: some View {
        VStack(spacing: 16) {
            previewCard
            firstMemoryRow
            actionButtons
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .accessibilityElement(children: .contain)
        .onAppear {
            let announcement = String(
                localized: "capture.preview.ready",
                defaultValue: "Ready to save: \(payload.title), \(mediumLabel)"
            )
            AccessibilityNotification.Announcement(announcement).post()
        }
    }

    // MARK: Preview card

    private var previewCard: some View {
        HStack(alignment: .top, spacing: 12) {
            coverThumbnail
            VStack(alignment: .leading, spacing: 4) {
                Text(payload.title.isEmpty ? "—" : payload.title)
                    .font(.headline)
                    .foregroundStyle(.primary)
                    .lineLimit(2)

                if let creator = payload.creator, !creator.isEmpty {
                    Text(creator)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .lineLimit(1)
                }

                HStack(spacing: 4) {
                    Image(systemName: mediumSymbol)
                        .imageScale(.small)
                    Text(mediumLabel)
                        .font(.caption)
                }
                .foregroundStyle(SemanticTokens.accent.default)
            }
            Spacer(minLength: 0)
        }
        .padding(ComponentTokens.ItemCard.padding)
        .background(.clear)
        .glassEffect(.regular, in: RoundedRectangle(cornerRadius: ComponentTokens.ItemCard.radius))
    }

    // MARK: Cover thumbnail

    @ViewBuilder
    private var coverThumbnail: some View {
        Group {
            if let data = payload.coverImageData, let uiImage = UIImage(data: data) {
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFill()
            } else {
                ZStack {
                    SemanticTokens.accent.muted
                    Image(systemName: mediumSymbol)
                        .foregroundStyle(SemanticTokens.accent.default)
                }
            }
        }
        .frame(width: 56, height: 74)  // 3:4 ratio ~ ComponentTokens.ItemCard.aspectRatio
        .clipShape(RoundedRectangle(cornerRadius: 6))
    }

    // MARK: First memory row

    private var firstMemoryRow: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(
                String(localized: "capture.preview.memory", defaultValue: "First Memory")
            )
            .font(.caption)
            .foregroundStyle(.secondary)
            .textCase(.uppercase)

            HStack(spacing: ComponentTokens.MemoryRow.iconTextGap) {
                Image(systemName: SemanticTokens.memory.kind.icon.acquired)
                    .resizable()
                    .frame(
                        width: ComponentTokens.MemoryRow.iconSize,
                        height: ComponentTokens.MemoryRow.iconSize
                    )
                    .foregroundStyle(SemanticTokens.accent.default)
                Text(
                    String(
                        localized: "capture.preview.acquired_note",
                        defaultValue: "Acquired — just now"
                    )
                )
                .font(.subheadline)
                .foregroundStyle(.secondary)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal, 4)
    }

    // MARK: Action buttons

    private var actionButtons: some View {
        HStack(spacing: 12) {
            Button(String(localized: "capture.preview.edit", defaultValue: "Edit")) {
                onEdit()
            }
            .buttonStyle(.glass)
            .frame(maxWidth: .infinity)
            .accessibilityLabel(String(localized: "capture.preview.edit", defaultValue: "Edit"))
            .accessibilityHint("Returns to the entry form.")

            Button(String(localized: "capture.preview.save", defaultValue: "Save")) {
                onSave()
            }
            .buttonStyle(.glassProminent)
            .frame(maxWidth: .infinity)
            .accessibilityLabel(String(localized: "capture.preview.save", defaultValue: "Save"))
            .accessibilityHint("Adds item to your collection.")
        }
    }

    // MARK: Helpers

    private var mediumSymbol: String {
        switch payload.medium {
        case .book:   return SemanticTokens.mediumIcon.book
        case .music:  return SemanticTokens.mediumIcon.music
        case .movie:  return SemanticTokens.mediumIcon.movie
        case .object: return SemanticTokens.mediumIcon.object
        }
    }

    private var mediumLabel: String {
        switch payload.medium {
        case .book:   return String(localized: "medium.book",   defaultValue: "Book")
        case .music:  return String(localized: "medium.music",  defaultValue: "Music")
        case .movie:  return String(localized: "medium.movie",  defaultValue: "Movie")
        case .object: return String(localized: "medium.object", defaultValue: "Object")
        }
    }
}
