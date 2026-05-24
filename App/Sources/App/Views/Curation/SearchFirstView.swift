// SearchFirstView.swift — App/Views/Curation
// Copyright 2026 sunghun.ahn — Own Your Curation
// R19 — Curation paradigm: search-first single entry replacing 4-mode picker
// Created: 2026-05-24
//
// Architecture:
// - Single search input (auto-focus, keyboard up)
// - Real-time multi-medium results (debounced 300ms)
// - Sectioned by medium (책 → 음반 → 영화 → 오브제 → 장소) fixed order
// - Cover-prominent cards with "채택하기" affordance
// - Empty state: graceful manual fallback link
//
// NOTE: Build #9a uses MockSearchProviders. Build #9b will inject Naver/KOBIS/
// TMDB/iTunes providers once API keys arrive. UI is identical.
//
// Localization keys:
//   "curation.search.placeholder"     — search input placeholder
//   "curation.search.helper"          — sub-label above input
//   "curation.search.adopt"           — adopt button label
//   "curation.search.empty"           — no results message
//   "curation.search.manualFallback"  — manual entry fallback link
//   "curation.section.book/music/movie/object/place" — section headers

import SwiftUI
import SwiftData
import InventoryCore

// MARK: - SearchFirstView

@MainActor
struct SearchFirstView: View {

    let service: UnifiedSearchService
    let onAdopt: (SearchResult) -> Void
    let onManualFallback: () -> Void

    // H1: service is injected from CurationRootView (@State) — not recreated per rebuild.
    init(service: UnifiedSearchService, onAdopt: @escaping (SearchResult) -> Void, onManualFallback: @escaping () -> Void) {
        self.service = service
        self.onAdopt = onAdopt
        self.onManualFallback = onManualFallback
    }

    @State private var query: String = ""
    @State private var results: [Medium: [SearchResult]] = [:]
    @State private var isSearching: Bool = false
    @State private var searchTask: Task<Void, Never>? = nil
    @FocusState private var inputFocused: Bool

    @Query(sort: \Item.createdAt, order: .reverse) private var recentItems: [Item]

    var body: some View {
        VStack(spacing: 0) {
            searchHeader
            Divider()
            resultsScrollView
        }
    }

    // MARK: Header (search input)

    private var searchHeader: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(spacing: 8) {
                Image(systemName: "magnifyingglass")
                    .foregroundStyle(.secondary)
                TextField(
                    String(localized: "curation.search.placeholder", defaultValue: "제목, 창작자, 바코드, URL"),
                    text: $query
                )
                .focused($inputFocused)
                .textInputAutocapitalization(.never)
                .autocorrectionDisabled(true)
                .submitLabel(.search)
                .onChange(of: query) { _, newValue in
                    scheduleSearch(query: newValue)
                }
                if !query.isEmpty {
                    Button {
                        query = ""
                        results = [:]
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundStyle(.secondary)
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 10)
            .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 10))
            .padding(.horizontal, 16)
        }
        .padding(.top, 12)
        .padding(.bottom, 12)
    }

    // MARK: Results

    @ViewBuilder
    private var resultsScrollView: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                if isSearching && results.isEmpty {
                    HStack {
                        ProgressView().controlSize(.small)
                        Text(String(localized: "curation.searching", defaultValue: "검색 중…")).font(.subheadline).foregroundStyle(.secondary)
                    }
                    .padding(.horizontal, 16)
                    .padding(.top, 20)
                }

                if !isSearching && results.isEmpty && !query.isEmpty {
                    emptyState
                }

                // Query empty: show recently adopted or zero-state hint
                if query.isEmpty {
                    if recentItems.isEmpty {
                        zeroStateHint
                    } else {
                        recentlyAdoptedSection
                    }
                }

                ForEach(Medium.allCases, id: \.self) { medium in
                    if let items = results[medium], !items.isEmpty {
                        sectionFor(medium: medium, results: items)
                    }
                }

                if !query.isEmpty {
                    manualFallbackLink
                        .padding(.top, 12)
                }
            }
            .padding(.vertical, 16)
        }
    }

    // MARK: Recently Adopted

    private var recentlyAdoptedSection: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(String(localized: "curation.recent.header", defaultValue: "최근 채택"))
                .font(.subheadline.weight(.semibold))
                .foregroundStyle(.secondary)
                .padding(.horizontal, 16)
            ForEach(recentItems.prefix(5)) { item in
                RecentAdoptedRow(item: item)
                    .padding(.horizontal, 16)
            }
        }
    }

    private var zeroStateHint: some View {
        VStack(spacing: 10) {
            Image(systemName: "sparkle.magnifyingglass")
                .font(.system(size: 36))
                .foregroundStyle(.tertiary)
            Text(String(localized: "curation.zero.hint",
                        defaultValue: "제목, 창작자, 바코드로 검색해 보세요"))
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 32)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 40)
    }

    private func sectionFor(medium: Medium, results: [SearchResult]) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(sectionHeader(for: medium))
                .font(.subheadline.weight(.semibold))
                .foregroundStyle(.secondary)
                .padding(.horizontal, 16)
            ForEach(results.prefix(3)) { result in
                SearchResultCard(result: result, onAdopt: onAdopt)
                    .padding(.horizontal, 16)
            }
        }
    }

    private var emptyState: some View {
        VStack(spacing: 12) {
            Image(systemName: "magnifyingglass")
                .font(.system(size: 36))
                .foregroundStyle(.tertiary)
            Text(String(localized: "curation.search.empty",
                        defaultValue: "검색 결과가 없습니다. 철자나 다른 단어를 시도해보세요."))
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal, 32)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 40)
    }

    private var manualFallbackLink: some View {
        VStack(spacing: 6) {
            Text(String(localized: "curation.search.noMatch.divider", defaultValue: "─  찾는 것이 없으신가요?  ─"))
                .font(.caption)
                .foregroundStyle(.tertiary)
            Button {
                onManualFallback()
            } label: {
                Text(String(localized: "curation.search.manualFallback",
                            defaultValue: "직접 기록하기 →"))
                    .font(.subheadline)
            }
            .buttonStyle(.plain)
            .foregroundStyle(.tint)
        }
        .frame(maxWidth: .infinity)
        .padding(.bottom, 24)
    }

    // MARK: Section headers

    private func sectionHeader(for medium: Medium) -> String {
        switch medium {
        case .book:   return String(localized: "curation.section.book",   defaultValue: "책")
        case .music:  return String(localized: "curation.section.music",  defaultValue: "음반")
        case .movie:  return String(localized: "curation.section.movie",  defaultValue: "영화")
        case .object: return String(localized: "curation.section.object", defaultValue: "오브제")
        case .place:  return String(localized: "curation.section.place",  defaultValue: "장소")
        }
    }

    // MARK: Debounce + search

    private func scheduleSearch(query: String) {
        searchTask?.cancel()
        let trimmed = query.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else {
            results = [:]
            isSearching = false
            return
        }
        searchTask = Task {
            try? await Task.sleep(nanoseconds: 300_000_000)
            guard !Task.isCancelled else { return }
            await performSearch(query: trimmed)
        }
    }

    private func performSearch(query: String) async {
        // FIXME (axis ?): provider TaskGroup tasks inside UnifiedSearchService.search() are NOT
        // individually cancelled when the outer searchTask is cancelled; they run to completion
        // and only the result assignment is gated by Task.isCancelled. Acceptable for now
        // (results dropped, no UI flicker), but wastes provider bandwidth on rapid query changes.
        // Plan: pass a CancellationToken via async stream in Build #9b real-providers cycle.
        isSearching = true
        let buckets = await service.search(query: query)
        guard !Task.isCancelled else { return }
        results = buckets
        isSearching = false
    }
}

// MARK: - SearchResultCard

@MainActor
struct SearchResultCard: View {
    let result: SearchResult
    let onAdopt: (SearchResult) -> Void

    var body: some View {
        Button {
            onAdopt(result)
        } label: {
            HStack(spacing: 12) {
                coverPlaceholder
                VStack(alignment: .leading, spacing: 4) {
                    Text(result.title)
                        .font(.body.weight(.medium))
                        .multilineTextAlignment(.leading)
                        .lineLimit(2)
                    if let creator = result.creator {
                        Text(creator)
                            .font(.subheadline)
                            .foregroundStyle(.secondary)
                    }
                    HStack(spacing: 6) {
                        if let year = result.year {
                            Text("\(String(year))")
                                .font(.caption.monospacedDigit())
                                .foregroundStyle(.tertiary)
                        }
                        if let publisher = result.publisher {
                            Text("·")
                                .font(.caption)
                                .foregroundStyle(.tertiary)
                            Text(publisher)
                                .font(.caption)
                                .foregroundStyle(.tertiary)
                                .lineLimit(1)
                        }
                    }
                }
                Spacer()
                Image(systemName: "arrow.right.circle")
                    .font(.title3)
                    .foregroundStyle(.tint)
            }
            .padding(12)
            .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 10))
        }
        .buttonStyle(.plain)
    }

    private var coverPlaceholder: some View {
        let mediumIcon: String = {
            switch result.medium {
            case .book:   return SemanticTokens.mediumIcon.book
            case .music:  return SemanticTokens.mediumIcon.music
            case .movie:  return SemanticTokens.mediumIcon.movie
            case .object: return SemanticTokens.mediumIcon.object
            case .place:  return SemanticTokens.mediumIcon.place
            }
        }()
        return RoundedRectangle(cornerRadius: 6)
            .fill(Color.secondary.opacity(0.12))
            .frame(width: 56, height: 76)
            .overlay {
                Image(systemName: mediumIcon)
                    .foregroundStyle(.tint)
                    .imageScale(.large)
            }
    }
}

// MARK: - RecentAdoptedRow

@MainActor
struct RecentAdoptedRow: View {
    let item: Item

    var body: some View {
        HStack(spacing: 12) {
            RoundedRectangle(cornerRadius: 6)
                .fill(Color.secondary.opacity(0.12))
                .frame(width: 40, height: 54)
                .overlay {
                    Image(systemName: mediumIcon)
                        .foregroundStyle(.tint)
                        .imageScale(.medium)
                }
            VStack(alignment: .leading, spacing: 2) {
                Text(item.title)
                    .font(.subheadline.weight(.medium))
                    .lineLimit(1)
                if let creator = item.creator {
                    Text(creator)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        .lineLimit(1)
                }
            }
            Spacer()
        }
        .padding(.vertical, 6)
    }

    private var mediumIcon: String {
        switch item.medium {
        case .book:   return SemanticTokens.mediumIcon.book
        case .music:  return SemanticTokens.mediumIcon.music
        case .movie:  return SemanticTokens.mediumIcon.movie
        case .object: return SemanticTokens.mediumIcon.object
        case .place:  return SemanticTokens.mediumIcon.place
        }
    }
}
