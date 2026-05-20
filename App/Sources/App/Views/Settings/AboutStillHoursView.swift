// AboutStillHoursView.swift — App/Views/Settings
// Copyright 2026 sunghun.ahn — Still Hours
// Round 7: "Still Hours is" brand-promise surface
// Created: 2026-05-21

import SwiftUI
import InventoryCore

// MARK: - AboutStillHoursView

/// The "Still Hours is" brand-promise surface.
///
/// Three expandable sections derived from Settings-Surface-Copy.md:
///   1. Identity — No algorithm / No public feed / No advertising
///   2. Data Sovereignty — export, iCloud-only data
///   3. Made by — sunghun.ahn + blog link (placeholder URL)
///
/// Layout: display-type hero lead → expandable rows → footer version line.
@MainActor
struct AboutStillHoursView: View {

    // MARK: State

    @State private var expandedSection: AboutSection? = nil

    // MARK: Computed

    private var appVersion: String {
        Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString")
            as? String ?? "1.0.0"
    }

    // MARK: Body

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 40) {
                heroText
                expandableRows
                footerLine
            }
            .padding(.horizontal, 24)
            .padding(.vertical, 32)
        }
        .background(Color.shBackground)
        .navigationTitle(
            String(localized: "settings.about.title", defaultValue: "Still Hours is")
        )
        .navigationBarTitleDisplayMode(.inline)
    }

    // MARK: Hero

    private var heroText: some View {
        Text(
            String(
                localized: "settings.about.lead",
                defaultValue: "Items as the entry. Memories as the body"
            )
        )
        .font(StillHoursTypeface.display(for: Locale.current))
        .foregroundStyle(Color.shTextPrimary)
        .accessibilityAddTraits(.isHeader)
    }

    // MARK: Expandable rows

    private var expandableRows: some View {
        VStack(alignment: .leading, spacing: 0) {
            ForEach(AboutSection.allCases, id: \.self) { section in
                aboutRow(section)
                if section != AboutSection.allCases.last {
                    Divider()
                        .background(Color.shAccentMuted.opacity(0.4))
                }
            }
        }
    }

    @ViewBuilder
    private func aboutRow(_ section: AboutSection) -> some View {
        let isExpanded = expandedSection == section

        VStack(alignment: .leading, spacing: 0) {
            Button {
                withAnimation(
                    .spring(response: 0.35, dampingFraction: 0.75)
                ) {
                    expandedSection = isExpanded ? nil : section
                }
            } label: {
                HStack {
                    Text(section.title)
                        .font(.headline)
                        .foregroundStyle(Color.shTextPrimary)
                    Spacer()
                    Image(
                        systemName: isExpanded
                            ? "chevron.up"
                            : "chevron.down"
                    )
                    .foregroundStyle(Color.shTextSecondary)
                    .font(.caption)
                    .animation(.easeInOut(duration: 0.2), value: isExpanded)
                }
                .padding(.vertical, 16)
            }
            .accessibilityLabel(section.title)
            .accessibilityHint(
                isExpanded
                    ? String(
                        localized: "about.collapse",
                        defaultValue: "Double-tap to collapse"
                    )
                    : String(
                        localized: "about.expand",
                        defaultValue: "Double-tap to expand"
                    )
            )

            if isExpanded {
                Text(section.body)
                    .font(.body)
                    .foregroundStyle(Color.shTextSecondary)
                    .padding(.bottom, 16)
                    .transition(.opacity.combined(with: .move(edge: .top)))
            }
        }
    }

    // MARK: Footer

    private var footerLine: some View {
        Text("Still Hours v\(appVersion) · sunghun.ahn · 2026")
            .font(.caption)
            .foregroundStyle(Color.shTextSecondary)
            .frame(maxWidth: .infinity, alignment: .center)
            .padding(.top, 8)
    }
}

// MARK: - AboutSection

/// The three expandable sections in AboutStillHoursView.
private enum AboutSection: CaseIterable, Hashable {
    case identity
    case dataSovereignty
    case madeBy

    var title: String {
        switch self {
        case .identity:
            return String(
                localized: "about.section.identity",
                defaultValue: "Still Hours는"
            )
        case .dataSovereignty:
            return String(
                localized: "about.section.dataSovereignty",
                defaultValue: "데이터 주권"
            )
        case .madeBy:
            return String(
                localized: "about.section.madeBy",
                defaultValue: "만든 사람"
            )
        }
    }

    var body: String {
        switch self {
        case .identity:
            return String(
                localized: "about.section.identity.body",
                defaultValue: "알고리즘 없음 · 공개 피드 없음 · 광고 없음.\n\n조용한 수집 도구입니다. 당신이 가진 것의 이야기를 기록합니다."
            )
        case .dataSovereignty:
            return String(
                localized: "about.section.dataSovereignty.body",
                defaultValue: "데이터는 당신의 iCloud에만 존재합니다. JSON 또는 CSV로 언제든 내보낼 수 있으며, 앱을 삭제하면 데이터도 삭제됩니다."
            )
        case .madeBy:
            return String(
                localized: "about.section.madeBy.body",
                defaultValue: "sunghun.ahn이 혼자 만든 도구입니다. 10년을 쓸 수 있도록 만들었습니다."
            )
        }
    }
}
