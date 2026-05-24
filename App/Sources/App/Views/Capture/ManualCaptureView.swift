// ManualCaptureView.swift — App/Views/Capture
// Copyright 2026 sunghun.ahn — Still Hours
// Sprint 1.1 — CaptureSheet shell + state machine + manual mode
// Created: 2026-05-21
//
// Localization keys used in this file:
//   "capture.field.title"          — title field label
//   "capture.field.title.prompt"   — title placeholder
//   "capture.field.medium"         — medium picker label
//   "capture.field.creator"        — creator field label
//   "capture.field.creator.prompt" — creator placeholder
//   "capture.field.cover"          — cover image picker label
//   "capture.validation.title_required" — inline error when title is empty
//   "medium.book"   — Book
//   "medium.music"  — Music
//   "medium.movie"  — Movie
//   "medium.object" — Object

import SwiftUI
import PhotosUI
import InventoryCore

// MARK: - ManualCaptureView

@MainActor
struct ManualCaptureView: View {

    // MARK: State mirroring the payload under edit

    @State private var title: String
    @State private var medium: Medium
    @State private var creator: String
    @State private var coverItem: PhotosPickerItem?
    @State private var coverImageData: Data?
    @State private var showTitleError: Bool = false

    // MARK: Focus

    @FocusState private var focused: CaptureField?

    // MARK: Callback

    /// Called whenever the payload changes so CaptureSheet can sync.
    let onChange: (CapturePayload) -> Void

    // MARK: Init

    init(payload: CapturePayload, onChange: @escaping (CapturePayload) -> Void) {
        _title   = State(initialValue: payload.title)
        _medium  = State(initialValue: payload.medium)
        _creator = State(initialValue: payload.creator ?? "")
        _coverImageData = State(initialValue: payload.coverImageData)
        self.onChange = onChange
    }

    // MARK: Body

    var body: some View {
        Form {
            Section {
                titleField
                mediumPicker
                creatorField
                coverPicker
            }
        }
        .formStyle(.grouped)
        .onChange(of: title)   { _, _ in emitPayload() }
        .onChange(of: medium)  { _, _ in emitPayload() }
        .onChange(of: creator) { _, _ in emitPayload() }
        .onChange(of: coverImageData) { _, _ in emitPayload() }
        .onChange(of: coverItem) { _, item in
            Task {
                guard let item else { return }
                if let data = try? await item.loadTransferable(type: Data.self) {
                    // Enforce 4 MB cap per spec
                    coverImageData = data.count <= 4_194_304 ? data : nil
                }
            }
        }
    }

    // MARK: Fields

    private var titleField: some View {
        VStack(alignment: .leading, spacing: 4) {
            TextField(
                String(localized: "capture.field.title", defaultValue: "Title"),
                text: $title,
                prompt: Text(
                    String(localized: "capture.field.title.prompt", defaultValue: "Required")
                )
            )
            .textInputAutocapitalization(.sentences)
            .focused($focused, equals: .title)
            .onSubmit { focused = .creator }
            .accessibilityLabel(String(localized: "capture.field.title", defaultValue: "Title"))

            if showTitleError {
                Text(
                    String(
                        localized: "capture.validation.title_required",
                        defaultValue: "Title is required."
                    )
                )
                .font(.caption)
                .foregroundStyle(.red)
                .transition(.opacity)
            }
        }
        .onChange(of: title) { _, newValue in
            if showTitleError && !newValue.trimmingCharacters(in: .whitespaces).isEmpty {
                showTitleError = false
            }
        }
    }

    private var mediumPicker: some View {
        Picker(
            String(localized: "capture.field.medium", defaultValue: "Medium"),
            selection: $medium
        ) {
            ForEach(Medium.allCases, id: \.self) { m in
                Text(mediumLabel(m)).tag(m)
            }
        }
        .accessibilityLabel(String(localized: "capture.field.medium", defaultValue: "Medium"))
    }

    private var creatorField: some View {
        TextField(
            String(localized: "capture.field.creator", defaultValue: "Creator (optional)"),
            text: $creator,
            prompt: Text(
                String(
                    localized: "capture.field.creator.prompt",
                    defaultValue: "Author / Artist / Director…"
                )
            )
        )
        .textInputAutocapitalization(.words)
        .focused($focused, equals: .creator)
        .accessibilityLabel(
            String(localized: "capture.field.creator", defaultValue: "Creator (optional)")
        )
    }

    private var coverPicker: some View {
        PhotosPicker(
            selection: $coverItem,
            matching: .images,
            photoLibrary: .shared()
        ) {
            HStack {
                Label(
                    String(localized: "capture.field.cover", defaultValue: "Cover Image (optional)"),
                    systemImage: "photo"
                )
                Spacer()
                if coverImageData != nil {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundStyle(.green)
                }
            }
        }
        .accessibilityLabel(
            String(localized: "capture.field.cover", defaultValue: "Cover Image (optional)")
        )
    }

    // MARK: Helpers

    private func mediumLabel(_ m: Medium) -> String {
        switch m {
        case .book:   return String(localized: "medium.book",   defaultValue: "Book")
        case .music:  return String(localized: "medium.music",  defaultValue: "Music")
        case .movie:  return String(localized: "medium.movie",  defaultValue: "Movie")
        case .object: return String(localized: "medium.object", defaultValue: "Object")
        case .place:  return String(localized: "medium.place",  defaultValue: "Place")
        }
    }

    private func emitPayload() {
        onChange(
            CapturePayload(
                title: title,
                medium: medium,
                creator: creator.isEmpty ? nil : creator,
                coverImageData: coverImageData
            )
        )
    }
}

// MARK: - Focus fields

private enum CaptureField: Hashable {
    case title, creator
}
