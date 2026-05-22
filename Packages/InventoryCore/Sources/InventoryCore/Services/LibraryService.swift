// LibraryService.swift — InventoryCore/Services
// Copyright 2026 sunghun.ahn — Still Hours v0.1 MVP
// Pre-flight Round 4: InventoryService layer
// Created: 2026-05-20
// LINT-IGNORE: Privacy — no external URL

import Foundation
import SwiftData

// MARK: - Supporting Types

/// Axes along which ``LibraryService/listItems(sortBy:filterBy:)`` may sort.
public enum ItemSortKey: Sendable {
    case title
    case createdAt
    case updatedAt
    case year
}

/// Criteria passed to ``LibraryService/listItems(sortBy:filterBy:)``.
public struct ItemFilter: Sendable {
    public var medium: Medium?
    public var state: ItemState?
    public var tag: String?

    public init(medium: Medium? = nil, state: ItemState? = nil, tag: String? = nil) {
        self.medium = medium
        self.state = state
        self.tag = tag
    }
}

// MARK: - LibraryService

/// Actor-isolated service for all ``Item`` CRUD operations.
///
/// `ModelContext` is injected at initialisation and never crosses
/// the actor boundary — callers hold only Sendable plain values.
///
/// Swift 6 note: Switched from `actor` to `@MainActor final class` —
/// SwiftData's `ModelContext` is bound to the main actor when injected
/// via `@Environment(\.modelContext)`. Routing it through a separate
/// actor produces "sending self.modelContext risks data races" at every
/// callsite. Same rationale as `ExportService` / `TimelineService`.
@available(iOS 26, macOS 26, *)
@MainActor
public final class LibraryService {

    // MARK: Stored Properties

    private let context: ModelContext

    // MARK: Initialiser

    public init(context: ModelContext) {
        self.context = context
    }

    // MARK: Write

    /// Inserts a new ``Item`` into the persistent store.
    ///
    /// - Parameter item: The fully-constructed item to persist.
    /// - Throws: ``ServiceError/invalidInput(_:)`` if `title` is empty,
    ///   ``ServiceError/persistFailed(underlying:)`` on save failure.
    public func addItem(_ item: Item) async throws {
        guard !item.title.trimmingCharacters(in: .whitespaces).isEmpty else {
            throw ServiceError.invalidInput("title")
        }
        context.insert(item)
        do {
            try context.save()
        } catch {
            throw ServiceError.persistFailed(underlying: error)
        }
    }

    /// Removes an ``Item`` (and its cascaded ``Memory`` / ``Attachment`` records) from the store.
    ///
    /// - Parameter item: The item to delete.
    /// - Throws: ``ServiceError/persistFailed(underlying:)`` on save failure.
    public func deleteItem(_ item: Item) async throws {
        context.delete(item)
        do {
            try context.save()
        } catch {
            throw ServiceError.persistFailed(underlying: error)
        }
    }

    /// Applies an in-place mutation closure to an ``Item`` then saves.
    ///
    /// - Parameters:
    ///   - item: The item to mutate.
    ///   - mutations: A closure that mutates the item's properties.
    /// - Throws: ``ServiceError/persistFailed(underlying:)`` on save failure.
    public func updateItem(_ item: Item, mutations: (Item) -> Void) async throws {
        mutations(item)
        item.updatedAt = Date()
        do {
            try context.save()
        } catch {
            throw ServiceError.persistFailed(underlying: error)
        }
    }

    // MARK: Read

    /// Fetches all items, applying optional sort and filter criteria.
    ///
    /// - Parameters:
    ///   - sortBy: Primary sort axis (default: `.title`).
    ///   - filterBy: Optional filter criteria; `nil` fields are ignored.
    /// - Returns: A sorted, filtered array of ``Item`` objects.
    public func listItems(
        sortBy: ItemSortKey = .title,
        filterBy filter: ItemFilter? = nil
    ) async throws -> [Item] {
        var descriptor = FetchDescriptor<Item>()

        switch sortBy {
        case .title:
            descriptor.sortBy = [SortDescriptor(\.title)]
        case .createdAt:
            descriptor.sortBy = [SortDescriptor(\.createdAt)]
        case .updatedAt:
            descriptor.sortBy = [SortDescriptor(\.updatedAt, order: .reverse)]
        case .year:
            descriptor.sortBy = [SortDescriptor(\.year)]
        }

        let all = try context.fetch(descriptor)

        guard let filter else { return all }

        return all.filter { item in
            if let medium = filter.medium, item.medium != medium { return false }
            if let state = filter.state, item.state != state { return false }
            if let tag = filter.tag, !item.tags.contains(tag) { return false }
            return true
        }
    }

    /// Full-text search across `title`, `creator`, and `tags`.
    ///
    /// - Parameter query: A non-empty search string.
    /// - Returns: Items whose title, creator, or tags contain `query` (case-insensitive).
    /// - Throws: ``ServiceError/invalidInput(_:)`` if `query` is blank.
    public func searchItems(query: String) async throws -> [Item] {
        let trimmed = query.trimmingCharacters(in: .whitespaces)
        guard !trimmed.isEmpty else { throw ServiceError.invalidInput("query") }

        let lowercased = trimmed.lowercased()
        let all = try context.fetch(FetchDescriptor<Item>())
        return all.filter { item in
            item.title.lowercased().contains(lowercased)
            || (item.creator?.lowercased().contains(lowercased) == true)
            || item.tags.contains { $0.lowercased().contains(lowercased) }
        }
    }

    // MARK: Relationship Helpers

    /// Attaches a ``Memory`` to an ``Item`` and saves.
    ///
    /// - Parameters:
    ///   - memory: The memory to attach.
    ///   - item: The owning item.
    public func attachMemory(_ memory: Memory, to item: Item) async throws {
        memory.item = item
        if !item.memories.contains(where: { $0.id == memory.id }) {
            item.memories.append(memory)
        }
        do {
            try context.save()
        } catch {
            throw ServiceError.persistFailed(underlying: error)
        }
    }

    /// Applies an in-place mutation closure to an existing ``Memory`` then saves.
    ///
    /// - Parameters:
    ///   - memory: The memory to mutate.
    ///   - mutations: A closure that mutates the memory's properties.
    /// - Throws: ``ServiceError/persistFailed(underlying:)`` on save failure.
    public func updateMemory(_ memory: Memory, mutations: (Memory) -> Void) async throws {
        mutations(memory)
        do {
            try context.save()
        } catch {
            throw ServiceError.persistFailed(underlying: error)
        }
    }

    /// Deletes a ``Memory`` from its owning ``Item`` and the persistent store.
    ///
    /// - Parameter memory: The memory to delete.
    /// - Throws: ``ServiceError/persistFailed(underlying:)`` on save failure.
    public func deleteMemory(_ memory: Memory) async throws {
        context.delete(memory)
        do {
            try context.save()
        } catch {
            throw ServiceError.persistFailed(underlying: error)
        }
    }

    /// Detaches a ``Memory`` from its owning ``Item`` without deleting it.
    ///
    /// - Parameter memory: The memory to detach.
    public func detachMemory(_ memory: Memory) async throws {
        memory.item = nil
        do {
            try context.save()
        } catch {
            throw ServiceError.persistFailed(underlying: error)
        }
    }

    /// Adds an ``Item`` to a ``Collection`` and appends its ID to `itemOrder`.
    ///
    /// - Parameters:
    ///   - item: The item to add.
    ///   - collection: The destination collection.
    public func attachToCollection(_ item: Item, collection: Collection) async throws {
        if !collection.items.contains(where: { $0.id == item.id }) {
            collection.items.append(item)
            collection.itemOrder.append(item.id)
        }
        collection.updatedAt = Date()
        do {
            try context.save()
        } catch {
            throw ServiceError.persistFailed(underlying: error)
        }
    }
}
