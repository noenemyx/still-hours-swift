// VoiceCaptureCoordinator.swift — App/Views/Capture
// Copyright 2026 sunghun.ahn — Still Hours
// Sprint 1.4 — VoiceMemoCaptureView + SFSpeechRecognizer (ko/en/ja)
// Created: 2026-05-21
//
// Wraps VoiceMemoCaptureView and coordinates the CaptureStateMachine transition.
// On transcription: builds CapturePayload → calls stateMachine.recognize(payload:).

import SwiftUI
import InventoryCore

// MARK: - VoiceCaptureCoordinator

/// SwiftUI view that wraps `VoiceMemoCaptureView` and drives the state machine.
///
/// Responsibilities:
/// 1. Hosts `VoiceMemoCaptureView` with the `onTranscribed` callback.
/// 2. On transcription received: builds a `CapturePayload` (title = first 80 chars,
///    medium = .book default, creator = nil, cover = nil).
/// 3. Calls `stateMachine.recognize(payload:)` to transition to `.confirming`.
/// 4. Offers a "Manual entry" escape hatch via `onSwitchToManual`.
@MainActor
struct VoiceCaptureCoordinator: View {

    // MARK: Input

    @ObservedObject var stateMachine: CaptureStateMachine
    let onSwitchToManual: () -> Void

    // MARK: Body

    var body: some View {
        VStack(spacing: 0) {
            VoiceMemoCaptureView { transcript in
                handleTranscription(transcript)
            }

            manualFallbackButton
                .padding(.bottom, 8)
        }
    }

    // MARK: Manual fallback

    private var manualFallbackButton: some View {
        Button {
            onSwitchToManual()
        } label: {
            Label(
                String(
                    localized: "capture.mode.manual",
                    defaultValue: "Manual"
                ),
                systemImage: "keyboard"
            )
            .font(.subheadline)
        }
        .buttonStyle(.glass)
        .accessibilityLabel(
            String(localized: "capture.mode.manual", defaultValue: "Manual")
        )
        .accessibilityHint("Switches to the manual entry form.")
    }

    // MARK: Transcription handler

    /// Converts the raw transcript into a `CapturePayload` and advances the state machine.
    ///
    /// Title: first 80 non-whitespace-trimmed characters of the transcript.
    /// Medium: `.book` (user can change this in the confirming / preview UI).
    /// The full transcript is stored in the title field so the user can edit it
    /// before saving — the confirming view (`CapturePreviewView`) exposes a
    /// TextField for this purpose.
    private func handleTranscription(_ transcript: String) {
        let trimmed = transcript.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return }

        let title = String(trimmed.prefix(80))
        let payload = CapturePayload(
            title: title,
            medium: .book,
            creator: nil,
            coverImageData: nil
        )
        stateMachine.recognize(payload: payload)
    }
}

// `recognize(payload:)` lives in `CaptureStateMachine+Barcode.swift`
// (renamed to +Recognize internally) — shared between Sprint 1.3 (barcode)
// and Sprint 1.4 (voice). Removed from this file to avoid duplicate-
// symbol link error.
#if false  // historical reference — kept compiled-out for grep discoverability
extension CaptureStateMachine {
    func recognize(payload: CapturePayload) {
        switch state {
        case .scanning, .idle:
            state = .confirming(payload)
        default:
            break
        }
    }
}
#endif
