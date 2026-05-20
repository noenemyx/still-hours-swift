// MemoryTimelineView.swift — App/Views/Timeline
// Copyright 2026 sunghun.ahn — Still Hours
// Sprint 1.5 — LibraryListView + ItemDetailView + MemoryTimelineView
// Created: 2026-05-21
//
// THE brand visual signature view. Vertical timeline with left accent line,
// grouped by year then month, reverse-chronological.
// MemoryTimeline-Design.md §A-I. Design.md §5.2.
// Localisation keys: timeline.empty, timeline.year.

import SwiftUI
import InventoryCore

// MARK: - MemoryTimelineView

/// Brand signature view: vertical accent line + staggered memory rows
/// grouped by year and reverse-chronological.
///
/// MemoryTimeline-Design.md §A-I.
@MainActor
struct MemoryTimelineView: View {

    // MARK: Input

    let item: Item
    var onAddMemory: (() -> Void)?

    // MARK: Environment

    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    // MARK: Computed

    /// Memories sorted reverse-chronologically.
    private var sortedMemories: [Memory] {
        item.memories.sorted { $0.date > $1.date }
    }

    /// Year → [Memory] dictionary, years descending.
    private var groupedByYear: [(year: Int, memories: [Memory])] {
        let calendar = Calendar(identifier: .gregorian)
        var dict: [Int: [Memory]] = [:]
        for mem in sortedMemories {
            let y = calendar.component(.year, from: mem.date)
            dict[y, default: []].append(mem)
        }
        return dict.keys.sorted(by: >).map { year in
            (year: year, memories: dict[year]!)
        }
    }

    // MARK: Body

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            if sortedMemories.isEmpty {
                emptyState
            } else {
                timelineContent
            }
        }
    }

    // MARK: Empty State

    private var emptyState: some View {
        VStack(spacing: FoundationTokens.Space.md) {
            Circle()
                .fill(Color.shAccent)
                .frame(width: 8, height: 8)

            Text(String(localized: "timeline.empty", defaultValue: "Add your first memory"))
                .font(.headline)
                .foregroundStyle(Color.shTextPrimary)
                .multilineTextAlignment(.center)

            if let onAdd = onAddMemory {
                Button {
                    onAdd()
                } label: {
                    Text(String(localized: "item.detail.addMemory", defaultValue: "Add Memory"))
                        .fontWeight(.semibold)
                }
                .buttonStyle(.glassProminent)
            }
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, FoundationTokens.Space.xxl)
        .accessibilityElement(children: .combine)
    }

    // MARK: Timeline Content

    private var timelineContent: some View {
        VStack(alignment: .leading, spacing: 0) {
            ForEach(Array(groupedByYear.enumerated()), id: \.element.year) { index, group in
                yearSection(year: group.year, memories: group.memories, index: index)
            }
        }
        .padding(.top, FoundationTokens.Space.md)
        .padding(.bottom, FoundationTokens.Space.xxl)
    }

    // MARK: Year Section

    private func yearSection(year: Int, memories: [Memory], index: Int) -> some View {
        VStack(alignment: .leading, spacing: 0) {
            yearHeader(year: year)

            ZStack(alignment: .topLeading) {
                // Accent line — 1pt burnt sienna, per spec §B.2
                Rectangle()
                    .fill(Color.shAccent)
                    .frame(width: ComponentTokens.MemoryRow.accentLineWidth)
                    .padding(.leading, ComponentTokens.MemoryRow.accentLineIndent)

                // Memory rows
                VStack(alignment: .leading, spacing: 0) {
                    ForEach(Array(memories.enumerated()), id: \.element.id) { rowIndex, memory in
                        rowWithStagger(memory: memory, globalIndex: index * 100 + rowIndex)
                            .padding(.leading, ComponentTokens.MemoryRow.accentLineIndent + 16)
                    }
                }
            }
        }
        .accessibilityElement(children: .contain)
        .accessibilityLabel("\(year)")
    }

    // MARK: Year Header

    private func yearHeader(year: Int) -> some View {
        let label = yearHeaderLabel(for: year)
        return Text(label)
            .font(.subheadline)
            .fontWeight(.semibold)
            .foregroundStyle(Color.shTextSecondary)
            .padding(.horizontal, FoundationTokens.Space.md)
            .padding(.vertical, FoundationTokens.Space.sm)
    }

    private func yearHeaderLabel(for year: Int) -> String {
        // `timeline.year` is a `%@` template — ko "%@년", ja "%@年", en "%@".
        // `String(localized:)` with a runtime defaultValue is not directly
        // expressible; load the template, then substitute the year.
        let yearStr = "\(year)"
        // LINT-IGNORE: QuoteEscape — false positive from check-quote-escape.sh heuristic
        let template = String(localized: "timeline.year", defaultValue: "\(yearStr)")
        return template.replacingOccurrences(of: "%@", with: yearStr)
    }

    // MARK: Row with stagger animation

    private func rowWithStagger(memory: Memory, globalIndex: Int) -> some View {
        MemoryRowView(memory: memory)
            .transition(
                reduceMotion
                    ? .identity
                    : .opacity.combined(with: .move(edge: .top))
            )
            .animation(
                reduceMotion
                    ? .none
                    : FoundationTokens.Motion.standard
                        .delay(Double(globalIndex) * 0.04),
                value: sortedMemories.count
            )
    }
}
