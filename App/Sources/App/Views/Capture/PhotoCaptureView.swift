// PhotoCaptureView.swift — App/Views/Capture
// Copyright 2026 sunghun.ahn — Still Hours
// R18 — Photo-based object identification using on-device Vision framework
// Created: 2026-05-23
//
// Privacy: PhotosPicker grants per-photo access (no full library scan); Vision
// runs 100% on-device (VNClassifyImage + VNRecognizeText); no network calls.
//
// Localization keys used in this file:
//   "capture.photo.pick"          — pick photo button label
//   "capture.photo.retake"        — retake photo button label
//   "capture.photo.analyzing"     — analyzing in-progress text
//   "capture.photo.detected"      — "Detected" section title
//   "capture.photo.categories"    — "Likely category" section title
//   "capture.photo.useAsTitle"    — use as title accessibility hint
//   "capture.photo.empty"         — no results found text

import SwiftUI
import PhotosUI
import InventoryCore

// MARK: - PhotoCaptureView

@MainActor
struct PhotoCaptureView: View {

    // MARK: Dependencies

    let onUseTitle: (String, Data) -> Void
    let onSwitchToManual: () -> Void

    // MARK: Local state

    @State private var photoItem: PhotosPickerItem? = nil
    @State private var photoData: Data? = nil
    @State private var classifications: [VisionClassification] = []
    @State private var recognizedText: [String] = []
    @State private var isAnalyzing: Bool = false
    @State private var hasAnalyzed: Bool = false

    private let lookup = ObjectVisionLookup()

    // MARK: Body

    var body: some View {
        ScrollView {
            VStack(spacing: 16) {
                photoSection
                if isAnalyzing { analyzingSection }
                if hasAnalyzed { resultsSection }
                fallbackButton
            }
            .padding(.horizontal, 16)
            .padding(.top, 12)
            .padding(.bottom, 100)
        }
    }

    // MARK: Photo section

    @ViewBuilder
    private var photoSection: some View {
        if let data = photoData, let uiImage = UIImage(data: data) {
            VStack(spacing: 8) {
                Image(uiImage: uiImage)
                    .resizable()
                    .scaledToFit()
                    .frame(maxHeight: 280)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .accessibilityLabel("Selected photo")

                PhotosPicker(
                    selection: $photoItem,
                    matching: .images,
                    photoLibrary: .shared()
                ) {
                    Label(
                        String(localized: "capture.photo.retake", defaultValue: "Choose another photo"),
                        systemImage: "photo.on.rectangle.angled"
                    )
                    .font(.subheadline)
                }
                .buttonStyle(.glass)
            }
        } else {
            PhotosPicker(
                selection: $photoItem,
                matching: .images,
                photoLibrary: .shared()
            ) {
                VStack(spacing: 12) {
                    Image(systemName: "photo.badge.plus")
                        .font(.system(size: 56))
                        .foregroundStyle(.tint)
                    Text(
                        String(localized: "capture.photo.pick", defaultValue: "Choose a photo")
                    )
                    .font(.headline)
                    Text(
                        "오브제·제품 사진을 선택하면 자동으로 분류·텍스트 인식이 수행됩니다."
                    )
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 12)
                }
                .frame(maxWidth: .infinity)
                .frame(height: 280)
                .background(Color.secondary.opacity(0.08), in: RoundedRectangle(cornerRadius: 12))
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .strokeBorder(Color.secondary.opacity(0.2), style: StrokeStyle(lineWidth: 1.5, dash: [6, 4]))
                )
            }
            .accessibilityLabel(String(localized: "capture.photo.pick", defaultValue: "Choose a photo"))
        }
    }

    // MARK: Analyzing section

    private var analyzingSection: some View {
        HStack(spacing: 12) {
            ProgressView().controlSize(.small)
            Text(String(localized: "capture.photo.analyzing", defaultValue: "Analyzing photo…"))
                .font(.subheadline)
                .foregroundStyle(.secondary)
        }
        .padding(16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 12))
    }

    // MARK: Results section

    @ViewBuilder
    private var resultsSection: some View {
        if classifications.isEmpty && recognizedText.isEmpty {
            Text(String(localized: "capture.photo.empty", defaultValue: "No text or category detected. Use manual entry."))
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(16)
                .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 12))
        } else {
            VStack(alignment: .leading, spacing: 16) {
                if !recognizedText.isEmpty {
                    sectionHeader(title: String(localized: "capture.photo.detected", defaultValue: "Detected text"))
                    VStack(spacing: 8) {
                        ForEach(recognizedText.prefix(6), id: \.self) { text in
                            useButton(label: text, weight: .medium)
                        }
                    }
                }
                if !classifications.isEmpty {
                    sectionHeader(title: String(localized: "capture.photo.categories", defaultValue: "Likely category"))
                    VStack(spacing: 8) {
                        ForEach(classifications.prefix(5), id: \.label) { c in
                            useButton(
                                label: c.displayLabel,
                                trailing: "\(Int(c.confidence * 100))%"
                            )
                        }
                    }
                }
            }
        }
    }

    private func sectionHeader(title: String) -> some View {
        Text(title)
            .font(.subheadline.weight(.semibold))
            .foregroundStyle(.secondary)
            .frame(maxWidth: .infinity, alignment: .leading)
    }

    private func useButton(label: String, trailing: String? = nil, weight: Font.Weight = .regular) -> some View {
        Button {
            guard let data = photoData else { return }
            onUseTitle(label, data)
        } label: {
            HStack {
                Text(label)
                    .font(.body.weight(weight))
                    .multilineTextAlignment(.leading)
                Spacer()
                if let trailing {
                    Text(trailing)
                        .font(.caption.monospacedDigit())
                        .foregroundStyle(.secondary)
                }
                Image(systemName: "arrow.right.circle")
                    .foregroundStyle(.tint)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .background(.regularMaterial, in: RoundedRectangle(cornerRadius: 10))
        }
        .buttonStyle(.plain)
        .accessibilityHint(String(localized: "capture.photo.useAsTitle", defaultValue: "Uses this as the item title"))
    }

    // MARK: Fallback

    private var fallbackButton: some View {
        Button {
            onSwitchToManual()
        } label: {
            Text(String(localized: "capture.barcode.switchToManual", defaultValue: "Switch to manual"))
                .font(.subheadline)
        }
        .buttonStyle(.glass)
        .padding(.top, 4)
    }

    // MARK: Photo lifecycle

    private var photoSelectionTask: some View {
        EmptyView()
            .onChange(of: photoItem) { _, newItem in
                Task { await loadAndAnalyze(item: newItem) }
            }
    }

    private func loadAndAnalyze(item: PhotosPickerItem?) async {
        guard let item else { return }
        do {
            if let data = try await item.loadTransferable(type: Data.self) {
                photoData = data
                classifications = []
                recognizedText = []
                hasAnalyzed = false
                isAnalyzing = true
                let result = try await lookup.analyze(imageData: data)
                classifications = result.classifications
                recognizedText = result.recognizedText
                hasAnalyzed = true
                isAnalyzing = false
            }
        } catch {
            isAnalyzing = false
            hasAnalyzed = true
        }
    }
}

// MARK: - View modifier wiring

extension PhotoCaptureView {
    func onPhotoSelected() -> some View {
        self.background(photoSelectionTask)
    }
}
