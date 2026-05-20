// ExportDataView.swift — App/Views/Settings
// Copyright 2026 sunghun.ahn — Still Hours
// Round 7: Data export surface (JSON + CSV via ExportService)
// Created: 2026-05-21

import SwiftUI
import SwiftData
import InventoryCore

// MARK: - ExportDataView

/// Presents two export buttons (JSON / CSV), calls `ExportService`,
/// writes the result to a temp file and presents a `ShareLink`.
///
/// Handles loading state with a glass overlay and shows an alert on error.
@MainActor
struct ExportDataView: View {

    // MARK: Environment

    @Environment(\.modelContext) private var modelContext

    // MARK: State

    @State private var isExporting = false
    @State private var exportError: String? = nil
    @State private var showErrorAlert = false
    @State private var exportedFileURL: URL? = nil
    @State private var showShareSheet = false

    // MARK: Body

    var body: some View {
        ZStack {
            mainContent
            if isExporting {
                exportingOverlay
            }
        }
        .navigationTitle(
            String(localized: "settings.export.title", defaultValue: "Export data")
        )
        .navigationBarTitleDisplayMode(.inline)
        .background(Color.shBackground)
        .alert(
            String(localized: "export.error.title", defaultValue: "Export failed"),
            isPresented: $showErrorAlert,
            presenting: exportError
        ) { _ in
            Button(
                String(localized: "export.retry", defaultValue: "Try again")
            ) {
                exportError = nil
            }
            Button(
                String(localized: "nav.cancel", defaultValue: "Cancel"),
                role: .cancel
            ) {}
        } message: { message in
            Text(message)
        }
        .sheet(isPresented: $showShareSheet) {
            if let url = exportedFileURL {
                ShareLink(item: url)
                    .presentationDetents([.medium])
            }
        }
    }

    // MARK: Main content

    private var mainContent: some View {
        VStack(alignment: .leading, spacing: 32) {
            exportButtons

            VStack(alignment: .leading, spacing: 8) {
                Text(
                    String(
                        localized: "settings.export.description",
                        defaultValue: "Your export includes all items and memories."
                    )
                )
                .font(.subheadline)
                .foregroundStyle(Color.shTextSecondary)

                Divider()
                    .padding(.vertical, 4)

                Text(
                    String(
                        localized: "settings.export.promiseFooter",
                        defaultValue: "Still Hours always lets you take your data with you."
                    )
                )
                .font(.caption)
                .foregroundStyle(Color.shTextSecondary)
            }
            .padding(.horizontal, 4)

            Spacer()
        }
        .padding(24)
    }

    // MARK: Export buttons

    private var exportButtons: some View {
        VStack(spacing: 16) {
            Button {
                Task { await performExport(format: .json) }
            } label: {
                Label(
                    String(
                        localized: "settings.export.json",
                        defaultValue: "Export as JSON"
                    ),
                    systemImage: "doc.text"
                )
                .frame(maxWidth: .infinity)
            }
            .buttonStyle(.glassProminent)
            .accessibilityLabel(
                String(
                    localized: "settings.export.json",
                    defaultValue: "Export as JSON"
                )
            )

            Button {
                Task { await performExport(format: .csv) }
            } label: {
                Label(
                    String(
                        localized: "settings.export.csv",
                        defaultValue: "Export as CSV"
                    ),
                    systemImage: "tablecells"
                )
                .frame(maxWidth: .infinity)
            }
            .buttonStyle(.glassProminent)
            .accessibilityLabel(
                String(
                    localized: "settings.export.csv",
                    defaultValue: "Export as CSV"
                )
            )
        }
    }

    // MARK: Loading overlay

    private var exportingOverlay: some View {
        ZStack {
            Color.black.opacity(0.15)
                .ignoresSafeArea()
            VStack(spacing: 12) {
                ProgressView()
                Text(
                    String(
                        localized: "export.inProgress",
                        defaultValue: "Exporting…"
                    )
                )
                .font(.subheadline)
                .foregroundStyle(Color.shTextSecondary)
            }
            .padding(24)
            .background(.regularMaterial)
            .clipShape(RoundedRectangle(cornerRadius: 16))
        }
    }

    // MARK: Export logic

    private enum ExportFormat {
        case json
        case csv

        var fileExtension: String {
            switch self {
            case .json: return "json"
            case .csv: return "csv"
            }
        }

        var fileName: String { "still-hours-export.\(fileExtension)" }
    }

    private func performExport(format: ExportFormat) async {
        isExporting = true
        defer { isExporting = false }

        do {
            let service = ExportService(context: modelContext)
            let data: Data

            switch format {
            case .json:
                data = try await service.exportAllAsJSON()
            case .csv:
                data = try await service.exportAllAsCSV()
            }

            let tempURL = FileManager.default
                .temporaryDirectory
                .appendingPathComponent(format.fileName)

            try data.write(to: tempURL, options: .atomic)
            exportedFileURL = tempURL
            showShareSheet = true

        } catch {
            exportError = error.localizedDescription
            showErrorAlert = true
        }
    }
}
