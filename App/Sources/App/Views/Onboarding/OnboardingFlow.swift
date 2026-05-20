// OnboardingFlow.swift — App/Views/Onboarding
// Copyright 2026 sunghun.ahn — Still Hours
// R10.3: Onboarding 3-step container with TabView page style
// Created: 2026-05-21

import SwiftUI
import InventoryCore

// MARK: - OnboardingFlow

/// Root container for the 3-screen first-launch onboarding sequence.
///
/// Manages page navigation, Skip button, and the Next/Get Started button
/// per spec §5. Parent dismisses or hides this view by setting the
/// `hasCompletedOnboarding` AppStorage key or via `onComplete` callback.
///
/// Spec: docs/Onboarding-3step-Design.md §5, §6, §8.3
@MainActor
struct OnboardingFlow: View {

    // MARK: - Properties

    let onComplete: () -> Void

    // MARK: - State

    @State private var currentPage: Int = 0
    @AppStorage("hasCompletedOnboarding") private var hasCompletedOnboarding = false

    // MARK: - Environment

    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    // MARK: - Init

    init(onComplete: @escaping () -> Void) {
        self.onComplete = onComplete
    }

    // MARK: - Body

    var body: some View {
        ZStack(alignment: .topTrailing) {
            TabView(selection: $currentPage) {
                OnboardingScreen1(onNext: { advance() })
                    .tag(0)
                    .accessibilityLabel(
                        String(
                            localized: "onboarding.1.title",
                            defaultValue: "Items become the entry to memories"
                        )
                    )

                OnboardingScreen2(onNext: { advance() })
                    .tag(1)
                    .accessibilityLabel(
                        String(
                            localized: "onboarding.2.title",
                            defaultValue: "Four media, one model"
                        )
                    )

                OnboardingScreen3(onComplete: complete)
                    .tag(2)
                    .accessibilityLabel(
                        String(
                            localized: "onboarding.3.title",
                            defaultValue: "Share intimately, one to one"
                        )
                    )
            }
            .tabViewStyle(.page(indexDisplayMode: .always))
            .animation(
                reduceMotion ? .linear(duration: 0) : MotionPresets.sheet,
                value: currentPage
            )
            .background(Color.shBackground)
            .ignoresSafeArea()

            // Skip button — visible on pages 0 and 1 only
            if currentPage < 2 {
                Button {
                    complete()
                } label: {
                    Text(
                        String(
                            localized: "onboarding.skip",
                            defaultValue: "Skip"
                        )
                    )
                    .font(.subheadline.weight(.medium))
                    .foregroundStyle(Color.shTextSecondary)
                }
                .padding(.top, FoundationTokens.Space.md)
                .padding(.trailing, FoundationTokens.Space.md)
                .accessibilityLabel(
                    String(
                        localized: "onboarding.skip",
                        defaultValue: "Skip onboarding"
                    )
                )
                .dynamicTypeSize(.xSmall ... .accessibility3)
            }
        }
    }

    // MARK: - Actions

    private func advance() {
        let anim: Animation = reduceMotion ? .linear(duration: 0) : MotionPresets.sheet
        withAnimation(anim) {
            currentPage = min(currentPage + 1, 2)
        }
    }

    private func complete() {
        withAnimation(
            MotionPresets.resolved(MotionPresets.sheet, isCrossFade: true, reduceMotion: reduceMotion)
        ) {
            hasCompletedOnboarding = true
            onComplete()
        }
    }
}
