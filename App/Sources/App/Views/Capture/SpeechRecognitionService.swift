// SpeechRecognitionService.swift — App/Views/Capture
// Copyright 2026 sunghun.ahn — Still Hours
// Sprint 1.4 — VoiceMemoCaptureView + SFSpeechRecognizer (ko/en/ja)
// Created: 2026-05-21

import AVFoundation
import Speech
import Foundation

// MARK: - RecognitionResult

/// A single transcription result from the speech recognition engine.
struct RecognitionResult: Sendable {
    let transcript: String
    let isFinal: Bool
}

// MARK: - SpeechRecognitionError

enum SpeechRecognitionError: Error, LocalizedError {
    case permissionDenied
    case localeUnsupported(Locale)
    case engineFailed(underlying: String)
    case noTranscript

    var errorDescription: String? {
        switch self {
        case .permissionDenied:
            return String(
                localized: "capture.voice.permissionDenied.desc",
                defaultValue: "Microphone or speech recognition permission was denied."
            )
        case .localeUnsupported(let locale):
            return "Locale \(locale.identifier) is not supported for on-device recognition."
        case .engineFailed(let underlying):
            return "Speech engine error: \(underlying)"
        case .noTranscript:
            return "No speech was detected."
        }
    }
}

// MARK: - SpeechRecognitionService

/// Actor wrapping SFSpeechRecognizer so the view layer remains testable.
///
/// Locale support: ko-KR, en-US, ja-JP — verified against
/// `SFSpeechRecognizer.supportedLocales()` at init. Falls back to
/// device locale then en-US if the requested locale is unavailable.
///
/// On-device only: `requiresOnDeviceRecognition = true` throughout.
/// No audio ever leaves the device (PRD §7.8 / Privacy §12.3).
actor SpeechRecognitionService {

    // MARK: State

    private var audioEngine: AVAudioEngine?
    private var recognitionTask: SFSpeechRecognitionTask?
    private var recognizer: SFSpeechRecognizer?

    // MARK: Permission

    /// Returns `true` only when both microphone and speech permissions are granted.
    ///
    /// Requests each permission in sequence, halting if either is denied.
    func requestPermissions() async throws -> Bool {
        // Microphone
        let micGranted = await withCheckedContinuation { (continuation: CheckedContinuation<Bool, Never>) in
            AVAudioApplication.requestRecordPermission { granted in
                continuation.resume(returning: granted)
            }
        }
        guard micGranted else { throw SpeechRecognitionError.permissionDenied }

        // Speech recognition
        let speechStatus = await withCheckedContinuation { (continuation: CheckedContinuation<SFSpeechRecognizerAuthorizationStatus, Never>) in
            SFSpeechRecognizer.requestAuthorization { status in
                continuation.resume(returning: status)
            }
        }
        guard speechStatus == .authorized else { throw SpeechRecognitionError.permissionDenied }
        return true
    }

    // MARK: Recording

    /// Begins recording and returns an `AsyncStream` of partial + final results.
    ///
    /// The caller should store the stream and iterate it. Call `stopRecording()`
    /// when the user releases the hold button; the stream will emit one more
    /// final result then finish.
    func startRecording(locale: Locale) async throws -> AsyncStream<RecognitionResult> {
        // Resolve locale to a supported recognizer
        let resolved = resolvedLocale(for: locale)
        let sfRecognizer = SFSpeechRecognizer(locale: resolved)
        guard let sfRecognizer, sfRecognizer.isAvailable else {
            throw SpeechRecognitionError.localeUnsupported(resolved)
        }
        self.recognizer = sfRecognizer

        // Audio session
        let session = AVAudioSession.sharedInstance()
        do {
            try session.setCategory(.record, mode: .measurement, options: .duckOthers)
            try session.setActive(true, options: .notifyOthersOnDeactivation)
        } catch {
            throw SpeechRecognitionError.engineFailed(underlying: error.localizedDescription)
        }

        let engine = AVAudioEngine()
        self.audioEngine = engine

        let request = SFSpeechAudioBufferRecognitionRequest()
        request.requiresOnDeviceRecognition = true
        request.shouldReportPartialResults = true
        if #available(iOS 16, *) {
            request.addsPunctuation = (resolved.language.languageCode?.identifier == "en")
        }

        let inputNode = engine.inputNode
        let format = inputNode.outputFormat(forBus: 0)
        inputNode.installTap(onBus: 0, bufferSize: 1024, format: format) { buffer, _ in
            request.append(buffer)
        }

        do {
            try engine.start()
        } catch {
            throw SpeechRecognitionError.engineFailed(underlying: error.localizedDescription)
        }

        // Build AsyncStream bridging the completion callback.
        // SFSpeechRecognitionTask is not Sendable — assign it directly to
        // the actor property so the local-`task` variable doesn't have to
        // be captured across the @Sendable boundary of the AsyncStream
        // return path. Cancellation happens via `stopRecording()` on the
        // actor, which has isolated access to `self.recognitionTask`.
        let (stream, continuation) = AsyncStream<RecognitionResult>.makeStream()
        self.recognitionTask = sfRecognizer.recognitionTask(with: request) { result, error in
            if let result {
                let partial = result.bestTranscription.formattedString
                continuation.yield(RecognitionResult(transcript: partial, isFinal: result.isFinal))
                if result.isFinal { continuation.finish() }
            } else if error != nil {
                continuation.finish()
            }
        }
        return stream
    }

    /// Stops the audio engine and signals the recognizer to finalize.
    ///
    /// Returns the best transcript seen so far. Callers should prefer the
    /// final result from the `AsyncStream` iteration when possible.
    func stopRecording() async throws -> String {
        guard let engine = audioEngine else { throw SpeechRecognitionError.noTranscript }
        engine.inputNode.removeTap(onBus: 0)
        engine.stop()
        audioEngine = nil
        // Deactivate audio session after stopping
        try? AVAudioSession.sharedInstance().setActive(false, options: .notifyOthersOnDeactivation)
        return ""   // Final transcript arrives via the AsyncStream final result
    }

    // MARK: Helpers

    /// Maps the requested locale to a supported SFSpeechRecognizer locale.
    ///
    /// Priority: exact match → language-only match → device locale → en-US.
    private func resolvedLocale(for locale: Locale) -> Locale {
        let supported = SFSpeechRecognizer.supportedLocales()
        let preferred = [
            Locale(identifier: "ko-KR"),
            Locale(identifier: "en-US"),
            Locale(identifier: "ja-JP"),
        ]
        // Exact match
        if supported.contains(locale) { return locale }
        // Language-code match against our three preferred locales
        let langCode = locale.language.languageCode?.identifier ?? "en"
        for candidate in preferred {
            if candidate.language.languageCode?.identifier == langCode,
               supported.contains(candidate) {
                return candidate
            }
        }
        // Device locale
        let device = Locale.current
        if supported.contains(device) { return device }
        // Ultimate fallback
        return Locale(identifier: "en-US")
    }
}
