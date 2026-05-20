// VoiceMemoCaptureView.swift — App/Views/Capture
// Copyright 2026 sunghun.ahn — Still Hours
// Sprint 1.4 — VoiceMemoCaptureView + SFSpeechRecognizer (ko/en/ja)
// Created: 2026-05-21
// R11.4: Liquid Glass uniformly tinted via .shGlass() — Design-R11 §8.
//
// Localization keys used in this file:
//   "capture.voice.holdToRecord"   — VoiceOver label + status idle
//   "capture.voice.recording"      — status during active recording
//   "capture.voice.locale.ko"      — locale picker label Korean
//   "capture.voice.locale.en"      — locale picker label English
//   "capture.voice.locale.ja"      — locale picker label Japanese
//   "capture.voice.privacyBanner"  — on-device only banner
//   "capture.voice.permissionMic"  — mic permission denied notice
//   "capture.voice.permissionSpeech" — speech permission denied notice

import SwiftUI
import AVFoundation
import Speech

// MARK: - VoiceLocale

/// The three supported recognition locales. Drives SFSpeechRecognizer init.
enum VoiceLocale: String, CaseIterable, Identifiable {
    case ko = "ko-KR"
    case en = "en-US"
    case ja = "ja-JP"

    var id: String { rawValue }

    var locale: Locale { Locale(identifier: rawValue) }

    func label() -> String {
        switch self {
        case .ko: return String(localized: "capture.voice.locale.ko", defaultValue: "한국어")
        case .en: return String(localized: "capture.voice.locale.en", defaultValue: "English")
        case .ja: return String(localized: "capture.voice.locale.ja", defaultValue: "日本語")
        }
    }

    /// Maps a system locale's language code to a VoiceLocale, defaulting to `.en`.
    static func from(systemLocale: Locale) -> VoiceLocale {
        let code = systemLocale.language.languageCode?.identifier ?? "en"
        switch code {
        case "ko": return .ko
        case "ja": return .ja
        default:   return .en
        }
    }
}

// MARK: - RecordingPhase

private enum RecordingPhase: Equatable {
    case idle
    case permissionDenied(String)
    case recording
    case processing
}

// MARK: - VoiceMemoCaptureView

/// Press-and-hold mic button → SFSpeechRecognizer on-device transcription → fires `onTranscribed`.
///
/// Locale-aware: detects ko/en/ja from `Locale.current`; user can override via segmented control.
/// All audio processing is strictly on-device (PRD §7.8 / Privacy §12.3).
@MainActor
struct VoiceMemoCaptureView: View {

    // MARK: Input

    /// Fires with the final transcript string when the user releases the hold button.
    let onTranscribed: (String) -> Void

    // MARK: State

    @State private var selectedLocale: VoiceLocale = VoiceLocale.from(systemLocale: Locale.current)
    @State private var phase: RecordingPhase = .idle
    @State private var liveTranscript: String = ""
    @State private var service = SpeechRecognitionService()
    @State private var streamTask: Task<Void, Never>?

    // MARK: Environment

    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    // MARK: Body

    var body: some View {
        VStack(spacing: 20) {
            localePicker
            Spacer()
            micButtonArea
            Spacer()
            privacyBanner
        }
        .padding(.horizontal, 24)
        .padding(.vertical, 16)
    }

    // MARK: Locale picker

    private var localePicker: some View {
        Picker("", selection: $selectedLocale) {
            ForEach(VoiceLocale.allCases) { vl in
                Text(vl.label()).tag(vl)
            }
        }
        .pickerStyle(.segmented)
        .accessibilityLabel("Speech recognition language")
    }

    // MARK: Mic button + transcript area

    @ViewBuilder
    private var micButtonArea: some View {
        switch phase {
        case .permissionDenied(let resource):
            permissionDeniedView(resource: resource)
        default:
            VStack(spacing: 16) {
                holdMicButton
                liveTranscriptView
                statusLabel
            }
        }
    }

    // MARK: Hold mic button

    private var holdMicButton: some View {
        let isRecording = (phase == .recording)
        return GlassEffectContainer {
            ZStack {
                RoundedRectangle(cornerRadius: 22)
                    .fill(.clear)
                    .frame(width: 88, height: 88)
                Image(systemName: isRecording ? "waveform.circle.fill" : "mic.fill")
                    .font(.system(size: 36))
                    .foregroundStyle(isRecording ? Color.red : Color.primary)
                    .symbolEffect(.pulse, isActive: isRecording && !reduceMotion)
                    .contentTransition(.symbolEffect(.replace))
            }
        }
        .frame(width: 88, height: 88)
        .shGlass(in: RoundedRectangle(cornerRadius: 22))
        .scaleEffect(isRecording ? 1.05 : 1.0)
        .animation(reduceMotion ? nil : .spring(duration: 0.2), value: isRecording)
        .gesture(
            DragGesture(minimumDistance: 0)
                .onChanged { _ in
                    if phase == .idle { beginRecording() }
                }
                .onEnded { _ in
                    if phase == .recording { endRecording() }
                }
        )
        .accessibilityLabel(
            String(
                localized: "capture.voice.holdToRecord",
                defaultValue: "Hold to record voice memo"
            )
        )
        .accessibilityHint(
            String(
                localized: "capture.voice.holdToRecord",
                defaultValue: "Hold to record voice memo"
            )
        )
        .accessibilityAddTraits(.isButton)
    }

    // MARK: Live transcript

    @ViewBuilder
    private var liveTranscriptView: some View {
        if !liveTranscript.isEmpty {
            Text(liveTranscript)
                .font(.body)
                .foregroundStyle(.primary)
                .multilineTextAlignment(.center)
                .lineLimit(4)
                .contentTransition(.numericText())
                .animation(.easeInOut(duration: 0.15), value: liveTranscript)
                .accessibilityLabel(
                    String(
                        localized: "capture.voice.transcript.label",
                        defaultValue: "Recognised text: \(liveTranscript)"
                    )
                )
        }
    }

    // MARK: Status label

    private var statusLabel: some View {
        Text(statusText)
            .font(.caption)
            .foregroundStyle(.secondary)
            .animation(.easeInOut, value: phase)
    }

    private var statusText: String {
        switch phase {
        case .recording:
            return String(localized: "capture.voice.recording", defaultValue: "Recording…")
        case .processing:
            return String(localized: "capture.voice.processing", defaultValue: "Processing…")
        default:
            return String(localized: "capture.voice.holdToRecord", defaultValue: "Hold to record voice memo")
        }
    }

    // MARK: Permission denied view

    private func permissionDeniedView(resource: String) -> some View {
        VStack(spacing: 12) {
            Image(systemName: "mic.slash")
                .font(.system(size: 44))
                .foregroundStyle(.secondary)
            Text(resource)
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
            Button(
                String(
                    localized: "capture.error.open_settings",
                    defaultValue: "Open Settings"
                )
            ) {
                if let url = URL(string: UIApplication.openSettingsURLString) {
                    UIApplication.shared.open(url)
                }
            }
            .buttonStyle(.glass)
        }
        .padding()
    }

    // MARK: Privacy banner

    private var privacyBanner: some View {
        Text(
            String(
                localized: "capture.voice.privacyBanner",
                defaultValue: "Voice processed on-device only"
            )
        )
        .font(.caption2)
        .foregroundStyle(.tertiary)
        .multilineTextAlignment(.center)
    }

    // MARK: Recording lifecycle

    private func beginRecording() {
        liveTranscript = ""
        streamTask = Task {
            do {
                let _ = try await service.requestPermissions()
                phase = .recording
                AccessibilityNotification.Announcement(
                    String(localized: "capture.voice.recording", defaultValue: "Recording…")
                ).post()
                let stream = try await service.startRecording(locale: selectedLocale.locale)
                for await result in stream {
                    liveTranscript = result.transcript
                    if result.isFinal {
                        phase = .idle
                        if !result.transcript.isEmpty {
                            onTranscribed(result.transcript)
                        }
                        break
                    }
                }
            } catch SpeechRecognitionError.permissionDenied {
                let msg = String(
                    localized: "capture.voice.permissionMic",
                    defaultValue: "Microphone permission required"
                )
                phase = .permissionDenied(msg)
                AccessibilityNotification.Announcement(msg).post()
            } catch {
                phase = .idle
            }
        }
    }

    private func endRecording() {
        phase = .processing
        Task {
            let _ = try? await service.stopRecording()
            // Final transcript delivered via stream — phase resets in beginRecording's loop
        }
    }
}
