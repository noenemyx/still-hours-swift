// OnboardingScreen1.swift — App/Views/Onboarding
// Copyright 2026 sunghun.ahn — Still Hours
// R10.3: Screen 1 — Item-as-memory-anchor
// Created: 2026-05-21
// R11.4: Liquid Glass uniformly tinted via .shGlass() — Design-R11 §8.

import SwiftUI
import InventoryCore

// MARK: - OnboardingScreen1

/// Onboarding Screen 1: "자산이 기억의 입구가 된다"
///
/// Layout (§2.1): 45% ItemCard / 25% Memory entry / 30% copy + Next.
/// 4-stage animation per spec §2.2. Reduced Motion via §7.3.
/// VoiceOver per spec §7.1.
///
/// Spec: docs/Onboarding-3step-Design.md §2
@MainActor
struct OnboardingScreen1: View {

    // MARK: - Properties

    let onNext: () -> Void

    // MARK: - Environment

    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    // MARK: - Animation State

    @State private var cardAppeared = false
    @State private var memoryVisible = false
    @State private var displayedText = ""
    @State private var charIndex = 0
    @State private var cursorVisible = true

    // MARK: - Private

    private var fullText: String {
        String(
            localized: "onboarding.1.memory.example",
            defaultValue: "Tokyo Tsutaya · 2024-08-15 · With my mother"
        )
    }

    // MARK: - Body

    var body: some View {
        GeometryReader { proxy in
            VStack(spacing: 0) {
                // 45% — ItemCard zone
                itemCardSection
                    .frame(height: proxy.size.height * 0.45)

                // 25% — Memory entry zone
                memorySection
                    .frame(height: proxy.size.height * 0.25)

                // 30% — Copy + Next
                copySection
                    .frame(height: proxy.size.height * 0.30)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .background(Color.shBackground)
        .onAppear { startAnimations() }
    }

    // MARK: - Sections

    private var itemCardSection: some View {
        VStack {
            Spacer()
            ZStack {
                // Book card placeholder
                RoundedRectangle(cornerRadius: ComponentTokens.ItemCard.radius)
                    .fill(Color.shAccentMuted)
                    .aspectRatio(ComponentTokens.ItemCard.aspectRatio, contentMode: .fit)
                    .frame(width: cardWidth)
                    .shElevatedShadow()
                    .shGlass(in: RoundedRectangle(cornerRadius: ComponentTokens.ItemCard.radius))
                    .overlay(alignment: .bottom) {
                        bookCardOverlay
                    }
            }
            .opacity(reduceMotion ? 1 : (cardAppeared ? 1 : 0))
            .offset(y: reduceMotion ? 0 : (cardAppeared ? 0 : 12))
            .rotationEffect(
                .degrees(reduceMotion ? 0 : (cardAppeared ? 0 : 8)),
                anchor: .bottom
            )
            .animation(
                reduceMotion
                    ? .linear(duration: 0.2)
                    : .easeOut(duration: 0.6),
                value: cardAppeared
            )
            .accessibilityLabel(
                String(
                    localized: "accessibility.onboarding.1.card",
                    defaultValue: "Book cover: Norwegian Wood. Your items become the entry to memories."
                )
            )
            Spacer()
        }
        .padding(.horizontal, FoundationTokens.Space.xxl)
    }

    private var bookCardOverlay: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text("Norwegian Wood")
                .font(.caption.weight(.semibold))
                .foregroundStyle(Color.shTextPrimary)
                .lineLimit(1)
            Text("무라카미 하루키")
                .font(.caption2)
                .foregroundStyle(Color.shTextSecondary)
        }
        .padding(ComponentTokens.ItemCard.padding / 2)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.shSurface.opacity(0.9))
        .clipShape(
            RoundedRectangle(cornerRadius: ComponentTokens.ItemCard.radius)
                .inset(by: 0)
        )
    }

    private var memorySection: some View {
        HStack(spacing: FoundationTokens.Space.sm) {
            // Left accent line
            Rectangle()
                .fill(Color.shAccent)
                .frame(width: ComponentTokens.MemoryRow.accentLineWidth)
                .padding(.vertical, 4)

            VStack(alignment: .leading, spacing: 4) {
                HStack(spacing: FoundationTokens.Space.xs) {
                    Image(systemName: "mappin.circle")
                        .font(.caption)
                        .foregroundStyle(Color.shAccent)
                        .frame(width: ComponentTokens.MemoryRow.iconSize,
                               height: ComponentTokens.MemoryRow.iconSize)
                    // Typing text + cursor
                    HStack(spacing: 0) {
                        Text(displayedText)
                            .font(.subheadline)
                            .foregroundStyle(Color.shTextPrimary)
                        if charIndex < fullText.count {
                            Text("|")
                                .font(.subheadline)
                                .foregroundStyle(Color.shAccent)
                                .opacity(cursorVisible ? 1 : 0)
                                .animation(
                                    .easeInOut(duration: 0.2).repeatForever(),
                                    value: cursorVisible
                                )
                        }
                    }
                }
            }
        }
        .padding(.horizontal, FoundationTokens.Space.md)
        .opacity(reduceMotion ? 1 : (memoryVisible ? 1 : 0))
        .offset(x: reduceMotion ? 0 : (memoryVisible ? 0 : -8))
        .animation(
            reduceMotion
                ? .linear(duration: 0.2)
                : .easeInOut(duration: 0.5),
            value: memoryVisible
        )
        .accessibilityLabel(
            String(
                localized: "accessibility.onboarding.1.memory",
                defaultValue: "Memory entry: Tokyo Tsutaya, August 2024, with my mother"
            )
        )
    }

    private var copySection: some View {
        VStack(spacing: FoundationTokens.Space.md) {
            VStack(spacing: FoundationTokens.Space.sm) {
                Text(
                    String(
                        localized: "onboarding.1.title",
                        defaultValue: "Items aren't records. They're entrances."
                    )
                )
                .font(.system(.title2, design: .serif).weight(.medium))
                .foregroundStyle(Color.shTextPrimary)
                .multilineTextAlignment(.center)
                .dynamicTypeSize(.xSmall ... .accessibility3)

                Text(
                    String(
                        localized: "onboarding.1.body",
                        defaultValue: "The story of getting it lives inside."
                    )
                )
                .font(.body)
                .foregroundStyle(Color.shTextSecondary)
                .multilineTextAlignment(.center)
                .dynamicTypeSize(.xSmall ... .accessibility3)
            }
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
                String(
                    localized: "onboarding.next",
                    defaultValue: "Next"
                )
            )
        }
        .padding(.bottom, FoundationTokens.Space.xl)
    }

    // MARK: - Layout Helpers

    private var cardWidth: CGFloat { 240 }

    // MARK: - Animation Logic

    private func startAnimations() {
        if reduceMotion {
            // Reduced Motion: show final state immediately with short cross-fade
            cardAppeared = true
            memoryVisible = true
            displayedText = fullText
            charIndex = fullText.count
            return
        }
        // Stage 1: Card appear at 0ms
        withAnimation(.easeOut(duration: 0.6)) {
            cardAppeared = true
        }
        // Stage 3: Memory row at 1200ms
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) {
            withAnimation(.easeInOut(duration: 0.5)) {
                memoryVisible = true
            }
            // Start cursor blink
            cursorVisible = false
            withAnimation(.easeInOut(duration: 0.2).repeatForever()) {
                cursorVisible = true
            }
            // Stage 4: Typing at 1700ms (500ms after stage 3)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                typeNextChar()
            }
        }
    }

    private func typeNextChar() {
        let chars = Array(fullText)
        guard charIndex < chars.count else { return }
        displayedText += String(chars[charIndex])
        charIndex += 1
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.045) {
            typeNextChar()
        }
    }
}
