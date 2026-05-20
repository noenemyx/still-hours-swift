// CaptureStateTests.swift — App/Tests/AppTests
// Copyright 2026 sunghun.ahn — Still Hours
// Sprint 1.1 — CaptureSheet shell + state machine + manual mode
// Created: 2026-05-21

import Testing
import SwiftData
import Foundation
@testable import StillHours
import InventoryCore

// MARK: - Stub LibraryService

/// In-memory ModelContext LibraryService for unit tests.
@available(iOS 26, macOS 26, *)
private func makeTestLibrary() throws -> LibraryService {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try ModelContainer(
        for: Item.self, Memory.self, InventoryCore.Collection.self, InventoryCore.Attachment.self,
        configurations: config
    )
    return LibraryService(context: ModelContext(container))
}

// MARK: - CaptureStateTests

@available(iOS 26, macOS 26, *)
@Suite("CaptureStateMachine")
struct CaptureStateTests {

    // MARK: 1. start(.manual) → .confirming(.empty)

    @Test("start(.manual) transitions to confirming with empty payload")
    @MainActor
    func startManualGoesToConfirming() throws {
        let library = try makeTestLibrary()
        let machine = CaptureStateMachine(library: library)

        machine.start(mode: .manual)

        guard case .confirming(let payload) = machine.state else {
            Issue.record("Expected .confirming, got \(machine.state)")
            return
        }
        #expect(payload == .empty)
    }

    // MARK: 2. cancel from .confirming → .idle

    @Test("cancel from confirming returns to idle")
    @MainActor
    func cancelFromConfirmingGoesToIdle() throws {
        let library = try makeTestLibrary()
        let machine = CaptureStateMachine(library: library)

        machine.start(mode: .manual)
        #expect(machine.state != .idle)

        machine.cancel()
        #expect(machine.state == .idle)
    }

    // MARK: 3. submit valid payload → .saving → .done

    @Test("submit valid payload transitions through saving to done")
    @MainActor
    func submitValidPayloadReachesDone() async throws {
        let library = try makeTestLibrary()
        let machine = CaptureStateMachine(library: library)

        machine.start(mode: .manual)

        let payload = CapturePayload(title: "Norwegian Wood", medium: .book, creator: "Murakami")
        await machine.submit(payload: payload)

        guard case .done = machine.state else {
            Issue.record("Expected .done, got \(machine.state)")
            return
        }
    }

    // MARK: 4. submit empty title → .failed (state machine guard)

    @Test("submit with empty title results in failed state")
    @MainActor
    func submitEmptyTitleFails() async throws {
        let library = try makeTestLibrary()
        let machine = CaptureStateMachine(library: library)

        machine.start(mode: .manual)

        let emptyPayload = CapturePayload(title: "   ", medium: .book)
        await machine.submit(payload: emptyPayload)

        guard case .failed(let failure) = machine.state else {
            Issue.record("Expected .failed, got \(machine.state)")
            return
        }
        #expect(failure == .invalidInput("title"))
    }

    // MARK: 5. reset from .done → .idle

    @Test("reset from done returns to idle")
    @MainActor
    func resetFromDoneGoesToIdle() async throws {
        let library = try makeTestLibrary()
        let machine = CaptureStateMachine(library: library)

        machine.start(mode: .manual)
        let payload = CapturePayload(title: "Stoner", medium: .book)
        await machine.submit(payload: payload)

        guard case .done = machine.state else {
            Issue.record("Precondition: expected .done")
            return
        }

        machine.reset()
        #expect(machine.state == .idle)
    }

    // MARK: 6. CaptureFailure.permissionDenied equality

    @Test("CaptureFailure.permissionDenied equates on associated value")
    func captureFailurePermissionDeniedEquality() {
        let a = CaptureFailure.permissionDenied("camera")
        let b = CaptureFailure.permissionDenied("camera")
        let c = CaptureFailure.permissionDenied("microphone")

        #expect(a == b)
        #expect(a != c)
    }
}
