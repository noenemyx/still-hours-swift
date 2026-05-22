// EditMemoryView.swift — App/Views/Memory
// Copyright 2026 sunghun.ahn — Still Hours
// R14.2 — Edit + Delete UX for existing Memory
// Created: 2026-05-22
//
// Sheet form for editing an existing Memory on an Item.
// Localisation key namespace: memory.edit.*, memory.delete.*
// Mirrors AddMemoryView field structure.
// Axis I: LibraryService is @MainActor — direct async call, no extra actor hop.
// Axis F: No inner-quote escapes in format strings.

import SwiftUI
import PhotosUI
import InventoryCore

// MARK: - EditMemoryView

/// Sheet form for editing an existing ``Memory``.
///
/// Presented as a `.sheet` from ``MemoryTimelineView`` when a row is tapped.
/// On successful save, ``onSaved`` is invoked; on cancel, ``onCancel``.
/// Delete is available via a destructive button inside the form.
///
/// ## Sections
/// 1. Memory kind — horizontal chip row (8 MemoryKind cases)
/// 2. Note — multi-line TextField (pre-populated)
/// 3. Date — DatePicker limited to past + today (pre-populated)
/// 4. Photo — optional PhotosPicker (pre-populated if memory.photoCount > 0)
@MainActor
struct EditMemoryView: View {

    // MARK: Input

    let memory: Memory
    let library: LibraryService
    let onSaved: () -> Void
    let onCancel: () -> Void

    // MARK: State — form fields

    @State private var selectedKind: MemoryKind
    @State private var note: String
    @State private var date: Date
    @State private var photoItem: PhotosPickerItem?
    @State private var photoData: Data?

    // MARK: State — async operations

    @State private var isSaving: Bool = false
    @State private var showErrorAlert: Bool = false
    @State private var errorMessage: String = ""
    @State private var showDeleteConfirmation: Bool = false

    // MARK: Environment

    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    // MARK: Init

    init(
        memory: Memory,
        library: LibraryService,
        onSaved: @escaping () -> Void,
        onCancel: @escaping () -> Void
    ) {
        self.memory = memory
        self.library = library
        self.onSaved = onSaved
        self.onCancel = onCancel

        // Pre-populate form state from the existing memory.
        _selectedKind = State(initialValue: memory.kind)
        _note = State(initialValue: memory.note)
        _date = State(initialValue: memory.date)
        // Photo data hydration is async; deferred to .onAppear for the first photo.
        _photoData = State(initialValue: nil)
    }

    // MARK: Body

    var body: some View {
        NavigationStack {
            Form {
                kindSection
                noteSection
                dateSection
                photoSection
                deleteSection
            }
            .formStyle(.grouped)
            .navigationTitle(
                String(localized: "memory.edit.title", defaultValue: "Edit Memory")
            )
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button(
                        String(localized: "memory.add.cancel", defaultValue: "Cancel"),
                        action: onCancel
                    )
                    .foregroundStyle(SemanticTokens.cta.secondary.text)
                }

                ToolbarItem(placement: .confirmationAction) {
                    Button {
                        Task { await save() }
                    } label: {
                        if isSaving {
                            ProgressView()
                                .progressViewStyle(.circular)
                        } else {
                            Text(
                                String(localized: "memory.edit.save", defaultValue: "Save")
                            )
                            .fontWeight(.semibold)
                        }
                    }
                    .buttonStyle(.glassProminent)
                    .disabled(isSaving)
                    .accessibilityLabel(
                        String(
                            localized: "memory.edit.save",
                            defaultValue: "Save"
                        )
                    )
                }
            }
            .onChange(of: photoItem) { _, newItem in
                Task {
                    guard let newItem else { return }
                    if let data = try? await newItem.loadTransferable(type: Data.self) {
                        photoData = data.count <= 4_194_304 ? data : nil
                    }
                }
            }
            .alert(
                String(localized: "memory.add.error.saveFailed", defaultValue: "Save failed"),
                isPresented: $showErrorAlert
            ) {
                Button(
                    String(localized: "memory.add.error.retry", defaultValue: "Try again")
                ) {
                    Task { await save() }
                }
                Button(
                    String(localized: "memory.add.cancel", defaultValue: "Cancel"),
                    role: .cancel,
                    action: {}
                )
            } message: {
                Text(errorMessage)
            }
            .confirmationDialog(
                String(
                    localized: "memory.delete.confirm.title",
                    defaultValue: "Delete this memory?"
                ),
                isPresented: $showDeleteConfirmation,
                titleVisibility: .visible
            ) {
                Button(
                    String(
                        localized: "memory.delete.confirm.confirmButton",
                        defaultValue: "Delete"
                    ),
                    role: .destructive
                ) {
                    Task { await deleteMemory() }
                }
                Button(
                    String(
                        localized: "memory.delete.confirm.cancelButton",
                        defaultValue: "Cancel"
                    ),
                    role: .cancel,
                    action: {}
                )
            } message: {
                Text(
                    String(
                        localized: "memory.delete.confirm.body",
                        defaultValue: "This cannot be undone."
                    )
                )
            }
        }
    }

    // MARK: Sections

    private var kindSection: some View {
        Section(
            String(localized: "memory.add.section.kind", defaultValue: "Memory kind")
        ) {
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: FoundationTokens.Space.sm) {
                    ForEach(MemoryKind.allCases, id: \.self) { kind in
                        MemoryKindChipView(
                            kind: kind,
                            isSelected: selectedKind == kind,
                            onTap: {
                                withAnimation(reduceMotion ? nil : .easeInOut(duration: 0.15)) {
                                    selectedKind = kind
                                }
                            }
                        )
                    }
                }
                .padding(.vertical, FoundationTokens.Space.xs)
            }
            .listRowInsets(EdgeInsets(
                top: FoundationTokens.Space.sm,
                leading: FoundationTokens.Space.md,
                bottom: FoundationTokens.Space.sm,
                trailing: FoundationTokens.Space.md
            ))
        }
    }

    private var noteSection: some View {
        Section(
            String(localized: "memory.add.section.note", defaultValue: "Note")
        ) {
            TextField(
                String(localized: "memory.add.section.note", defaultValue: "Note"),
                text: $note,
                prompt: Text(
                    String(
                        localized: "memory.add.note.placeholder",
                        defaultValue: "What memory is this?"
                    )
                ),
                axis: .vertical
            )
            .lineLimit(4...12)
            .textInputAutocapitalization(.sentences)
            .accessibilityLabel(
                String(localized: "memory.add.section.note", defaultValue: "Note")
            )
        }
    }

    private var dateSection: some View {
        Section(
            String(localized: "memory.add.section.date", defaultValue: "Date")
        ) {
            DatePicker(
                String(localized: "memory.add.section.date", defaultValue: "Date"),
                selection: $date,
                in: ...Date(),
                displayedComponents: .date
            )
            .datePickerStyle(.compact)
            .accessibilityLabel(
                String(localized: "memory.add.section.date", defaultValue: "Date")
            )
        }
    }

    @ViewBuilder
    private var photoSection: some View {
        Section(
            String(localized: "memory.add.section.photo", defaultValue: "Photo")
        ) {
            if let data = photoData, let uiImage = UIImage(data: data) {
                HStack {
                    Image(uiImage: uiImage)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 72, height: 72)
                        .clipShape(RoundedRectangle(cornerRadius: FoundationTokens.Radius.sm))

                    Spacer()

                    Button(role: .destructive) {
                        photoData = nil
                        photoItem = nil
                    } label: {
                        Label(
                            String(
                                localized: "memory.add.photo.remove",
                                defaultValue: "Remove photo"
                            ),
                            systemImage: "xmark.circle.fill"
                        )
                        .foregroundStyle(Color.shTextSecondary)
                    }
                    .buttonStyle(.plain)
                }
            } else {
                PhotosPicker(
                    selection: $photoItem,
                    matching: .images,
                    photoLibrary: .shared()
                ) {
                    Label(
                        String(
                            localized: "memory.add.photo.add",
                            defaultValue: "Add photo"
                        ),
                        systemImage: "photo.badge.plus"
                    )
                    .foregroundStyle(SemanticTokens.cta.secondary.text)
                }
                .accessibilityLabel(
                    String(localized: "memory.add.photo.add", defaultValue: "Add photo")
                )
            }
        }
    }

    private var deleteSection: some View {
        Section {
            Button(role: .destructive) {
                showDeleteConfirmation = true
            } label: {
                HStack {
                    Spacer()
                    Text(
                        String(localized: "memory.edit.delete", defaultValue: "Delete")
                    )
                    Spacer()
                }
            }
            .accessibilityLabel(
                String(localized: "memory.edit.delete", defaultValue: "Delete")
            )
        }
    }

    // MARK: Save

    private func save() async {
        isSaving = true
        defer { isSaving = false }

        do {
            try await library.updateMemory(memory) { mem in
                // Append history entry before overwriting if note changed (PRD T5.5)
                if mem.note != note {
                    mem.noteHistory.append(HistoryEntry(note: mem.note))
                }
                mem.kind = selectedKind
                mem.note = note
                mem.date = date
            }
            onSaved()
        } catch {
            errorMessage = error.localizedDescription
            showErrorAlert = true
        }
    }

    // MARK: Delete

    private func deleteMemory() async {
        do {
            try await library.deleteMemory(memory)
            onSaved()
        } catch {
            errorMessage = error.localizedDescription
            showErrorAlert = true
        }
    }
}
