// HelpView.swift — App/Views/Settings
// Copyright 2026 sunghun.ahn — Still Hours
// Round 15.2: In-app Help / FAQ surface
// Created: 2026-05-22

import SwiftUI
import InventoryCore

// MARK: - HelpView

/// FAQ + how-tos + Promise links + contact surface.
///
/// Four grouped sections:
///   1. 시작하기 — Capture / AddMemory / CloudKit basics
///   2. FAQ — subscription / ads / AI / export / sharing
///   3. 문의 — email + 48h SLA
///   4. 약속 + 법적 — links to About, Privacy, Terms
///
/// Layout: insetGrouped List backed by Color.shBackground.
/// FAQ rows use DisclosureGroup for expand-on-tap.
@MainActor
struct HelpView: View {

    // MARK: State

    @State private var expandedFAQ: FAQItem? = nil

    // MARK: Body

    var body: some View {
        List {
            gettingStartedSection
            faqSection
            contactSection
            legalSection
        }
        .listStyle(.insetGrouped)
        .background(Color.shBackground)
        .scrollContentBackground(.hidden)
        .navigationTitle(
            String(
                localized: "settings.help.title",
                defaultValue: "도움말"
            )
        )
        .navigationBarTitleDisplayMode(.inline)
    }

    // MARK: Section 1 — 시작하기

    private var gettingStartedSection: some View {
        Section(
            header: Text(
                String(
                    localized: "help.section.gettingStarted.title",
                    defaultValue: "시작하기"
                )
            )
        ) {
            ForEach(GettingStartedItem.allCases, id: \.self) { item in
                VStack(alignment: .leading, spacing: 6) {
                    Text(item.question)
                        .font(.subheadline)
                        .fontWeight(.medium)
                        .foregroundStyle(Color.shTextPrimary)

                    Text(item.answer)
                        .font(.subheadline)
                        .foregroundStyle(Color.shTextSecondary)
                        .fixedSize(horizontal: false, vertical: true)
                }
                .padding(.vertical, 4)
            }
        }
    }

    // MARK: Section 2 — FAQ

    private var faqSection: some View {
        Section(
            header: Text(
                String(
                    localized: "help.section.faq.title",
                    defaultValue: "자주 묻는 질문"
                )
            )
        ) {
            ForEach(FAQItem.allCases, id: \.self) { item in
                faqRow(item)
            }
        }
    }

    @ViewBuilder
    private func faqRow(_ item: FAQItem) -> some View {
        let isExpanded = expandedFAQ == item

        VStack(alignment: .leading, spacing: 0) {
            Button {
                withAnimation(.spring(response: 0.3, dampingFraction: 0.75)) {
                    expandedFAQ = isExpanded ? nil : item
                }
            } label: {
                HStack(alignment: .center) {
                    Text(item.question)
                        .font(.subheadline)
                        .fontWeight(.medium)
                        .foregroundStyle(Color.shTextPrimary)
                        .multilineTextAlignment(.leading)
                    Spacer(minLength: 8)
                    Image(systemName: isExpanded ? "chevron.up" : "chevron.down")
                        .font(.caption)
                        .foregroundStyle(Color.shTextSecondary)
                        .animation(.easeInOut(duration: 0.2), value: isExpanded)
                }
                .contentShape(Rectangle())
            }
            .buttonStyle(.plain)
            .accessibilityLabel(item.question)
            .accessibilityHint(
                isExpanded
                    ? String(
                        localized: "about.collapse",
                        defaultValue: "두 번 탭하여 접기"
                    )
                    : String(
                        localized: "about.expand",
                        defaultValue: "두 번 탭하여 펼치기"
                    )
            )
            .padding(.vertical, 4)

            if isExpanded {
                Text(item.answer)
                    .font(.subheadline)
                    .foregroundStyle(Color.shTextSecondary)
                    .fixedSize(horizontal: false, vertical: true)
                    .padding(.top, 6)
                    .padding(.bottom, 4)
                    .transition(.opacity.combined(with: .move(edge: .top)))
            }
        }
    }

    // MARK: Section 3 — 문의

    private var contactSection: some View {
        Section(
            header: Text(
                String(
                    localized: "help.section.contact.title",
                    defaultValue: "문의"
                )
            )
        ) {
            VStack(alignment: .leading, spacing: 4) {
                Text(
                    String(
                        localized: "help.contact.email.label",
                        defaultValue: "이메일"
                    )
                )
                .font(.caption)
                .foregroundStyle(Color.shTextSecondary)

                Text("sunghun.ahn@gmail.com")
                    .font(.subheadline)
                    .foregroundStyle(Color.shTextPrimary)
            }
            .padding(.vertical, 4)

            VStack(alignment: .leading, spacing: 4) {
                Text(
                    String(
                        localized: "help.contact.sla.label",
                        defaultValue: "답장 기준"
                    )
                )
                .font(.caption)
                .foregroundStyle(Color.shTextSecondary)

                Text(
                    String(
                        localized: "help.contact.sla.value",
                        defaultValue: "48시간 이내"
                    )
                )
                .font(.subheadline)
                .foregroundStyle(Color.shTextPrimary)
            }
            .padding(.vertical, 4)
        }
    }

    // MARK: Section 4 — 약속 + 법적

    private var legalSection: some View {
        Section(
            header: Text(
                String(
                    localized: "help.section.legal.title",
                    defaultValue: "약속 + 법적"
                )
            )
        ) {
            NavigationLink(destination: AboutStillHoursView()) {
                Label(
                    String(
                        localized: "settings.about.title",
                        defaultValue: "Still Hours is"
                    ),
                    systemImage: "heart"
                )
            }

            NavigationLink(destination: DataPrivacyView()) {
                Label(
                    String(
                        localized: "settings.dataPrivacy",
                        defaultValue: "Data Privacy"
                    ),
                    systemImage: "lock.shield"
                )
            }

            HStack {
                Label(
                    String(
                        localized: "help.legal.terms",
                        defaultValue: "이용약관"
                    ),
                    systemImage: "doc.text"
                )
                Spacer()
                Text(
                    String(
                        localized: "help.legal.comingSoon",
                        defaultValue: "출시 후 공개"
                    )
                )
                .font(.caption)
                .foregroundStyle(Color.shTextSecondary)
            }

            HStack {
                Label(
                    String(
                        localized: "help.legal.privacy",
                        defaultValue: "개인정보 처리방침"
                    ),
                    systemImage: "hand.raised"
                )
                Spacer()
                Text(
                    String(
                        localized: "help.legal.comingSoon",
                        defaultValue: "출시 후 공개"
                    )
                )
                .font(.caption)
                .foregroundStyle(Color.shTextSecondary)
            }
        }
    }
}

// MARK: - GettingStartedItem

private enum GettingStartedItem: CaseIterable, Hashable {
    case firstAsset
    case addMemory
    case dataStorage

    var question: String {
        switch self {
        case .firstAsset:
            return String(
                localized: "help.gs.firstAsset.q",
                defaultValue: "첫 자산은 어떻게 등록하나요?"
            )
        case .addMemory:
            return String(
                localized: "help.gs.addMemory.q",
                defaultValue: "기억은 어떻게 추가하나요?"
            )
        case .dataStorage:
            return String(
                localized: "help.gs.dataStorage.q",
                defaultValue: "데이터는 어디에 저장되나요?"
            )
        }
    }

    var answer: String {
        switch self {
        case .firstAsset:
            return String(
                localized: "help.gs.firstAsset.a",
                defaultValue: "하단의 + 버튼을 탭 → 카메라로 바코드를 스캔하거나 이름을 직접 입력 → 저장. 사진, 태그, 메모를 추가해 기록을 풍성하게 만들 수 있습니다."
            )
        case .addMemory:
            return String(
                localized: "help.gs.addMemory.a",
                defaultValue: "자산 상세 화면에서 '기억 추가' 버튼을 탭하세요. 날짜, 장소, 같이한 사람, 느낌을 기록할 수 있습니다."
            )
        case .dataStorage:
            return String(
                localized: "help.gs.dataStorage.a",
                defaultValue: "모든 데이터는 사용자 본인의 iCloud Private Database에만 저장됩니다. Still Hours 서버는 존재하지 않으며, 개발자는 데이터에 접근할 수 없습니다."
            )
        }
    }
}

// MARK: - FAQItem

private enum FAQItem: CaseIterable, Hashable {
    case subscription
    case ads
    case aiClassification
    case export
    case sharing

    var question: String {
        switch self {
        case .subscription:
            return String(
                localized: "help.faq.subscription.q",
                defaultValue: "구독 모델이 있나요?"
            )
        case .ads:
            return String(
                localized: "help.faq.ads.q",
                defaultValue: "광고는 있나요?"
            )
        case .aiClassification:
            return String(
                localized: "help.faq.ai.q",
                defaultValue: "AI가 자동으로 분류하나요?"
            )
        case .export:
            return String(
                localized: "help.faq.export.q",
                defaultValue: "내 데이터를 가져갈 수 있나요?"
            )
        case .sharing:
            return String(
                localized: "help.faq.sharing.q",
                defaultValue: "친구와 어떻게 공유하나요?"
            )
        }
    }

    var answer: String {
        switch self {
        case .subscription:
            return String(
                localized: "help.faq.subscription.a",
                defaultValue: "없습니다. 한 번 구매하면 모든 기능을 영구적으로 사용할 수 있습니다. 구독이나 숨겨진 결제는 없습니다."
            )
        case .ads:
            return String(
                localized: "help.faq.ads.a",
                defaultValue: "없습니다. 광고 네트워크나 분석 SDK를 사용하지 않습니다. PrivacyInfo.xcprivacy에 코드로 선언되어 있습니다."
            )
        case .aiClassification:
            return String(
                localized: "help.faq.ai.a",
                defaultValue: "AI는 사용자의 의도를 따릅니다. 자동 분류나 추천 알고리즘 없이, 사용자가 직접 기록하고 정리합니다."
            )
        case .export:
            return String(
                localized: "help.faq.export.a",
                defaultValue: "네. 설정 → 데이터 내보내기에서 언제든 JSON 또는 CSV로 전체 데이터를 내보낼 수 있습니다."
            )
        case .sharing:
            return String(
                localized: "help.faq.sharing.a",
                defaultValue: "1:1 CKShare를 통해 특정 컬렉션을 친구와 공유할 수 있습니다. v1.5에서 지원 예정입니다."
            )
        }
    }
}
