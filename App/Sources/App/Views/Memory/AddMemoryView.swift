// AddMemoryView.swift — App/Views/Memory
// Copyright 2026 sunghun.ahn — Still Hours
// Sprint 1.6 — AddMemoryView (Memory to existing Item)
// Created: 2026-05-21
//
// Sheet form for adding a new Memory to an existing Item.
// Localisation key namespace: memory.add.*
// Axis I: LibraryService is @MainActor — direct async call, no extra actor hop.
// Axis F: No inner-quote escapes in format strings.
// Axis J: @unchecked Sendable not needed here — pure SwiftUI state.

import SwiftUI
import PhotosUI
import InventoryCore

// MARK: - AddMemoryView

/// Sheet form for recording a new ``Memory`` against an existing ``Item``.
///
/// Presented as a `.sheet` from ``ItemDetailView``.
/// On successful save, ``onSaved`` is invoked; on cancel, ``onCancel``.
///
/// ## Sections
/// 1. Memory kind — horizontal chip row (8 MemoryKind cases)
/// 2. Note — multi-line TextField
/// 3. Date — DatePicker limited to past + today
/// 4. Photo — optional PhotosPicker (0–1 image)
@MainActor
struct AddMemoryView: View {

    // MARK: Input

    let item: Item
    let library: LibraryService
    let onSaved: () -> Void
    let onCancel: () -> Void

    // MARK: State — form fields

    @State private var selectedKind: MemoryKind
    @State private var note: String = ""
    @State private var date: Date = Date()
    @State private var photoItem: PhotosPickerItem?
    @State private var photoData: Data?

    // MARK: State — async save

    @State private var isSaving: Bool = false
    @State private var showErrorAlert: Bool = false
    @State private var errorMessage: String = ""

    // MARK: Environment

    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    // MARK: Init

    init(
        item: Item,
        library: LibraryService,
        onSaved: @escaping () -> Void,
        onCancel: @escaping () -> Void
    ) {
        self.item = item
        self.library = library
        self.onSaved = onSaved
        self.onCancel = onCancel

        // Default kind based on item medium
        let defaultKind: MemoryKind
        switch item.medium {
        case .book:   defaultKind = .read
        case .music:  defaultKind = .listened
        case .movie:  defaultKind = .watched
        case .object: defaultKind = .acquired
        }
        _selectedKind = State(initialValue: defaultKind)
    }

    // MARK: Body

    var body: some View {
        NavigationStack {
            Form {
                kindSection
                noteSection
                dateSection
                photoSection
            }
            .formStyle(.grouped)
            .navigationTitle(
                String(localized: "memory.add.title", defaultValue: "Add Memory")
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
                                String(localized: "memory.add.save", defaultValue: "Save")
                            )
                            .fontWeight(.semibold)
                        }
                    }
                    .buttonStyle(.glassProminent)
                    .disabled(isSaving)
                    .accessibilityLabel(
                        String(
                            localized: "memory.add.save.accessibility",
                            defaultValue: "Save memory"
                        )
                        + " — "
                        + kindLabel(selectedKind)
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

    // MARK: Save

    private func save() async {
        isSaving = true
        defer { isSaving = false }

        let memory = Memory(
            kind: selectedKind,
            date: date,
            note: note
        )

        // Attach photo as Attachment if photo was selected
        if let data = photoData {
            let attachment = buildPhotoAttachment(data: data)
            memory.photos.append(attachment)
            memory.photoCount = 1
        }

        do {
            try await library.attachMemory(memory, to: item)
            onSaved()
        } catch {
            errorMessage = error.localizedDescription
            showErrorAlert = true
        }
    }

    // MARK: Helpers

    private func buildPhotoAttachment(data: Data) -> Attachment {
        // Write photo data to app Documents directory; store relative filename as path.
        let filename = "\(UUID().uuidString).jpg"
        let docsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let fileURL = docsURL.appendingPathComponent(filename)
        try? data.write(to: fileURL)
        return Attachment(kind: .photo, path: filename)
    }

    private func kindLabel(_ kind: MemoryKind) -> String {
        switch kind {
        case .acquired:  return String(localized: "memory.kind.acquired",  defaultValue: "Acquired")
        case .read:      return String(localized: "memory.kind.read",      defaultValue: "Read")
        case .listened:  return String(localized: "memory.kind.listened",  defaultValue: "Listened")
        case .watched:   return String(localized: "memory.kind.watched",   defaultValue: "Watched")
        case .lent:      return String(localized: "memory.kind.lent",      defaultValue: "Lent")
        case .received:  return String(localized: "memory.kind.received",  defaultValue: "Received")
        case .gifted:    return String(localized: "memory.kind.gifted",    defaultValue: "Gifted")
        case .annotated: return String(localized: "memory.kind.annotated", defaultValue: "Annotated")
        }
    }
}
