// CaptureState.swift — App/Views/Capture
// Copyright 2026 sunghun.ahn — Still Hours
// Sprint 1.1 — CaptureSheet shell + state machine + manual mode
// Created: 2026-05-21

import Foundation
import SwiftData
import InventoryCore

// MARK: - CaptureMode

/// The three capture entry modes. Only `.manual` is implemented in Sprint 1.1.
/// `.barcode` and `.voice` arrive in Sprints 1.3 and 1.4 respectively.
public enum CaptureMode: String, CaseIterable, Sendable {
    case barcode
    case voice
    case manual
}

// MARK: - CaptureFailure

public enum CaptureFailure: Error, Equatable, Sendable {
    case notImplemented(CaptureMode)
    case permissionDenied(String)
    case invalidInput(String)
    case persistFailed(String)
}

// MARK: - CapturePayload

/// Validated data collected by any capture mode before persisting.
public struct CapturePayload: Sendable, Equatable {
    public var title: String
    public var medium: Medium
    public var creator: String?
    public var coverImageData: Data?
    public var year: Int?
    public var isbn: String?

    public init(
        title: String = "",
        medium: Medium = .book,
        creator: String? = nil,
        coverImageData: Data? = nil,
        year: Int? = nil,
        isbn: String? = nil
    ) {
        self.title = title
        self.medium = medium
        self.creator = creator
        self.coverImageData = coverImageData
        self.year = year
        self.isbn = isbn
    }

    /// Convenience empty payload — used as the starting state for manual mode.
    public static let empty = CapturePayload()
}

// MARK: - CaptureState

public enum CaptureState: Equatable, Sendable {
    /// Sheet is open; no mode has been started.
    case idle
    /// Scanning / recording in progress (barcode / voice — Sprint 1.3/1.4 stubs).
    case scanning(CaptureMode)
    /// Raw input recognized; metadata may be pre-filled.
    case recognized(CapturePayload)
    /// User is reviewing / editing payload before saving.
    case confirming(CapturePayload)
    /// SwiftData write in progress.
    case saving
    /// Item persisted successfully.
    case done(itemID: PersistentIdentifier)
    /// Terminal error state.
    case failed(CaptureFailure)
}

// MARK: - CaptureStateMachine

/// Main-actor state machine driving `CaptureSheet`.
///
/// Inject `LibraryService` at init for testability — no environment key required.
@MainActor
public final class CaptureStateMachine: ObservableObject {

    // MARK: Published state

    @Published public private(set) var state: CaptureState = .idle

    // MARK: Dependencies

    private let library: LibraryService

    // MARK: Init

    public init(library: LibraryService) {
        self.library = library
    }

    // MARK: Transitions

    /// Start a capture session in the given mode.
    ///
    /// - For `.manual`: immediately jumps to `.confirming(.empty)` so the form appears.
    /// - For `.barcode` / `.voice`: transitions to `.scanning(mode)` (Sprint 1.3/1.4 stubs).
    public func start(mode: CaptureMode) {
        switch mode {
        case .manual:
            state = .confirming(.empty)
        case .barcode, .voice:
            state = .scanning(mode)
        }
    }

    /// Submit a validated payload — transitions confirming → saving → done.
    ///
    /// Validation is enforced in the view layer; the state machine trusts a
    /// non-empty title in the payload. Callers should not invoke this with an
    /// empty-title payload.
    public func submit(payload: CapturePayload) async {
        guard case .confirming = state else { return }

        let trimmed = payload.title.trimmingCharacters(in: .whitespaces)
        guard !trimmed.isEmpty else {
            state = .failed(.invalidInput("title"))
            return
        }

        state = .saving

        let item = Item(
            title: trimmed,
            creator: payload.creator.flatMap { $0.isEmpty ? nil : $0 },
            year: payload.year,
            medium: payload.medium,
            coverImageData: payload.coverImageData
        )

        let firstMemory = Memory(kind: .acquired)

        do {
            try await library.addItem(item)
            try await library.attachMemory(firstMemory, to: item)
            state = .done(itemID: item.persistentModelID)
        } catch {
            state = .failed(.persistFailed(error.localizedDescription))
        }
    }

    /// Cancel — returns to idle from any pre-save state.
    public func cancel() {
        switch state {
        case .saving, .done:
            return  // too late or already succeeded; caller should dismiss
        default:
            state = .idle
        }
    }

    /// Reset to idle after `.done` or `.failed`.
    public func reset() {
        state = .idle
    }
}
