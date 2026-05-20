// CaptureStateMachine+Recognize.swift — App/Views/Capture
// Copyright 2026 sunghun.ahn — Still Hours
// Sprints 1.3 + 1.4 — Shared state machine extension used by both
// Barcode and Voice coordinators. Filename retained for git-history
// continuity (originally `+Barcode.swift` in Sprint 1.3); contents now
// cover both recognition sources to avoid duplicate-symbol link errors.
// Created: 2026-05-21

import Foundation

// MARK: - CaptureStateMachine + Recognize

extension CaptureStateMachine {

    /// Transition `.scanning(_)` or `.idle` → `.confirming(payload)`.
    ///
    /// Called by `BarcodeCaptureCoordinator` (after a successful ISBN
    /// lookup) and `VoiceCaptureCoordinator` (after a successful
    /// transcription). The accepted prior states intentionally include
    /// `.idle` so a coordinator can be presented standalone without
    /// having to drive an artificial `.scanning(...)` transition first.
    ///
    /// All other states are silently ignored — recognition arriving
    /// after the user already dismissed must not overwrite a later
    /// `.confirming`, `.saving`, or `.done`.
    public func recognize(payload: CapturePayload) {
        switch state {
        case .scanning, .idle, .recognized:
            state = .confirming(payload)
        default:
            break
        }
    }
}
