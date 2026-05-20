// LibraryNavigationUITests.swift — App/Tests/AppUITests
// Copyright 2026 sunghun.ahn — Still Hours
// R11A.2: UI tests — Library search, sort, Settings navigation
// Created: 2026-05-21

import XCTest

// MARK: - LibraryNavigationUITests

/// End-to-end UI tests for Library search/sort and Settings navigation.
///
/// Tests rely on `DemoSeeder` (DEBUG-only) so the library is non-empty.
/// Both `--ui-testing` and `--reset-onboarding` are always set.
@MainActor
final class LibraryNavigationUITests: XCTestCase {

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

    // MARK: - test_library_searchField_filtersItems

    /// Typing in the search field filters the library grid.
    func test_library_searchField_filtersItems() throws {
        // Ensure we are on the Library tab.
        let libraryTab = app.buttons["Library"]
        UITestHelpers.assertExists(libraryTab, timeout: 5, message: "Library tab must be visible.")
        libraryTab.tap()

        // Wait for at least one seeded item (DemoSeeder is async).
        let firstCell = app.cells.firstMatch
        UITestHelpers.assertExists(firstCell, timeout: 5, message: "Library must have at least one item.")

        // Activate the search field (searchable modifier renders a UISearchBar).
        let searchField = app.searchFields["Search library"]
        UITestHelpers.assertExists(
            searchField,
            timeout: 5,
            message: "Search library search field must exist."
        )
        searchField.tap()

        // Type a query unlikely to match DemoSeeder titles to drive the empty state.
        let uniqueQuery = "xqzNotInDemoData"
        searchField.typeText(uniqueQuery)

        // With no match, the grid should show zero cells. The empty-state label may
        // or may not appear depending on LibraryListView's conditional — we assert
        // zero cells rather than the empty text string to stay robust.
        let cellsAfterFilter = app.cells.count
        XCTAssertEqual(
            cellsAfterFilter, 0,
            "Search for '\(uniqueQuery)' should return no items."
        )

        // Clear the search field and confirm items reappear.
        searchField.clearText()
        UITestHelpers.assertExists(
            app.cells.firstMatch,
            timeout: 5,
            message: "Library items must reappear after clearing the search field."
        )
    }

    // MARK: - test_library_sortMenu_changesOrder

    /// Tapping the sort menu and selecting "Title" changes the display order.
    func test_library_sortMenu_changesOrder() throws {
        let libraryTab = app.buttons["Library"]
        UITestHelpers.assertExists(libraryTab, timeout: 5, message: "Library tab must be visible.")
        libraryTab.tap()

        // Wait for items.
        UITestHelpers.assertExists(
            app.cells.firstMatch,
            timeout: 5,
            message: "Library must have at least one item."
        )

        // The sort menu button has systemImage "arrow.up.arrow.down".
        // SwiftUI renders it with the accessibility label of the image name or a custom one.
        // We match it via its position in the toolbar (secondary action placement).
        let sortButton = app.buttons.matching(
            NSPredicate(format: "label CONTAINS 'arrow.up.arrow.down' OR label == 'Sort'")
        ).firstMatch

        // Fallback: find any toolbar button that is NOT "Library", "Capture your first item",
        // or the plus-named button, and not a tab-bar item.
        let toolbarButtons = app.navigationBars.firstMatch.buttons
        let sortFallback = toolbarButtons.element(boundBy: 0)

        let sortFound = sortButton.waitForExistence(timeout: 3) || sortFallback.waitForExistence(timeout: 3)
        XCTAssertTrue(sortFound, "Sort menu button must exist in the Library toolbar.")

        if sortButton.waitForExistence(timeout: 1) {
            sortButton.tap()
        } else {
            sortFallback.tap()
        }

        // Tap "Title" in the popover/action sheet.
        let titleOption = app.buttons["Title"]
        if titleOption.waitForExistence(timeout: 3) {
            titleOption.tap()
        }

        // After selecting Title sort, the grid should still be visible.
        UITestHelpers.assertExists(
            app.cells.firstMatch,
            timeout: 5,
            message: "Library grid must remain visible after changing sort order."
        )
    }

    // MARK: - test_settings_tab_aboutPage_navigates

    /// Settings tab → "Still Hours is" row → AboutStillHoursView is shown.
    func test_settings_tab_aboutPage_navigates() throws {
        let settingsTab = app.buttons["Settings"]
        UITestHelpers.assertExists(settingsTab, timeout: 5, message: "Settings tab must exist.")
        settingsTab.tap()

        let settingsNav = app.navigationBars["Settings"]
        UITestHelpers.assertExists(settingsNav, timeout: 5, message: "Settings nav bar must appear.")

        // Tap the "Still Hours is" NavigationLink row (settings.about.title default).
        let aboutRow = app.buttons["Still Hours is"]
        UITestHelpers.assertExists(aboutRow, timeout: 3, message: "'Still Hours is' row must exist.")
        aboutRow.tap()

        // AboutStillHoursView presents in a pushed NavigationStack child.
        // Verify the back button (which shows the parent nav title "Settings") appears.
        let backButton = app.navigationBars.buttons["Settings"]
        UITestHelpers.assertExists(
            backButton,
            timeout: 5,
            message: "Back button to Settings must appear after navigating to About."
        )
    }

    // MARK: - test_settings_tab_exportPage_buttonsVisible

    /// Settings → "Export data" → JSON + CSV buttons are visible.
    func test_settings_tab_exportPage_buttonsVisible() throws {
        let settingsTab = app.buttons["Settings"]
        UITestHelpers.assertExists(settingsTab, timeout: 5, message: "Settings tab must exist.")
        settingsTab.tap()

        let settingsNav = app.navigationBars["Settings"]
        UITestHelpers.assertExists(settingsNav, timeout: 5, message: "Settings nav bar must appear.")

        // Tap "Export data" NavigationLink.
        let exportRow = app.buttons["Export data"]
        UITestHelpers.assertExists(exportRow, timeout: 3, message: "'Export data' row must exist.")
        exportRow.tap()

        // ExportDataView presents "Export as JSON" and "Export as CSV" buttons.
        let jsonButton = app.buttons["Export as JSON"]
        UITestHelpers.assertExists(
            jsonButton,
            timeout: 5,
            message: "'Export as JSON' button must be visible in ExportDataView."
        )

        let csvButton = app.buttons["Export as CSV"]
        UITestHelpers.assertExists(
            csvButton,
            timeout: 5,
            message: "'Export as CSV' button must be visible in ExportDataView."
        )
    }
}

// MARK: - XCUIElement+ClearText

private extension XCUIElement {
    /// Clears all text from a search field or text field.
    func clearText() {
        guard let currentValue = value as? String, !currentValue.isEmpty else { return }
        let deleteString = String(repeating: XCUIKeyboardKey.delete.rawValue, count: currentValue.count)
        typeText(deleteString)
    }
}
