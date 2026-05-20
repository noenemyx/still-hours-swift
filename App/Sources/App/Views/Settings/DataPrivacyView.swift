// DataPrivacyView.swift — App/Views/Settings
// Copyright 2026 sunghun.ahn — Still Hours
// Round 7: Privacy promise surface — Promise §1-3
// Created: 2026-05-21

import SwiftUI
import InventoryCore

// MARK: - DataPrivacyView

/// Explains the three core privacy promises backed by PrivacyInfo.xcprivacy.
///
/// Sections:
///   1. "데이터는 사용자 기기에만" — on-device / iCloud Private DB
///   2. "CloudKit Private DB만 사용" — technical basis
///   3. "추적·광고·데이터 판매 없음" — no tracking, no ads, no data sale
///
/// Footer references the PrivacyInfo.xcprivacy manifest declaration.
@MainActor
struct DataPrivacyView: View {

    // MARK: Body

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 32) {
                ForEach(PrivacySection.allCases, id: \.self) { section in
                    privacyBlock(section)
                }
                manifestFooter
            }
            .padding(.horizontal, 24)
            .padding(.vertical, 32)
        }
        .background(Color.shBackground)
        .navigationTitle(
            String(
                localized: "settings.dataPrivacy",
                defaultValue: "Data Privacy"
            )
        )
        .navigationBarTitleDisplayMode(.inline)
    }

    // MARK: Section block

    @ViewBuilder
    private func privacyBlock(_ section: PrivacySection) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(spacing: 10) {
                Image(systemName: section.icon)
                    .font(.title3)
                    .foregroundStyle(Color.shAccent)
                    .accessibilityHidden(true)

                Text(section.title)
                    .font(.headline)
                    .foregroundStyle(Color.shTextPrimary)
                    .accessibilityAddTraits(.isHeader)
            }

            Text(section.body)
                .font(.body)
                .foregroundStyle(Color.shTextSecondary)
                .fixedSize(horizontal: false, vertical: true)
        }
    }

    // MARK: PrivacyInfo manifest footer

    private var manifestFooter: some View {
        VStack(alignment: .leading, spacing: 4) {
            Divider()
                .padding(.vertical, 8)

            Text(
                String(
                    localized: "privacy.manifest.footer",
                    defaultValue: "PrivacyInfo.xcprivacy manifest를 통해 Apple App Store에 위 약속이 코드로 선언되어 있습니다."
                )
            )
            .font(.caption)
            .foregroundStyle(Color.shTextSecondary)
        }
    }
}

// MARK: - PrivacySection

private enum PrivacySection: CaseIterable, Hashable {
    case onDevice
    case cloudKit
    case noTracking

    var icon: String {
        switch self {
        case .onDevice: return "iphone.and.arrow.forward"
        case .cloudKit: return "cloud.fill"
        case .noTracking: return "eye.slash"
        }
    }

    var title: String {
        switch self {
        case .onDevice:
            return String(
                localized: "privacy.section.onDevice.title",
                defaultValue: "Your data stays on your device"
            )
        case .cloudKit:
            return String(
                localized: "privacy.section.cloudkit.title",
                defaultValue: "CloudKit Private database only"
            )
        case .noTracking:
            return String(
                localized: "privacy.section.noAds.title",
                defaultValue: "No tracking, no ads, no data sale"
            )
        }
    }

    var body: String {
        switch self {
        case .onDevice:
            return String(
                localized: "privacy.section.onDevice.body",
                defaultValue: "모든 데이터는 사용자의 기기와 개인 iCloud 계정에만 저장됩니다. Still Hours 서버는 존재하지 않습니다."
            )
        case .cloudKit:
            return String(
                localized: "privacy.section.cloudkit.body",
                defaultValue: "동기화는 Apple CloudKit Private Database를 통해서만 이루어집니다. 개발자는 사용자의 데이터에 접근할 수 없습니다."
            )
        case .noTracking:
            return String(
                localized: "privacy.section.noAds.body",
                defaultValue: "분석 SDK 없음, 광고 네트워크 없음, 제3자 데이터 판매 없음. PrivacyInfo.xcprivacy에 이 약속이 코드로 선언되어 있습니다."
            )
        }
    }
}
