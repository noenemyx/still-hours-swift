// OnboardingScreen3.swift — App/Views/Onboarding
// Copyright 2026 sunghun.ahn — Still Hours
// R10.3: Screen 3 — 1-to-1 intimate share
// Created: 2026-05-21

import SwiftUI
import InventoryCore

// MARK: - OnboardingScreen3

/// Onboarding Screen 3: "한 사람에게만"
///
/// Layout (§4.1): Share sheet mockup with selected recipient +
/// greyed-out social options + strikethrough. 60% top / 40% bottom.
/// Get Started button triggers onComplete().
/// Reduced Motion per spec §7.3.
///
/// Spec: docs/Onboarding-3step-Design.md §4
@MainActor
struct OnboardingScreen3: View {

    // MARK: - Properties

    let onComplete: () -> Void

    // MARK: - Environment

    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    // MARK: - State

    @State private var recipientVisible = false
    @State private var lineDrawn = false

    // MARK: - Body

    var body: some View {
        GeometryReader { proxy in
            VStack(spacing: 0) {
                // 60% — Share illustration
                shareIllustration
                    .frame(height: proxy.size.height * 0.60)

                // 40% — Copy + Get Started
                copySection
                    .frame(height: proxy.size.height * 0.40)
            }
        }
        .background(Color.shBackground)
        .onAppear { startAnimations() }
    }

    // MARK: - Illustration Section

    private var shareIllustration: some View {
        VStack(spacing: FoundationTokens.Space.lg) {
            Spacer()

            // Sheet mockup
            VStack(spacing: 0) {
                // Sheet title
                Text("Send to one person")
                    .font(.system(.title3, design: .serif).weight(.medium))
                    .foregroundStyle(Color.shTextPrimary)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal, FoundationTokens.Space.md)
                    .padding(.top, FoundationTokens.Space.md)
                    .padding(.bottom, FoundationTokens.Space.sm)

                Divider()
                    .background(Color.shTextSecondary.opacity(0.2))

                // Selected recipient row
                recipientRow
                    .padding(.horizontal, FoundationTokens.Space.md)
                    .padding(.vertical, FoundationTokens.Space.sm)
                    .background(Color.shAccent.opacity(0.12))
                    .overlay(alignment: .leading) {
                        Rectangle()
                            .fill(Color.shAccent)
                            .frame(width: 2)
                    }

                Divider()
                    .background(Color.shTextSecondary.opacity(0.2))

                // Disabled social options
                disabledOptionRow(label: "Twitter", icon: "xmark.circle")
                disabledOptionRow(label: "Instagram", icon: "xmark.circle")
                disabledOptionRow(
                    label: String(
                        localized: "onboarding.3.noPublicProfile",
                        defaultValue: "No public profile · One to one"
                    ),
                    icon: "xmark.circle"
                )

                Spacer().frame(height: FoundationTokens.Space.sm)
            }
            .background(Color.shSurface)
            .clipShape(RoundedRectangle(cornerRadius: FoundationTokens.Radius.xl))
            .glassEffect(
                .regular,
                in: RoundedRectangle(cornerRadius: FoundationTokens.Radius.xl)
            )
            .shFloatingShadow()
            .padding(.horizontal, FoundationTokens.Space.md)
            .opacity(recipientVisible ? 1 : 0)
            .animation(
                reduceMotion ? .linear(duration: 0.2) : .easeOut(duration: 0.4),
                value: recipientVisible
            )

            Spacer()
        }
        .accessibilityLabel(
            String(
                localized: "accessibility.onboarding.3.sheet",
                defaultValue: "Share to: friend Minjin. No public profile. No social media sharing."
            )
        )
    }

    // MARK: - Recipient Row

    private var recipientRow: some View {
        HStack(spacing: FoundationTokens.Space.sm) {
            Circle()
                .fill(Color.shAccentMuted)
                .frame(width: 36, height: 36)
                .overlay {
                    Text("M")
                        .font(.subheadline.weight(.semibold))
                        .foregroundStyle(Color.shAccent)
                }

            VStack(alignment: .leading, spacing: 2) {
                Text("친구 미진")
                    .font(.subheadline.weight(.medium))
                    .foregroundStyle(Color.shTextPrimary)
                Text("minjin@example.com")
                    .font(.caption)
                    .foregroundStyle(Color.shTextSecondary)
            }

            Spacer()

            Image(systemName: "checkmark.circle.fill")
                .foregroundStyle(Color.shAccent)
        }
    }

    // MARK: - Disabled Option Row

    private func disabledOptionRow(label: String, icon: String) -> some View {
        HStack(spacing: FoundationTokens.Space.sm) {
            Image(systemName: icon)
                .font(.subheadline)
                .foregroundStyle(Color.shTextSecondary)

            Text(label)
                .font(.subheadline)
                .foregroundStyle(Color.shTextSecondary)
                .strikethrough(true, color: Color.shTextSecondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal, FoundationTokens.Space.md)
        .padding(.vertical, FoundationTokens.Space.sm)
    }

    // MARK: - Copy Section

    private var copySection: some View {
        VStack(spacing: FoundationTokens.Space.md) {
            VStack(spacing: FoundationTokens.Space.sm) {
                Text(
                    String(
                        localized: "onboarding.3.title",
                        defaultValue: "No public profile. One person at a time."
                    )
                )
                .font(.system(.title2, design: .serif).weight(.medium))
                .foregroundStyle(Color.shTextPrimary)
                .multilineTextAlignment(.center)
                .dynamicTypeSize(.xSmall ... .accessibility3)

                Text(
                    String(
                        localized: "onboarding.3.body",
                        defaultValue: "You choose who sees it. Not an algorithm."
                    )
                )
                .font(.body)
                .foregroundStyle(Color.shTextSecondary)
                .multilineTextAlignment(.center)
                .dynamicTypeSize(.xSmall ... .accessibility3)
            }
            .padding(.horizontal, FoundationTokens.Space.md)

            Button {
                withAnimation(
                    MotionPresets.resolved(MotionPresets.sheet, isCrossFade: true, reduceMotion: reduceMotion)
                ) {
                    onComplete()
                }
            } label: {
                Text(
                    String(
                        localized: "onboarding.getStarted",
                        defaultValue: "Get Started"
                    )
                )
                .font(.headline)
                .frame(maxWidth: .infinity)
                .frame(height: 52)
            }
            .buttonStyle(.glassProminent)
            .padding(.horizontal, FoundationTokens.Space.md)
            .accessibilityLabel(
                String(
                    localized: "onboarding.getStarted",
                    defaultValue: "Start. Begin using Still Hours."
                )
            )
        }
        .padding(.top, FoundationTokens.Space.sm)
        .padding(.bottom, FoundationTokens.Space.xl)
    }

    // MARK: - Animation

    private func startAnimations() {
        if reduceMotion {
            recipientVisible = true
            return
        }
        withAnimation(.easeOut(duration: 0.4)) {
            recipientVisible = true
        }
    }
}
