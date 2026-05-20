// CaptureFlowUITests.swift — App/Tests/AppUITests
// Copyright 2026 sunghun.ahn — Still Hours
// Sprint 1.8 — XCUITest smoke tests: capture happy path
// Created: 2026-05-21

import XCTest

// MARK: - CaptureFlowUITests

/// End-to-end smoke tests for the Capture flow (Manual mode) and Library tab.
///
/// Tests run against the compiled app binary. Accessibility labels are sourced
/// from the localization default values used in CaptureSheet, ManualCaptureView,
/// LibraryListView, and ContentView.
@MainActor
final class CaptureFlowUITests: XCTestCase {

    // MARK: Setup

    var app: XCUIApplication!

    override func setUpWithError() throws {
        continueAfterFailure = false
        app = XCUIApplication()
        // R11A.2: --reset-onboarding clears hasCompletedOnboarding so onboarding
        // does not block these tests. StillHoursApp.init() handles this flag.
        UITestHelpers.launchAppForTesting(app, resetOnboarding: true)
    }

    override func tearDownWithError() throws {
        app = nil
    }

    // MARK: - test_appLaunches_showsLibraryTab

    /// Verifies the app starts on the Library tab with either the empty state
    /// or a populated grid visible.
    func test_appLaunches_showsLibraryTab() throws {
        // The Library tab button is always present in the tab bar.
        let libraryTab = app.buttons["Library"]
        XCTAssertTrue(
            libraryTab.waitForExistence(timeout: 5),
            "Library tab button should exist in the tab bar."
        )
        // Either the empty-state label or the navigation title "Library" confirms
        // we are on the correct tab.
        let emptyLabel = app.staticTexts["Your library is empty"]
        let navTitle   = app.navigationBars["Library"]
        let isOnLibraryTab = emptyLabel.exists || navTitle.waitForExistence(timeout: 5)
        XCTAssertTrue(isOnLibraryTab, "Library tab should be the initial landing screen.")
    }

    // MARK: - test_capturePlusButton_opensSheet

    /// Taps the "+" toolbar button and confirms the capture sheet is presented.
    func test_capturePlusButton_opensSheet() throws {
        // The toolbar "+" button uses systemImage "plus" and has the
        // accessibility label "Capture your first item" (library.empty.cta key).
        // Fall back to first occurrence of that image button in the nav bar.
        let plusButton = app.buttons["Capture your first item"]
        XCTAssertTrue(
            plusButton.waitForExistence(timeout: 5),
            "'+' capture button should be visible in the Library toolbar."
        )
        plusButton.tap()

        // CaptureSheet presents a "Close" button (capture.close default value).
        let closeButton = app.buttons["Close"]
        let appeared = closeButton.waitForExistence(timeout: 5)
        XCTAssertTrue(appeared, "Capture sheet should present with a Close button.")
    }

    // MARK: - test_manualMode_savesNewItem

    /// Opens the capture sheet, enters a title, saves, and checks the item appears
    /// in the library list.
    func test_manualMode_savesNewItem() throws {
        let plusButton = app.buttons["Capture your first item"]
        XCTAssertTrue(
            plusButton.waitForExistence(timeout: 5),
            "'+' capture button must exist before tapping."
        )
        plusButton.tap()

        // Manual mode is the default; the Title field should be immediately present.
        let titleField = app.textFields["Title"]
        XCTAssertTrue(
            titleField.waitForExistence(timeout: 5),
            "Title text field should appear in Manual capture mode."
        )
        titleField.tap()
        titleField.typeText("Test Book")

        // Tap Save (capture.save default value; button is in the bottom action bar).
        let saveButton = app.buttons["Save"]
        XCTAssertTrue(saveButton.waitForExistence(timeout: 5), "Save button should be enabled.")
        saveButton.tap()

        // Sheet should dismiss after save; poll for the Library nav bar to reappear.
        let libraryNav = app.navigationBars["Library"]
        let dismissed = libraryNav.waitForExistence(timeout: 5)
        XCTAssertTrue(dismissed, "Capture sheet should dismiss after saving.")

        // "Test Book" should appear somewhere in the library.
        // TODO: ModelContext propagation may be async — extend timeout if flaky in CI.
        let savedItem = app.staticTexts["Test Book"]
        let visible = savedItem.waitForExistence(timeout: 5)
        XCTAssertTrue(visible, "Newly saved item 'Test Book' should appear in the library.")
    }

    // MARK: - test_capturePlusButton_cancelDismissesSheet

    /// Opens the capture sheet and cancels via the Close button.
    func test_capturePlusButton_cancelDismissesSheet() throws {
        let plusButton = app.buttons["Capture your first item"]
        XCTAssertTrue(
            plusButton.waitForExistence(timeout: 5),
            "'+' capture button must exist."
        )
        plusButton.tap()

        let closeButton = app.buttons["Close"]
        XCTAssertTrue(
            closeButton.waitForExistence(timeout: 5),
            "Close button should appear after sheet presentation."
        )
        closeButton.tap()

        // After dismissal the sheet's Close button should no longer exist.
        let waiterResult = XCTWaiter.wait(
            for: [XCTNSPredicateExpectation(
                predicate: NSPredicate(format: "exists == false"),
                object: closeButton
            )],
            timeout: 5
        )
        XCTAssertEqual(waiterResult, .completed, "Capture sheet should dismiss after tapping Close.")
    }

    // MARK: - test_settingsTab_isReachable

    /// Navigates to the Settings tab and verifies it loads successfully.
    func test_settingsTab_isReachable() throws {
        let settingsTab = app.buttons["Settings"]
        XCTAssertTrue(
            settingsTab.waitForExistence(timeout: 5),
            "Settings tab button should exist in the tab bar."
        )
        settingsTab.tap()

        // SettingsRootView is embedded in a NavigationStack; its nav bar title
        // confirms successful navigation. "About", "Data", or "Help" sections
        // are implementation details — verify the nav bar as a stable anchor.
        // TODO: Add section-level assertions once SettingsRootView exposes stable
        //       accessibility identifiers for About / Data / Help rows.
        let settingsNav = app.navigationBars["Settings"]
        XCTAssertTrue(
            settingsNav.waitForExistence(timeout: 5),
            "Settings navigation bar should appear after tapping the Settings tab."
        )
    }
}
