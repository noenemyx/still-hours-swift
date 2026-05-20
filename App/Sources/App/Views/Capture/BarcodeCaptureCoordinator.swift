// BarcodeCaptureCoordinator.swift — App/Views/Capture
// Copyright 2026 sunghun.ahn — Still Hours
// Sprint 1.3 — Barcode coordinator: BookMetadataLookup bridge + state transitions
// Created: 2026-05-21
//
// Localization keys used in this file:
//   "capture.barcode.prompt"         — scanning instruction
//   "capture.barcode.lookupFailed"   — generic lookup failure banner
//   "capture.barcode.notFound"       — ISBN not found banner
//   "capture.barcode.switchToManual" — switch-to-manual button

import SwiftUI
import InventoryCore

// MARK: - BarcodeCaptureCoordinator

/// Bridges `BarcodeScannerView` to `CaptureStateMachine`.
///
/// Owns the `BookMetadataLookup` actor and drives the full barcode-scan
/// flow: ISBN recognized → lookup → build `CapturePayload` → transition
/// to `.confirming(payload)`. On failure, shows a dismissible banner and
/// offers a "Switch to manual" path.
@MainActor
struct BarcodeCaptureCoordinator: View {

    // MARK: Dependencies

    @ObservedObject var stateMachine: CaptureStateMachine
    private let lookup: BookMetadataLookup

    // MARK: Local state

    @State private var lookupInProgress: Bool = false
    @State private var bannerMessage: String? = nil

    // MARK: Init

    init(stateMachine: CaptureStateMachine, lookup: BookMetadataLookup = BookMetadataLookup()) {
        self.stateMachine = stateMachine
        self.lookup = lookup
    }

    // MARK: Body

    var body: some View {
        ZStack {
            BarcodeScannerView(
                onRecognized: { isbn in
                    Task { await handleRecognized(isbn: isbn) }
                },
                onSwitchToManual: {
                    stateMachine.start(mode: .manual)
                }
            )

            if lookupInProgress {
                lookupProgressOverlay
            }

            if let message = bannerMessage {
                bannerOverlay(message: message)
            }
        }
    }

    // MARK: Recognized handler

    private func handleRecognized(isbn: String) async {
        lookupInProgress = true
        bannerMessage = nil

        do {
            let metadata = try await lookup.lookup(isbn: isbn)
            let payload = CapturePayload(
                title: metadata.title,
                medium: .book,
                creator: metadata.authors.first,
                coverImageData: nil,
                year: metadata.publishedYear,
                isbn: metadata.isbn13 ?? metadata.isbn10
            )
            lookupInProgress = false
            stateMachine.recognize(payload: payload)
        } catch LookupError.notFound {
            lookupInProgress = false
            bannerMessage = String(
                localized: "capture.barcode.notFound",
                defaultValue: "ISBN not found"
            )
        } catch {
            lookupInProgress = false
            bannerMessage = String(
                localized: "capture.barcode.lookupFailed",
                defaultValue: "Lookup failed"
            )
        }
    }

    // MARK: Progress overlay

    private var lookupProgressOverlay: some View {
        VStack(spacing: 8) {
            ProgressView()
            Text(
                String(
                    localized: "capture.barcode.prompt",
                    defaultValue: "Center the ISBN inside the frame"
                )
            )
            .font(.caption)
            .foregroundStyle(.secondary)
        }
        .padding(20)
        .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 12))
    }

    // MARK: Banner overlay

    private func bannerOverlay(message: String) -> some View {
        VStack {
            Spacer()

            GlassEffectContainer {
                HStack(spacing: 12) {
                    Image(systemName: "exclamationmark.triangle")
                        .foregroundStyle(.orange)

                    Text(message)
                        .font(.subheadline)

                    Spacer()

                    Button {
                        stateMachine.start(mode: .manual)
                    } label: {
                        Text(
                            String(
                                localized: "capture.barcode.switchToManual",
                                defaultValue: "Switch to manual"
                            )
                        )
                        .font(.caption.weight(.medium))
                    }
                    .buttonStyle(.glass)
                    .accessibilityLabel(
                        String(
                            localized: "capture.barcode.switchToManual",
                            defaultValue: "Switch to manual"
                        )
                    )
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
            }
            .padding(.horizontal, 16)
            .padding(.bottom, 100)
        }
        .transition(.move(edge: .bottom).combined(with: .opacity))
    }
}
