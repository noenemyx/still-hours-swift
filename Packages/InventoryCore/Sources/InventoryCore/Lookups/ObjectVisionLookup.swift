// ObjectVisionLookup.swift — InventoryCore/Lookups
// Copyright 2026 sunghun.ahn — Still Hours
// R18 — On-device Vision framework for object/product photo identification
// Created: 2026-05-23
//
// Privacy: 100% on-device processing. No network calls in classification or OCR.
// Optional Wikipedia summary lookup is exposed as a separate explicit method
// (not invoked automatically) so the user controls when an external request is
// made. Wikipedia is already on the privacy-allowed host list.

import Foundation
import Vision
#if canImport(UIKit)
import UIKit
#endif

// MARK: - ObjectVisionResult

/// Top-level result of `ObjectVisionLookup.analyze(...)`.
///
/// Both fields can be empty: the photo might contain no recognizable text
/// (no brand) and might not match any high-confidence classification.
public struct ObjectVisionResult: Sendable, Equatable {
    /// Top image classifications (sorted by confidence, max 10).
    public let classifications: [VisionClassification]

    /// Text extracted from the image via OCR (sorted by position, top→bottom).
    public let recognizedText: [String]

    public init(classifications: [VisionClassification], recognizedText: [String]) {
        self.classifications = classifications
        self.recognizedText = recognizedText
    }
}

// MARK: - VisionClassification

public struct VisionClassification: Sendable, Equatable {
    public let label: String          // e.g. "chair", "camera", "fountain_pen"
    public let confidence: Float      // 0.0 – 1.0

    public init(label: String, confidence: Float) {
        self.label = label
        self.confidence = confidence
    }

    /// Human-friendly label: replaces underscores with spaces and capitalises.
    /// "fountain_pen" → "Fountain Pen"
    public var displayLabel: String {
        label.replacingOccurrences(of: "_", with: " ")
             .split(separator: " ")
             .map { $0.prefix(1).uppercased() + $0.dropFirst() }
             .joined(separator: " ")
    }
}

// MARK: - ObjectVisionLookup

/// On-device image analysis for object/product identification.
///
/// Uses Apple Vision framework — completely local, no server transmission.
/// Combines image classification (VNClassifyImageRequest) and optical
/// character recognition (VNRecognizeTextRequest) to extract a useful
/// starting point for the user to edit.
public actor ObjectVisionLookup {

    public init() {}

    // MARK: - Public API

    /// Analyze image data, returning classifications + OCR text.
    public func analyze(imageData: Data) async throws -> ObjectVisionResult {
        #if canImport(UIKit)
        guard let uiImage = UIImage(data: imageData),
              let cgImage = uiImage.cgImage else {
            throw ObjectVisionError.invalidImage
        }
        let orientation = cgImageOrientation(from: uiImage.imageOrientation)
        return try await analyze(cgImage: cgImage, orientation: orientation)
        #else
        throw ObjectVisionError.platformUnsupported
        #endif
    }

    /// Analyze a CGImage directly (test seam — bypasses UIImage).
    public func analyze(cgImage: CGImage, orientation: CGImagePropertyOrientation = .up) async throws -> ObjectVisionResult {
        let handler = VNImageRequestHandler(cgImage: cgImage, orientation: orientation, options: [:])

        let classifyRequest = VNClassifyImageRequest()
        let textRequest = VNRecognizeTextRequest()
        textRequest.recognitionLevel = .accurate
        textRequest.usesLanguageCorrection = false
        // Multi-language: Korean, English, Japanese (matches Wave 1 locales)
        textRequest.recognitionLanguages = ["ko-KR", "en-US", "ja-JP"]

        do {
            try handler.perform([classifyRequest, textRequest])
        } catch {
            throw ObjectVisionError.visionFailed(error.localizedDescription)
        }

        // Classifications: keep top-10 by confidence, filter very-low confidence
        let classifications: [VisionClassification] = (classifyRequest.results ?? [])
            .filter { $0.confidence >= 0.15 }
            .sorted { $0.confidence > $1.confidence }
            .prefix(10)
            .map { VisionClassification(label: $0.identifier, confidence: $0.confidence) }

        // OCR: collect strings from top→bottom by bounding-box Y midpoint
        let textObservations = textRequest.results ?? []
        let recognizedText: [String] = textObservations
            .compactMap { obs -> (String, CGFloat)? in
                guard let top = obs.topCandidates(1).first else { return nil }
                let yMid = obs.boundingBox.midY
                return (top.string, yMid)
            }
            // Vision Y is bottom-up (0=bottom, 1=top) → sort descending Y for top-first
            .sorted { $0.1 > $1.1 }
            .map(\.0)
            .filter { !$0.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty }

        return ObjectVisionResult(classifications: classifications, recognizedText: recognizedText)
    }

    // MARK: - Helpers

    #if canImport(UIKit)
    private nonisolated func cgImageOrientation(from uiOrientation: UIImage.Orientation) -> CGImagePropertyOrientation {
        switch uiOrientation {
        case .up:            return .up
        case .down:          return .down
        case .left:          return .left
        case .right:         return .right
        case .upMirrored:    return .upMirrored
        case .downMirrored:  return .downMirrored
        case .leftMirrored:  return .leftMirrored
        case .rightMirrored: return .rightMirrored
        @unknown default:    return .up
        }
    }
    #endif
}

// MARK: - ObjectVisionError

public enum ObjectVisionError: Error, Equatable, Sendable {
    case invalidImage
    case platformUnsupported
    case visionFailed(String)
}
