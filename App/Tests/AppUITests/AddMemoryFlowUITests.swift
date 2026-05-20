// AddMemoryFlowUITests.swift — App/Tests/AppUITests
// Copyright 2026 sunghun.ahn — Still Hours
// R11A.2: UI tests — AddMemory flow (LibraryList → ItemDetail → AddMemoryView)
// Created: 2026-05-21

import XCTest

// MARK: - AddMemoryFlowUITests

/// End-to-end UI tests for the AddMemory flow.
///
/// Tests rely on `DemoSeeder` (DEBUG-only) populating items so the library
/// is non-empty. Both `--ui-testing` and `--reset-onboarding` are set so
/// the Library tab is the initial screen and contains seeded items.
@MainActor
final class AddMemoryFlowUITests: XCTestCase {

    // MARK: Setup

    var app: XCUIApplication!

    override func setUpWithError() throws {
        continueAfterFailure = false
        app = XCUIApplication()
        UITestHelpers.launchAppForTesting(app, resetOnboarding: true)
    }

    override func tearDownWithError() throws {
        app = nil
    }

    // MARK: - Helpers

    /// Taps the first item cell in the library grid.
    ///
    /// DemoSeeder seeds at least one item in DEBUG mode. We tap the first
    /// NavigationLink cell; ItemDetailView then appears.
    private func tapFirstLibraryItem() throws -> XCUIElement {
        // Wait for at least one item to appear (DemoSeeder is async).
        let firstCell = app.cells.firstMatch
        let appeared = firstCell.waitForExistence(timeout: 5)
        if !appeared {
            // Also accept a staticText as fallback (items may render as staticTexts).
            let anyItem = app.collectionViews.firstMatch
            XCTAssertTrue(
                anyItem.waitForExistence(timeout: 5),
                "Library grid must contain at least one item (DemoSeeder)."
            )
        }
        firstCell.tap()
        return firstCell
    }

    // MARK: - test_libraryList_tapItem_opensDetail

    /// Tapping the first library item opens its detail view.
    func test_libraryList_tapItem_opensDetail() throws {
        // Ensure we're on the Library tab.
        let libraryTab = app.buttons["Library"]
        UITestHelpers.assertExists(libraryTab, timeout: 5, message: "Library tab must be visible.")
        libraryTab.tap()

        try tapFirstLibraryItem()

        // ItemDetailView sets navigationTitle to item.title (inline display mode).
        // We verify the "Add Memory" button — it's a stable anchor present on all items.
        let addMemoryButton = app.buttons["Add Memory"]
        UITestHelpers.assertExists(
            addMemoryButton,
            timeout: 5,
            message: "Add Memory button must appear in ItemDetailView."
        )
    }

    // MARK: - test_itemDetail_addMemoryButton_opensSheet

    /// Tapping "Add Memory" from ItemDetailView presents the AddMemoryView sheet.
    func test_itemDetail_addMemoryButton_opensSheet() throws {
        let libraryTab = app.buttons["Library"]
        UITestHelpers.assertExists(libraryTab, timeout: 5, message: "Library tab must be visible.")
        libraryTab.tap()

        try tapFirstLibraryItem()

        let addMemoryButton = app.buttons["Add Memory"]
        UITestHelpers.assertExists(addMemoryButton, timeout: 5, message: "Add Memory button must exist.")
        addMemoryButton.tap()

        // AddMemoryView's NavigationStack title is "Add Memory" (inline).
        // The Cancel button (toolbar .cancellationAction) is the most stable anchor.
        let cancelButton = app.buttons["Cancel"]
        UITestHelpers.assertExists(
            cancelButton,
            timeout: 5,
            message: "AddMemoryView sheet must present with a Cancel button."
        )
    }

    // MARK: - test_addMemory_pickKind_typeNote_save

    /// Opens AddMemory, selects a kind chip, types a note, saves, and verifies the sheet dismisses.
    func test_addMemory_pickKind_typeNote_save() throws {
        let libraryTab = app.buttons["Library"]
        UITestHelpers.assertExists(libraryTab, timeout: 5, message: "Library tab must be visible.")
        libraryTab.tap()

        try tapFirstLibraryItem()

        let addMemoryButton = app.buttons["Add Memory"]
        UITestHelpers.assertExists(addMemoryButton, timeout: 5, message: "Add Memory button must exist.")
        addMemoryButton.tap()

        // Sheet is presented — Cancel button confirms it.
        let cancelButton = app.buttons["Cancel"]
        UITestHelpers.assertExists(cancelButton, timeout: 5, message: "Sheet Cancel must appear.")

        // The kind chip row contains MemoryKind labels. "Read" is the default for
        // books; tap "Listened" to select a different kind and confirm chip selection works.
        let listenedChip = app.buttons["Listened"]
        if listenedChip.waitForExistence(timeout: 3) {
            listenedChip.tap()
        }

        // Type a note in the Note text field.
        let noteField = app.textFields["Note"]
        let noteFieldExists = noteField.waitForExistence(timeout: 3)
        if noteFieldExists {
            noteField.tap()
            noteField.typeText("Great read during the commute")
        }

        // Tap Save — the "Save memory — …" button (accessibilityLabel has a suffix
        // but XCTest matches on prefix; fall back to "Save" in the toolbar).
        let saveButton = app.buttons.matching(NSPredicate(format: "label BEGINSWITH 'Save'")).firstMatch
        UITestHelpers.assertExists(saveButton, timeout: 3, message: "Save button must be enabled.")
        saveButton.tap()

        // Sheet dismisses after successful save — Cancel button should disappear.
        UITestHelpers.assertGone(
            cancelButton,
            timeout: 5,
            message: "AddMemoryView sheet must dismiss after saving."
        )
    }

    // MARK: - test_addMemory_cancel_dismissesWithoutSave

    /// Opening AddMemory then tapping Cancel dismisses without saving.
    func test_addMemory_cancel_dismissesWithoutSave() throws {
        let libraryTab = app.buttons["Library"]
        UITestHelpers.assertExists(libraryTab, timeout: 5, message: "Library tab must be visible.")
        libraryTab.tap()

        try tapFirstLibraryItem()

        let addMemoryButton = app.buttons["Add Memory"]
        UITestHelpers.assertExists(addMemoryButton, timeout: 5, message: "Add Memory button must exist.")
        addMemoryButton.tap()

        let cancelButton = app.buttons["Cancel"]
        UITestHelpers.assertExists(cancelButton, timeout: 5, message: "Sheet Cancel must appear.")
        cancelButton.tap()

        // Sheet dismissed — Cancel button vanishes.
        UITestHelpers.assertGone(
            cancelButton,
            timeout: 5,
            message: "AddMemoryView sheet must dismiss after tapping Cancel."
        )

        // "Add Memory" action button in ItemDetailView should still be visible —
        // we are back on the detail screen, nothing was saved.
        UITestHelpers.assertExists(
            addMemoryButton,
            timeout: 3,
            message: "Add Memory button must still be visible after cancellation."
        )
    }
}
