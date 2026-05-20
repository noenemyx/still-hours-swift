// ServiceError.swift — InventoryCore/Services
// Copyright 2026 sunghun.ahn — Still Hours v0.1 MVP
// Pre-flight Round 4: InventoryService layer
// Created: 2026-05-20
// LINT-IGNORE: Privacy — no external URL

import Foundation

// MARK: - ServiceError

/// Typed errors propagated from all InventoryCore service actors.
///
/// All cases are `Sendable` — safe to cross actor boundaries and
/// capture in `async throws` call sites.
public enum ServiceError: Error, Sendable, LocalizedError {

    /// The requested entity could not be found in the store.
    case notFound

    /// The caller supplied invalid input. The associated value names the field.
    case invalidInput(String)

    /// A SwiftData insertion, update, or deletion failed.
    ///
    /// The underlying `Error` from `ModelContext.save()` is wrapped here.
    /// `@unchecked Sendable` is not used; callers should not introspect
    /// the underlying error beyond logging.
    case persistFailed(underlying: any Error)

    /// JSON / CSV encoding produced no output.
    case encodingFailed

    /// Import decoding encountered unexpected data.
    case decodingFailed

    /// The requested capability is not yet implemented in this build.
    ///
    /// Used by ``CaptureService`` stubs that defer to the App layer.
    case notImplemented

    // MARK: LocalizedError

    public var errorDescription: String? {
        switch self {
        case .notFound:
            return NSLocalizedString(
                "service.error.notFound",
                value: "The requested item could not be found.",
                comment: "ServiceError.notFound"
            )
        case .invalidInput(let field):
            return String(
                format: NSLocalizedString(
                    "service.error.invalidInput",
                    value: "Invalid input for field \"%@\".",
                    comment: "ServiceError.invalidInput — %@ is the field name"
                ),
                field
            )
        case .persistFailed:
            return NSLocalizedString(
                "service.error.persistFailed",
                value: "The change could not be saved. Please try again.",
                comment: "ServiceError.persistFailed"
            )
        case .encodingFailed:
            return NSLocalizedString(
                "service.error.encodingFailed",
                value: "Export encoding failed.",
                comment: "ServiceError.encodingFailed"
            )
        case .decodingFailed:
            return NSLocalizedString(
                "service.error.decodingFailed",
                value: "Import decoding failed.",
                comment: "ServiceError.decodingFailed"
            )
        case .notImplemented:
            return NSLocalizedString(
                "service.error.notImplemented",
                value: "This feature is not yet available.",
                comment: "ServiceError.notImplemented"
            )
        }
    }
}
