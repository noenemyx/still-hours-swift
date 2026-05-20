// CaptureService.swift — InventoryCore/Services
// Copyright 2026 sunghun.ahn — Still Hours v0.1 MVP
// Pre-flight Round 4: InventoryService layer
// Created: 2026-05-20
// LINT-IGNORE: Privacy — no external URL

import Foundation

// MARK: - CaptureResult

/// The outcome of a ``CaptureService`` recognition pass.
///
/// Both cases are `Sendable` — safe to return across actor boundaries
/// and store in SwiftUI state.
public enum CaptureResult: Sendable {

    /// Recognition succeeded; the associated ``CapturePayload`` contains
    /// the extracted fields ready for ``LibraryService/addItem(_:)``.
    case success(CapturePayload)

    /// Recognition failed or is not yet implemented.
    case failure(CaptureFailureReason)
}

// MARK: - CapturePayload

/// Structured data extracted from a successful capture.
///
/// Optional fields reflect the varying completeness of barcode / voice
/// data sources. Callers should present an edit form so the user can
/// confirm before persisting.
public struct CapturePayload: Sendable {
    /// Recognised title (book name, album title, …).
    public var title: String
    /// Recognised creator credit (author, artist, director, …).
    public var creator: String?
    /// Detected medium type.
    public var medium: Medium?
    /// Release year extracted from barcode metadata.
    public var year: Int?
    /// Raw transcript of a voice memo, before NLP processing.
    public var voiceTranscript: String?

    public init(
        title: String,
        creator: String? = nil,
        medium: Medium? = nil,
        year: Int? = nil,
        voiceTranscript: String? = nil
    ) {
        self.title = title
        self.creator = creator
        self.medium = medium
        self.year = year
        self.voiceTranscript = voiceTranscript
    }
}

// MARK: - CaptureFailureReason

/// Specific reason a capture pass failed.
public enum CaptureFailureReason: Sendable {
    /// No barcode was detected in the supplied image.
    case noBarcodeDetected
    /// The barcode was detected but no catalogue match was found.
    case noMatchFound
    /// Audio was too quiet or corrupted to transcribe.
    case audioQualityInsufficient
    /// Feature not yet implemented (stub response).
    case notImplemented
}

// MARK: - CaptureService

/// Actor-isolated stub for barcode and voice-memo recognition.
///
/// All real implementation is deferred to the App layer, where
/// AVFoundation and the Speech framework are available without
/// special entitlements in the Swift package manifest.
///
/// Consumers should gate on ``CaptureResult/success(_:)`` and display
/// a confirmation form before calling ``LibraryService/addItem(_:)``.
///
/// - Important: Both methods currently return `.failure(.notImplemented)`.
///   Wire the App-layer concrete implementation via a protocol extension
///   or subclass pattern once the Still Hours App target is created.
///
/// WORKAROUND: Stub interface only — real implementation deferred to App layer.
/// Root cause: AVFoundation / Speech framework requires App target entitlements.
/// Proper fix: Protocol-based injection from App target into this actor.
/// Expiry: Still Hours v0.3 (Capture milestone — PRD §7).
@available(iOS 26, macOS 26, *)
public actor CaptureService {

    // MARK: Initialiser

    public init() {}

    // MARK: Barcode Capture

    /// Attempts to detect and resolve a barcode in the supplied image data.
    ///
    /// - Parameter image: Raw JPEG/PNG/HEIC bytes captured from the camera.
    /// - Returns: A ``CaptureResult`` describing success or failure.
    ///
    /// Currently returns `.failure(.notImplemented)`.
    /// Real implementation: VisionKit barcode detection → Open Library / MusicBrainz lookup.
    public func captureBarcode(image: Data) async -> CaptureResult {
        // WORKAROUND: stub — see type-level documentation.
        return .failure(.notImplemented)
    }

    // MARK: Voice Memo Capture

    /// Transcribes and parses a voice memo to extract item metadata.
    ///
    /// - Parameter audioURL: URL of a recorded audio file in the app container.
    /// - Returns: A ``CaptureResult`` describing success or failure.
    ///
    /// Currently returns `.failure(.notImplemented)`.
    /// Real implementation: SFSpeechRecognizer → NLP title/creator extraction.
    public func captureVoiceMemo(audioURL: URL) async -> CaptureResult {
        // WORKAROUND: stub — see type-level documentation.
        return .failure(.notImplemented)
    }
}
