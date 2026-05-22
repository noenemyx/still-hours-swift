// ExportService.swift — InventoryCore/Services
// Copyright 2026 sunghun.ahn — Still Hours v0.1 MVP
// Pre-flight Round 4: InventoryService layer
// Created: 2026-05-20
// LINT-IGNORE: Privacy — no external URL

import Foundation
import SwiftData

// MARK: - ExportService

/// Actor-isolated service for exporting library data as JSON, CSV, or PDF.
///
/// Relies on the `Encodable` conformances declared in each `@Model` file
/// (Promise lint #2 — Data Sovereignty). All returned `Data` values are
/// Sendable and safe to pass across actor boundaries.
///
/// Swift 6 note: Switched from `actor` to `@MainActor final class` so the
/// service can accept a `ModelContext` from a SwiftUI view environment
/// without the "sending self.modelContext risks data races" diagnostic.
/// `ModelContext` is itself main-actor bound under SwiftData's SwiftUI
/// integration; pretending otherwise via a separate actor isolation
/// fights the framework. Public methods remain `async throws` for forward
/// compatibility with off-main background variants.
@available(iOS 26, macOS 26, *)
@MainActor
public final class ExportService {

    // MARK: Stored Properties

    private let context: ModelContext

    // MARK: Initialiser

    public init(context: ModelContext) {
        self.context = context
    }

    // MARK: JSON Export

    /// Exports the entire library — all ``Item``, ``Memory``, ``Collection``,
    /// and ``Attachment`` records — as a pretty-printed JSON blob.
    ///
    /// The JSON structure is a top-level object with four keyed arrays:
    /// `"items"`, `"memories"`, `"collections"`, `"attachments"`.
    ///
    /// - Returns: UTF-8 encoded JSON `Data`.
    /// - Throws: ``ServiceError/encodingFailed`` if encoding produces no output.
    public func exportAllAsJSON() async throws -> Data {
        let items = try context.fetch(FetchDescriptor<Item>())
        let memories = try context.fetch(FetchDescriptor<Memory>())
        let collections = try context.fetch(FetchDescriptor<Collection>())
        let attachments = try context.fetch(FetchDescriptor<Attachment>())

        let encoder = JSONEncoder()
        encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
        encoder.dateEncodingStrategy = .iso8601

        // Build a type-erased keyed structure using Codable wrappers.
        let payload = LibraryExportPayload(
            items: items,
            memories: memories,
            collections: collections,
            attachments: attachments
        )

        let data = try encoder.encode(payload)
        guard !data.isEmpty else { throw ServiceError.encodingFailed }
        return data
    }

    // MARK: CSV Export

    /// Exports all ``Item`` records as a flat CSV (RFC 4180).
    ///
    /// Columns: `id,title,creator,year,medium,state,tags,createdAt,updatedAt`
    ///
    /// - Returns: UTF-8 encoded CSV `Data`.
    /// - Throws: ``ServiceError/encodingFailed`` if the result is empty.
    public func exportAllAsCSV() async throws -> Data {
        let items = try context.fetch(FetchDescriptor<Item>(
            sortBy: [SortDescriptor(\.title)]
        ))

        var rows: [String] = [
            "id,title,creator,year,medium,state,tags,createdAt,updatedAt"
        ]

        let iso = ISO8601DateFormatter()

        for item in items {
            let row = [
                item.id.uuidString,
                csvEscape(item.title),
                csvEscape(item.creator ?? ""),
                item.year.map(String.init) ?? "",
                item.medium.rawValue,
                item.state.rawValue,
                csvEscape(item.tags.joined(separator: ";")),
                iso.string(from: item.createdAt),
                iso.string(from: item.updatedAt)
            ].joined(separator: ",")
            rows.append(row)
        }

        let csv = rows.joined(separator: "\n")
        guard let data = csv.data(using: .utf8), !data.isEmpty else {
            throw ServiceError.encodingFailed
        }
        return data
    }

    // MARK: PDF Export (Placeholder)

    /// Exports a single ``Item`` as a PDF summary.
    ///
    /// - Parameters:
    ///   - item: The item to render.
    ///   - asPDF: Unused placeholder parameter — reserved for future PDFKit integration.
    /// - Returns: Empty `Data` placeholder.
    ///
    /// - Note: (v1.1) PDFKit export via App layer — requires UIKit/AppKit access
    ///   PDFKit is not available in a package without framework imports.
    ///   Tracked: Still Hours vNext — PDF export (App target).
    public func exportItem(_ item: Item, asPDF: Bool = true) async throws -> Data {
        // WORKAROUND: PDF generation requires PDFKit (UIKit/AppKit — App layer only).
        // This stub returns empty Data so callers can wire the method signature now.
        // Root cause: InventoryCore is a framework-agnostic Swift package.
        // Proper fix: PDFKit renderer in App target that calls this actor via protocol.
        // Expiry: implement before Still Hours v0.5 (Manifestation milestone).
        return Data()
    }

    // MARK: Private Helpers

    /// Wraps a CSV field in double quotes and escapes any internal double quotes.
    private func csvEscape(_ value: String) -> String {
        let escaped = value.replacingOccurrences(of: "\"", with: "\"\"")
        return "\"\(escaped)\""
    }
}

// MARK: - LibraryExportPayload (Private)

/// A Codable envelope that wraps the four entity arrays for JSON export.
///
/// Private to this file — not part of the public API surface.
@available(iOS 26, macOS 26, *)
private struct LibraryExportPayload: Encodable {
    let items: [Item]
    let memories: [Memory]
    let collections: [Collection]
    let attachments: [Attachment]
}
