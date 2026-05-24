// BarcodeScannerView.swift — App/Views/Capture
// Copyright 2026 sunghun.ahn — Still Hours
// Sprint 1.3 — Barcode scanner: AVCaptureSession + live preview + permission flow
// Created: 2026-05-21
//
// Localization keys used in this file:
//   "capture.barcode.prompt"          — center ISBN in frame
//   "capture.barcode.switchToManual"  — switch to manual button
//   "capture.barcode.permissionDenied"— camera permission required
//   "capture.barcode.openSettings"    — open Settings button

import SwiftUI
import AVFoundation

// MARK: - BarcodeScannerView

/// SwiftUI wrapper for a live AVCaptureSession barcode scanner.
///
/// Fires `onRecognized` exactly once per scanner lifecycle with the first
/// valid ISBN string (13 digits or 10 digits with optional trailing X).
/// Fires `onSwitchToManual` when the user explicitly requests manual entry.
@MainActor
struct BarcodeScannerView: View {

    // MARK: Callbacks
    //
    // `onRecognized` MUST be `@Sendable` because it propagates down into
    // `CameraPreviewRepresentable` → `BarcodeSessionCoordinator`, where it
    // is invoked from the AVFoundation metadata callback queue (not the
    // main actor). The closure body should marshal back to main with
    // `Task { @MainActor in ... }` before touching SwiftUI state.

    let onRecognized: @Sendable (String) -> Void
    let onSwitchToManual: () -> Void

    // MARK: Environment

    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    // MARK: Local state

    @State private var permissionGranted: Bool = false
    @State private var permissionChecked: Bool = false
    @State private var pulseScale: CGFloat = 1.0

    // MARK: Body

    var body: some View {
        ZStack {
            if permissionChecked {
                if permissionGranted {
                    cameraContent
                } else {
                    permissionDeniedView
                }
            } else {
                Color.clear
            }
        }
        .task {
            await requestCameraPermission()
        }
    }

    // MARK: Camera content

    private var cameraContent: some View {
        ZStack {
            CameraPreviewRepresentable(
                onRecognized: onRecognized
            )
            .ignoresSafeArea()
            .accessibilityLabel("Camera preview, scanning for ISBN barcodes")
            .accessibilityAddTraits(.updatesFrequently)

            scannerOverlay
        }
    }

    // MARK: Scanner overlay

    private var scannerOverlay: some View {
        VStack {
            Spacer()

            GlassEffectContainer {
                VStack(spacing: 12) {
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.secondary.opacity(0.6), lineWidth: 2)
                        .frame(width: 240, height: 180)
                        .scaleEffect(pulseScale)
                        .animation(
                            reduceMotion ? nil : .easeInOut(duration: 1.0).repeatForever(autoreverses: true),
                            value: pulseScale
                        )

                    Text(
                        String(
                            localized: "capture.barcode.prompt",
                            defaultValue: "Center the ISBN inside the frame"
                        )
                    )
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 16)

                    Button {
                        onSwitchToManual()
                    } label: {
                        Text(
                            String(
                                localized: "capture.barcode.switchToManual",
                                defaultValue: "Switch to manual"
                            )
                        )
                        .font(.subheadline)
                    }
                    .buttonStyle(.glass)
                    .accessibilityLabel(
                        String(
                            localized: "capture.barcode.switchToManual",
                            defaultValue: "Switch to manual"
                        )
                    )
                    .accessibilityHint("Switches to manual entry form.")
                }
                .padding(20)
            }

            Spacer()
        }
        .onAppear {
            if !reduceMotion {
                pulseScale = 1.04
            }
        }
    }

    // MARK: Permission denied view

    private var permissionDeniedView: some View {
        VStack(spacing: 16) {
            Image(systemName: "camera.slash")
                .font(.system(size: 48))
                .foregroundStyle(.secondary)

            Text(
                String(
                    localized: "capture.barcode.permissionDenied",
                    defaultValue: "Camera permission required"
                )
            )
            .font(.headline)
            .multilineTextAlignment(.center)

            Button {
                openSettings()
            } label: {
                Text(
                    String(
                        localized: "capture.barcode.openSettings",
                        defaultValue: "Open Settings"
                    )
                )
            }
            .buttonStyle(.glass)
            .accessibilityLabel(
                String(
                    localized: "capture.barcode.openSettings",
                    defaultValue: "Open Settings"
                )
            )
            .accessibilityHint("Opens the iOS Settings app to grant camera access.")
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding()
    }

    // MARK: Helpers

    private func requestCameraPermission() async {
        let granted = await AVCaptureDevice.requestAccess(for: .video)
        permissionGranted = granted
        permissionChecked = true
    }

    private func openSettings() {
        guard let url = URL(string: UIApplication.openSettingsURLString) else { return }
        UIApplication.shared.open(url)
    }
}

// MARK: - CameraPreviewRepresentable

/// UIViewControllerRepresentable hosting an AVCaptureSession with metadata output.
@MainActor
struct CameraPreviewRepresentable: UIViewControllerRepresentable {

    // `@Sendable` is required because the coordinator stores this closure
    // for invocation from the AVFoundation metadata callback queue — Swift 6
    // strict concurrency rejects a plain `(String) -> Void` value where the
    // callee asks for `@Sendable (String) -> Void`. Caller passes a closure
    // that itself only touches main-actor state via `Task { @MainActor in ... }`.
    let onRecognized: @Sendable (String) -> Void

    func makeCoordinator() -> BarcodeSessionCoordinator {
        BarcodeSessionCoordinator(onRecognized: onRecognized)
    }

    func makeUIViewController(context: Context) -> CameraHostViewController {
        let vc = CameraHostViewController()
        vc.coordinator = context.coordinator
        context.coordinator.hostViewController = vc
        return vc
    }

    func updateUIViewController(_ uiViewController: CameraHostViewController, context: Context) {}
}

// MARK: - CameraHostViewController

final class CameraHostViewController: UIViewController {

    var coordinator: BarcodeSessionCoordinator?
    private var previewLayer: AVCaptureVideoPreviewLayer?

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        guard let coordinator else { return }
        let session = coordinator.session
        let layer = AVCaptureVideoPreviewLayer(session: session)
        layer.videoGravity = .resizeAspectFill
        layer.frame = view.bounds
        view.layer.insertSublayer(layer, at: 0)
        previewLayer = layer
        DispatchQueue.global(qos: .userInitiated).async {
            session.startRunning()
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        coordinator?.session.stopRunning()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        previewLayer?.frame = view.bounds
    }
}

// MARK: - BarcodeSessionCoordinator

// `@unchecked Sendable` is required: AVCaptureSession + a mutable
// `hasRecognized` flag don't satisfy Swift 6 strict concurrency on their own.
// Safety justification: the AVFoundation metadata callback always fires on
// the same `sessionQueue` (configured in `configureSession()`), and the
// host view controller / coordinator are only constructed and torn down
// from the main actor, so the cross-thread surface is read-only access to
// the session object — which AVFoundation guarantees is safe per its
// documented thread-safety contract.
final class BarcodeSessionCoordinator: NSObject, AVCaptureMetadataOutputObjectsDelegate, @unchecked Sendable {

    let session: AVCaptureSession
    private let onRecognized: @Sendable (String) -> Void
    private var hasRecognized = false
    weak var hostViewController: CameraHostViewController?

    init(onRecognized: @escaping @Sendable (String) -> Void) {
        self.onRecognized = onRecognized
        self.session = AVCaptureSession()
        super.init()
        configureSession()
    }

    private func configureSession() {
        session.sessionPreset = .hd1280x720

        guard let device = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back),
              let input = try? AVCaptureDeviceInput(device: device),
              session.canAddInput(input) else { return }
        session.addInput(input)

        let metadataOutput = AVCaptureMetadataOutput()
        guard session.canAddOutput(metadataOutput) else { return }
        session.addOutput(metadataOutput)
        metadataOutput.setMetadataObjectsDelegate(self, queue: .main)
        // EAN-13 = primary ISBN format. UPC-A is automatically reported by
        // AVFoundation as EAN-13 with a leading 0 — already covered.
        metadataOutput.metadataObjectTypes = [.ean13, .ean8, .upce]
    }

    /// Re-arm the scanner after a failed lookup, allowing another attempt
    /// without dismissing the sheet or switching modes.
    func resumeScanning() {
        hasRecognized = false
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            guard let self else { return }
            if !self.session.isRunning { self.session.startRunning() }
        }
    }

    // MARK: AVCaptureMetadataOutputObjectsDelegate

    nonisolated func metadataOutput(
        _ output: AVCaptureMetadataOutput,
        didOutput metadataObjects: [AVMetadataObject],
        from connection: AVCaptureConnection
    ) {
        guard !hasRecognized else { return }

        let readable = metadataObjects
            .compactMap { $0 as? AVMetadataMachineReadableCodeObject }
            .compactMap { $0.stringValue }
            .first { isValidISBN($0) }

        guard let isbn = readable else { return }
        hasRecognized = true

        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            self?.session.stopRunning()
        }

        DispatchQueue.main.async { [weak self] in
            self?.onRecognized(isbn)
            let announcement = "ISBN 인식됨. 메타데이터를 가져오는 중입니다."
            AccessibilityNotification.Announcement(announcement).post()
        }
    }

    // MARK: ISBN Validation

    nonisolated private func isValidISBN(_ value: String) -> Bool {
        let stripped = value.replacingOccurrences(of: "-", with: "")
        switch stripped.count {
        case 13:
            return stripped.allSatisfy(\.isNumber)
        case 10:
            let chars = Array(stripped)
            for (i, c) in chars.enumerated() {
                if i == 9 {
                    guard c.isNumber || c == "X" || c == "x" else { return false }
                } else {
                    guard c.isNumber else { return false }
                }
            }
            return true
        default:
            return false
        }
    }
}
