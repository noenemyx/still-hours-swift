// CaptureSheet.swift — App/Views/Capture
// Copyright 2026 sunghun.ahn — Still Hours
// Sprint 1.1 — CaptureSheet shell + state machine + manual mode
// Created: 2026-05-21
//
// Localization keys used in this file:
//   "capture.title"        — toolbar title
//   "capture.close"        — close button accessibility label
//   "capture.save"         — save button label
//   "capture.mode.barcode" — barcode mode button label
//   "capture.mode.voice"   — voice mode button label
//   "capture.mode.manual"  — manual mode button label
//   "capture.coming.1_3"   — "Coming in Sprint 1.3" stub text
//   "capture.coming.1_4"   — "Coming in Sprint 1.4" stub text
//   "capture.status.saving" — saving in-progress message
//   "capture.status.done"  — success message
//   "capture.status.failed" — failure message prefix

import SwiftUI
import SwiftData
import InventoryCore

// MARK: - CaptureSheet

@MainActor
struct CaptureSheet: View {

    // MARK: Dependencies

    @StateObject private var machine: CaptureStateMachine

    // MARK: Environment

    @Environment(\.dismiss) private var dismiss
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    // MARK: Local state

    @State private var selectedMode: CaptureMode = .manual
    @State private var payload: CapturePayload = .empty

    // MARK: Init

    init(library: LibraryService) {
        _machine = StateObject(wrappedValue: CaptureStateMachine(library: library))
    }

    // MARK: Body

    var body: some View {
        NavigationStack {
            ZStack(alignment: .bottom) {
                contentArea
                    .ignoresSafeArea(.keyboard, edges: .bottom)

                bottomActionBar
                    .padding(.horizontal, 16)
                    .padding(.bottom, 24)
            }
            .navigationTitle(String(localized: "capture.title", defaultValue: "Capture"))
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button {
                        machine.cancel()
                        dismiss()
                    } label: {
                        Image(systemName: "xmark")
                    }
                    .buttonStyle(.glass)
                    .accessibilityLabel(String(localized: "capture.close", defaultValue: "Close"))
                    .accessibilityHint("Cancels capture and discards input.")
                }
                ToolbarItem(placement: .confirmationAction) {
                    modeSwitcher
                }
            }
        }
        .presentationDetents([.medium, .large])
        .presentationDragIndicator(.visible)
        .onChange(of: machine.state) { _, newState in
            announceStateChange(newState)
            if case .done = newState {
                dismiss()
            }
        }
        .onAppear {
            machine.start(mode: .manual)
        }
    }

    // MARK: Content area

    @ViewBuilder
    private var contentArea: some View {
        switch machine.state {
        case .confirming(let current):
            ManualCaptureView(payload: current) { confirmed in
                payload = confirmed
            }
            .transition(reduceMotion ? .identity : .opacity)

        case .saving:
            VStack(spacing: 12) {
                ProgressView()
                Text(String(localized: "capture.status.saving", defaultValue: "Saving…"))
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)

        case .failed(let failure):
            VStack(spacing: 8) {
                Image(systemName: "exclamationmark.triangle")
                    .font(.largeTitle)
                    .foregroundStyle(.orange)
                Text(failure.localizedDescription)
                    .font(.body)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
                Button(String(localized: "capture.retry", defaultValue: "Try Again")) {
                    machine.start(mode: selectedMode)
                }
                .buttonStyle(.glass)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)

        case .scanning(let mode):
            stubView(for: mode)

        default:
            Color.clear
        }
    }

    // MARK: Stub views for unimplemented modes

    @ViewBuilder
    private func stubView(for mode: CaptureMode) -> some View {
        VStack(spacing: 12) {
            Image(systemName: mode == .barcode ? "barcode.viewfinder" : "mic.fill")
                .font(.system(size: 48))
                .foregroundStyle(.secondary)
            Text(
                mode == .barcode
                    ? String(localized: "capture.coming.1_3", defaultValue: "Coming in Sprint 1.3")
                    : String(localized: "capture.coming.1_4", defaultValue: "Coming in Sprint 1.4")
            )
            .font(.headline)
            .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    // MARK: Mode switcher (trailing toolbar)

    private var modeSwitcher: some View {
        GlassEffectContainer {
            HStack(spacing: 4) {
                ForEach(CaptureMode.allCases, id: \.self) { mode in
                    Button {
                        selectedMode = mode
                        machine.start(mode: mode)
                    } label: {
                        Image(systemName: modeSymbol(mode))
                            .imageScale(.medium)
                    }
                    .buttonStyle(.glass)
                    .accessibilityLabel(modeLabel(mode))
                    .accessibilityHint(modeHint(mode))
                }
            }
        }
    }

    // MARK: Bottom action bar

    private var bottomActionBar: some View {
        GlassEffectContainer {
            HStack(spacing: 8) {
                Button(String(localized: "capture.close", defaultValue: "Close")) {
                    machine.cancel()
                    dismiss()
                }
                .buttonStyle(.glass)

                Spacer()

                if case .confirming = machine.state {
                    Button(String(localized: "capture.save", defaultValue: "Save")) {
                        Task { await machine.submit(payload: payload) }
                    }
                    .buttonStyle(.glassProminent)
                    .disabled(payload.title.trimmingCharacters(in: .whitespaces).isEmpty)
                    .accessibilityLabel(String(localized: "capture.save", defaultValue: "Save"))
                    .accessibilityHint("Adds item to your collection.")
                }
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
        }
    }

    // MARK: Accessibility announcements

    private func announceStateChange(_ state: CaptureState) {
        let message: String
        switch state {
        case .saving:
            message = String(localized: "capture.status.saving", defaultValue: "Saving…")
        case .done:
            message = String(localized: "capture.status.done", defaultValue: "Saved.")
        case .failed:
            message = String(localized: "capture.status.failed", defaultValue: "Save failed.")
        default:
            return
        }
        AccessibilityNotification.Announcement(message).post()
    }

    // MARK: Helpers

    private func modeSymbol(_ mode: CaptureMode) -> String {
        switch mode {
        case .barcode: return "barcode.viewfinder"
        case .voice:   return "mic.fill"
        case .manual:  return "keyboard"
        }
    }

    private func modeLabel(_ mode: CaptureMode) -> String {
        switch mode {
        case .barcode: return String(localized: "capture.mode.barcode", defaultValue: "Barcode Scan")
        case .voice:   return String(localized: "capture.mode.voice",   defaultValue: "Voice Input")
        case .manual:  return String(localized: "capture.mode.manual",  defaultValue: "Manual Input")
        }
    }

    private func modeHint(_ mode: CaptureMode) -> String {
        switch mode {
        case .barcode: return "Scans a barcode with the camera."
        case .voice:   return "Recognises item title by voice."
        case .manual:  return "Switches to manual entry form."
        }
    }
}

// MARK: - CaptureFailure + description

extension CaptureFailure: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .notImplemented(let mode):
            return "Mode \(mode.rawValue) is not yet implemented."
        case .permissionDenied(let resource):
            return "\(resource.capitalized) access is required."
        case .invalidInput(let field):
            return "Invalid input for field \"\(field)\"."
        case .persistFailed(let detail):
            return "Save failed: \(detail)"
        }
    }
}
