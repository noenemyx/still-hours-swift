// OnboardingFlowUITests.swift — App/Tests/AppUITests
// Copyright 2026 sunghun.ahn — Still Hours
// R11A.2: UI tests — OnboardingFlow (3-step)
// Created: 2026-05-21

import XCTest

// MARK: - OnboardingFlowUITests

/// End-to-end UI tests for the 3-step OnboardingFlow.
///
/// Each test resets `hasCompletedOnboarding` via the `--reset-onboarding`
/// launch argument handled in `StillHoursApp.init()`. Without that flag the
/// onboarding gate stays closed after the first run and all tests would start
/// on the Library tab instead.
@MainActor
final class OnboardingFlowUITests: XCTestCase {

    // MARK: Setup

    var app: XCUIApplication!

    override func setUpWithError() throws {
        continueAfterFailure = false
        app = XCUIApplication()
        // Do NOT reset onboarding here — each test opts in individually so we can
        // test the "already-completed" path in test_onboarding_skip_dismisses.
    }

    override func tearDownWithError() throws {
        app = nil
    }

    // MARK: - test_onboarding_firstLaunch_showsScreen1

    /// Fresh install shows the first onboarding page.
    func test_onboarding_firstLaunch_showsScreen1() throws {
        // --reset-onboarding clears UserDefaults so Screen 1 renders.
        app.launchArguments += ["--ui-testing", "--reset-onboarding"]
        app.launch()

        // Screen 1 "Next" button is the most stable anchor — it exists only
        // on the first onboarding page. TabView page-style hides the other pages.
        let nextButton = app.buttons["Next"]
        UITestHelpers.assertExists(
            nextButton,
            timeout: 5,
            message: "Screen 1 'Next' button must appear on first launch."
        )

        // Confirm the Library tab is NOT yet visible (gate is closed).
        let libraryTab = app.buttons["Library"]
        XCTAssertFalse(
            libraryTab.waitForExistence(timeout: 2),
            "Library tab should NOT be visible while onboarding is active."
        )
    }

    // MARK: - test_onboarding_skip_dismisses

    /// Tapping Skip dismisses onboarding and lands on the Library tab.
    func test_onboarding_skip_dismisses() throws {
        app.launchArguments += ["--ui-testing", "--reset-onboarding"]
        app.launch()

        let skipButton = app.buttons["Skip"]
        UITestHelpers.assertExists(
            skipButton,
            timeout: 5,
            message: "Skip button must be visible on Screen 1 and 2."
        )
        skipButton.tap()

        // After skip, hasCompletedOnboarding is persisted and the Library appears.
        let libraryTab = app.buttons["Library"]
        UITestHelpers.assertExists(
            libraryTab,
            timeout: 5,
            message: "Library tab should appear after tapping Skip."
        )

        // Verify persistence: terminate and relaunch WITHOUT --reset-onboarding.
        // The onboarding should NOT show again.
        app.terminate()
        let app2 = XCUIApplication()
        app2.launchArguments.append("--ui-testing")
        app2.launch()

        let libraryTab2 = app2.buttons["Library"]
        UITestHelpers.assertExists(
            libraryTab2,
            timeout: 5,
            message: "Library tab must appear on second launch — onboarding completed flag persists."
        )
        app2.terminate()
    }

    // MARK: - test_onboarding_nextNextGetStarted_dismisses

    /// Tapping Next twice then Get Started completes onboarding.
    func test_onboarding_nextNextGetStarted_dismisses() throws {
        app.launchArguments += ["--ui-testing", "--reset-onboarding"]
        app.launch()

        // Screen 1 → tap Next
        let nextButton = app.buttons["Next"]
        UITestHelpers.assertExists(nextButton, timeout: 5, message: "Screen 1 Next must exist.")
        nextButton.tap()

        // Screen 2 → tap Next (same label; page has advanced)
        let nextButton2 = app.buttons["Next"]
        UITestHelpers.assertExists(
            nextButton2,
            timeout: 3,
            message: "Screen 2 Next must exist after advancing from Screen 1."
        )
        nextButton2.tap()

        // Screen 3 → tap Get Started
        let getStartedButton = app.buttons["Get Started"]
        UITestHelpers.assertExists(
            getStartedButton,
            timeout: 3,
            message: "Get Started button must appear on Screen 3."
        )
        getStartedButton.tap()

        // Library tab must now be visible.
        let libraryTab = app.buttons["Library"]
        UITestHelpers.assertExists(
            libraryTab,
            timeout: 5,
            message: "Library tab must appear after completing all 3 onboarding screens."
        )
    }

    // MARK: - test_onboarding_pageIndicatorAdvances

    /// Swiping between onboarding pages advances the TabView page indicator.
    func test_onboarding_pageIndicatorAdvances() throws {
        app.launchArguments += ["--ui-testing", "--reset-onboarding"]
        app.launch()

        // Confirm we are on Screen 1 by verifying Next exists.
        let nextScreen1 = app.buttons["Next"]
        UITestHelpers.assertExists(nextScreen1, timeout: 5, message: "Screen 1 Next must exist before swipe.")

        // Swipe left to advance to Screen 2.
        app.swipeLeft()

        // After swiping, Screen 2's Next button remains "Next" (same label).
        // We verify the Skip button is still visible (it appears on pages 0 and 1).
        let skipAfterSwipe = app.buttons["Skip"]
        UITestHelpers.assertExists(
            skipAfterSwipe,
            timeout: 3,
            message: "Skip button must still be visible on Screen 2 after swiping."
        )

        // Swipe left again to reach Screen 3.
        app.swipeLeft()

        // On Screen 3 the Get Started button replaces Next, and Skip disappears.
        let getStarted = app.buttons["Get Started"]
        UITestHelpers.assertExists(
            getStarted,
            timeout: 3,
            message: "Get Started must appear on Screen 3 after two left swipes."
        )

        // Skip is hidden on page 2 (per OnboardingFlow: currentPage < 2).
        let skipPage3 = app.buttons["Skip"]
        XCTAssertFalse(
            skipPage3.waitForExistence(timeout: 2),
            "Skip button must be hidden on Screen 3."
        )
    }
}
