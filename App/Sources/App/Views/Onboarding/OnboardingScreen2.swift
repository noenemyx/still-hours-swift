// OnboardingScreen2.swift — App/Views/Onboarding
// Copyright 2026 sunghun.ahn — Still Hours
// R10.3: Screen 2 — Four media, one model
// Created: 2026-05-21

import SwiftUI
import InventoryCore

// MARK: - OnboardingScreen2

/// Onboarding Screen 2: "4 medium, 하나의 공간"
///
/// Layout (§3.1): 4 cards HStack with staggered fade-in. Dynamic Type
/// fallback to 2×2 grid at accessibility4+ per spec §7.2.
/// Reduced Motion per spec §7.3.
///
/// Spec: docs/Onboarding-3step-Design.md §3
@MainActor
struct OnboardingScreen2: View {

    // MARK: - Properties

    let onNext: () -> Void

    // MARK: - Environment

    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @Environment(\.dynamicTypeSize) private var typeSize

    // MARK: - State

    @State private var cardVisible: [Bool] = [false, false, false, false]

    // MARK: - Private

    private var useGridLayout: Bool { typeSize >= .accessibility4 }

    private let mediumItems: [MediumItem] = [
        MediumItem(symbol: "book.closed", label: "onboarding.2.medium.book", delay: 0.0),
        MediumItem(symbol: "music.note", label: "onboarding.2.medium.music", delay: 0.12),
        MediumItem(symbol: "film",       label: "onboarding.2.medium.movie", delay: 0.24),
        MediumItem(symbol: "cube",       label: "onboarding.2.medium.object", delay: 0.36)
    ]

    // MARK: - Body

    var body: some View {
        VStack(spacing: 0) {
            Spacer()

            // Card grid or HStack based on Dynamic Type
            if useGridLayout {
                LazyVGrid(
                    columns: [GridItem(.flexible()), GridItem(.flexible())],
                    spacing: 12
                ) {
                    ForEach(mediumItems.indices, id: \.self) { index in
                        mediumCard(item: mediumItems[index], index: index)
                    }
                }
                .padding(.horizontal, FoundationTokens.Space.md)
            } else {
                HStack(spacing: 12) {
                    ForEach(mediumItems.indices, id: \.self) { index in
                        mediumCard(item: mediumItems[index], index: index)
                    }
                }
                .padding(.horizontal, FoundationTokens.Space.md)
            }

            Spacer()

            // Copy section
            VStack(spacing: FoundationTokens.Space.md) {
                Text(
                    String(
                        localized: "onboarding.2.title",
                        defaultValue: "Books, music, films, objects — kept under one shelf."
                    )
                )
                .font(.system(.title2, design: .serif).weight(.medium))
                .foregroundStyle(Color.shTextPrimary)
                .multilineTextAlignment(.center)
                .dynamicTypeSize(.xSmall ... .accessibility3)
                .padding(.horizontal, FoundationTokens.Space.md)

                Text(
                    String(
                        localized: "onboarding.2.body",
                        defaultValue: "책 · 음반 · 영화 · 오브제 — 같은 데이터 모델, 같은 캡처 흐름"
                    )
                )
                .font(.subheadline)
                .foregroundStyle(Color.shTextSecondary)
                .multilineTextAlignment(.center)
                .dynamicTypeSize(.xSmall ... .accessibility3)
                .padding(.horizontal, FoundationTokens.Space.md)

                Button {
                    onNext()
                } label: {
                    Text(
                        String(
                            localized: "onboarding.next",
                            defaultValue: "Next"
                        )
                    )
                    .font(.headline)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 14)
                }
                .buttonStyle(.glassProminent)
                .padding(.horizontal, FoundationTokens.Space.md)
                .accessibilityLabel(
                    String(localized: "onboarding.next", defaultValue: "Next")
                )
            }
            .padding(.bottom, FoundationTokens.Space.xl)
        }
        .background(Color.shBackground)
        .onAppear { startAnimations() }
    }

    // MARK: - Card View

    @ViewBuilder
    private func mediumCard(item: MediumItem, index: Int) -> some View {
        VStack(spacing: FoundationTokens.Space.sm) {
            // Card placeholder
            RoundedRectangle(cornerRadius: FoundationTokens.Radius.sm)
                .fill(Color.shAccentMuted)
                .aspectRatio(ComponentTokens.ItemCard.aspectRatio, contentMode: .fit)
                .overlay(alignment: .center) {
                    Image(systemName: item.symbol)
                        .font(.system(size: 24, weight: .regular))
                        .foregroundStyle(Color.shAccent)
                }
                .glassEffect(.clear, in: RoundedRectangle(cornerRadius: FoundationTokens.Radius.sm))
                .shElevatedShadow()

            // Badge label
            Text(item.label)
                .font(.caption)
                .foregroundStyle(Color.shTextSecondary)
        }
        .opacity(cardVisible[index] ? 1 : 0)
        .offset(y: cardVisible[index] ? 0 : (reduceMotion ? 0 : 6))
        .accessibilityLabel(Text(item.label))
    }

    // MARK: - Animation

    private func startAnimations() {
        if reduceMotion {
            // All cards appear simultaneously with short cross-fade
            withAnimation(.linear(duration: 0.2)) {
                for i in mediumItems.indices { cardVisible[i] = true }
            }
            return
        }
        for (index, item) in mediumItems.enumerated() {
            DispatchQueue.main.asyncAfter(deadline: .now() + item.delay) {
                withAnimation(.easeOut(duration: 0.3)) {
                    cardVisible[index] = true
                }
            }
        }
    }
}

// MARK: - MediumItem

private struct MediumItem {
    let symbol: String
    let label: LocalizedStringKey
    let delay: Double
}
