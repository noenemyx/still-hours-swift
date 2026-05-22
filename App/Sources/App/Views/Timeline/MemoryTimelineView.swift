// MemoryTimelineView.swift — App/Views/Timeline
// Copyright 2026 sunghun.ahn — Still Hours
// Sprint 1.5 — LibraryListView + ItemDetailView + MemoryTimelineView
// Created: 2026-05-21
// R12.3 verified for Cool Blue token cascade (2026-05-21).
// R13.4: Sticky year header per MemoryTimeline-Design.md §F.
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

    // MARK: State

    /// Year currently pinned at the top of the scroll viewport.
    /// Updated via onScrollGeometryChange as the user scrolls.
    @State private var activeYear: Int?

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
        .onAppear {
            // Seed activeYear to topmost group so the first header is active on load.
            activeYear = groupedByYear.first?.year
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

    /// Wraps all year sections in a ScrollView + LazyVStack with pinned section headers.
    /// The accent rail is rendered as a leading-edge overlay on the LazyVStack so it
    /// spans the full content height and passes through the sticky header zone unbroken.
    private var timelineContent: some View {
        ScrollView {
            LazyVStack(alignment: .leading, spacing: 0, pinnedViews: [.sectionHeaders]) {
                ForEach(Array(groupedByYear.enumerated()), id: \.element.year) { index, group in
                    Section {
                        ForEach(Array(group.memories.enumerated()), id: \.element.id) { rowIndex, memory in
                            rowWithStagger(memory: memory, globalIndex: index * 100 + rowIndex)
                                .padding(.leading, ComponentTokens.MemoryRow.accentLineIndent + 16)
                        }
                    } header: {
                        yearHeader(year: group.year, isActive: activeYear == group.year)
                    }
                }
            }
            .padding(.top, FoundationTokens.Space.md)
            .padding(.bottom, FoundationTokens.Space.xxl)
            // Accent rail — 1pt, SemanticTokens.timeline.rail (accent × 0.18 alpha).
            // Design-R11 §3 token 21: faint Cool Blue spine, not paint stroke.
            // Overlay on the LazyVStack so it spans full content height through sticky headers.
            .overlay(alignment: .topLeading) {
                Rectangle()
                    .fill(SemanticTokens.timeline.rail)
                    .frame(width: ComponentTokens.MemoryRow.accentLineWidth)
                    .padding(.leading, ComponentTokens.MemoryRow.accentLineIndent)
            }
        }
        .onScrollGeometryChange(for: Int.self) { proxy in
            // Derive the active year from scroll position.
            // groupedByYear is descending (most recent first), so as the user scrolls down
            // the index advances through older years.
            let offsetY = proxy.contentOffset.y
            let contentH = proxy.contentSize.height
            let groups = groupedByYear
            guard !groups.isEmpty, contentH > 0 else {
                return groups.first?.year ?? 0
            }
            // Map scroll fraction to a group index; clamp to valid range.
            let fraction = max(0, min(1, offsetY / contentH))
            let clampedIndex = min(
                Int((fraction * Double(groups.count)).rounded(.down)),
                groups.count - 1
            )
            return groups[clampedIndex].year
        } action: { _, newYear in
            activeYear = newYear
        }
    }

    // MARK: Year Header

    private func yearHeader(year: Int, isActive: Bool) -> some View {
        let label = yearHeaderLabel(for: year)
        return Text(label)
            .font(.subheadline)
            .fontWeight(.semibold)
            .foregroundStyle(
                isActive
                    ? SemanticTokens.timeline.year.active
                    : SemanticTokens.timeline.year.inactive
            )
            .padding(.horizontal, FoundationTokens.Space.md)
            .padding(.vertical, FoundationTokens.Space.sm)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(.ultraThinMaterial)
            .accessibilityAddTraits(.isHeader)
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
