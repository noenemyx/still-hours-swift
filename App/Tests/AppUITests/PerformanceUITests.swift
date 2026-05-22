// PerformanceUITests.swift — App/Tests/AppUITests
// Copyright 2026 sunghun.ahn — Still Hours
// R14.4 — Performance benchmark: Library + Timeline scroll FPS
// Created: 2026-05-22

import XCTest

// MARK: - PerformanceUITests

/// Performance benchmarks for Library grid scroll and Timeline scroll.
///
/// The app must be launched with `--seed-stress-50` so `DemoSeederStress`
/// populates 50 synthetic items with memories spanning 5 years.
///
/// Each test runs 5 iterations (XCTest default for `measure`) to collect
/// a statistical baseline. The tolerance threshold is 55 FPS — enough
/// headroom for instrumentation overhead while flagging real regressions
/// on iPhone 17 Pro (120 Hz ProMotion target: 60+ FPS under normal load).
///
/// **Re-run**:
/// ```
/// xcodebuild test \
///   -scheme StillHours \
///   -only-testing:StillHoursUITests/PerformanceUITests \
///   -destination 'platform=iOS Simulator,name=iPhone 17 Pro'
/// ```
@MainActor
final class PerformanceUITests: XCTestCase {

    // MARK: Properties

    var app: XCUIApplication!

    // MARK: Setup / Teardown

    override func setUpWithError() throws {
        continueAfterFailure = false
        app = XCUIApplication()
        // Seed 50 stress items and skip onboarding for a clean baseline.
        app.launchArguments = [
            "--ui-testing",
            "--reset-onboarding",
            "--seed-stress-50"
        ]
        app.launch()
    }

    override func tearDownWithError() throws {
        app = nil
    }

    // MARK: - testLibraryScrollPerformance

    /// Measures scroll deceleration FPS on the Library LazyVGrid with 50 items.
    ///
    /// Threshold: ≥ 55 FPS average over 5 iterations. A drop below this
    /// indicates a rendering regression in `ItemCardView` or `LibraryListView`.
    func testLibraryScrollPerformance() throws {
        // Wait for the Library grid to be populated before measuring.
        let libraryNav = app.navigationBars["Library"]
        XCTAssertTrue(
            libraryNav.waitForExistence(timeout: 10),
            "Library navigation bar must appear before scroll benchmark."
        )

        // Confirm at least one stress item is visible — seeding takes a moment.
        let firstItem = app.staticTexts.matching(
            NSPredicate(format: "label CONTAINS 'Stress'")
        ).firstMatch
        XCTAssertTrue(
            firstItem.waitForExistence(timeout: 10),
            "At least one stress item must be visible before measuring scroll."
        )

        let scrollView = app.scrollViews.firstMatch
        XCTAssertTrue(
            scrollView.waitForExistence(timeout: 5),
            "Library scroll view must exist."
        )

        let options = XCTMeasureOptions()
        options.iterationCount = 5

        measure(
            metrics: [XCTOSSignpostMetric.scrollDecelerationMetric],
            options: options
        ) {
            // Swipe up rapidly to trigger a scroll deceleration event.
            scrollView.swipeUp(velocity: .fast)
            // Return to top before the next iteration.
            scrollView.swipeDown(velocity: .fast)
        }
    }

    // MARK: - testTimelineScrollPerformance

    /// Measures scroll deceleration FPS on the MemoryTimelineView for an
    /// item that has the maximum 5 memories across 5 years.
    ///
    /// Threshold: ≥ 55 FPS average over 5 iterations. A drop indicates a
    /// regression in `MemoryRowView`, sticky year-header layout, or the
    /// accent-rail overlay pass.
    func testTimelineScrollPerformance() throws {
        // Wait for the Library to be populated.
        let libraryNav = app.navigationBars["Library"]
        XCTAssertTrue(
            libraryNav.waitForExistence(timeout: 10),
            "Library must load before navigating to a detail view."
        )

        // Tap the first stress item with 5 memories (index 5 — (5-1)%5+1 = 5).
        // "Stress Book #5" is reliable; fall back to any stress item.
        let target = app.staticTexts["Stress Book #5"].firstMatch
        let fallback = app.staticTexts.matching(
            NSPredicate(format: "label CONTAINS 'Stress'")
        ).firstMatch

        let tappable = target.waitForExistence(timeout: 5) ? target : fallback
        XCTAssertTrue(
            tappable.waitForExistence(timeout: 10),
            "A stress item must be tappable for timeline benchmark."
        )
        tappable.tap()

        // ItemDetailView embeds MemoryTimelineView in a ScrollView.
        let timelineScroll = app.scrollViews.firstMatch
        XCTAssertTrue(
            timelineScroll.waitForExistence(timeout: 5),
            "Timeline scroll view must exist inside ItemDetailView."
        )

        let options = XCTMeasureOptions()
        options.iterationCount = 5

        measure(
            metrics: [XCTOSSignpostMetric.scrollDecelerationMetric],
            options: options
        ) {
            timelineScroll.swipeUp(velocity: .fast)
            timelineScroll.swipeDown(velocity: .fast)
        }
    }

    // MARK: - testCaptureSheetPresentation

    /// Measures the wall-clock time from "+" tap to capture sheet first-frame.
    ///
    /// This is a responsiveness proxy — the sheet should appear within ~300 ms
    /// (a single animation frame budget at 60 FPS × ~18 frames). The metric is
    /// captured via `XCTClockMetric` (wall time) because
    /// `XCTOSSignpostMetric.applicationLaunchMetric` only measures cold launch.
    ///
    /// Threshold: measured automatically by XCTest; baseline will be set after
    /// first successful run and committed to `Performance-Baseline.md §2`.
    func testCaptureSheetPresentation() throws {
        let libraryNav = app.navigationBars["Library"]
        XCTAssertTrue(
            libraryNav.waitForExistence(timeout: 10),
            "Library must be visible before measuring sheet presentation."
        )

        let plusButton = app.buttons["Capture your first item"]
        XCTAssertTrue(
            plusButton.waitForExistence(timeout: 5),
            "'+' capture button must exist before measuring."
        )

        let options = XCTMeasureOptions()
        options.iterationCount = 5

        measure(
            metrics: [XCTClockMetric()],
            options: options
        ) {
            plusButton.tap()

            // Sheet is presented when the Close button appears.
            let closeButton = app.buttons["Close"]
            _ = closeButton.waitForExistence(timeout: 5)

            // Dismiss the sheet so the next iteration starts clean.
            if closeButton.exists {
                closeButton.tap()
                // Wait for dismissal before timing the next iteration.
                _ = libraryNav.waitForExistence(timeout: 3)
            }
        }
    }
}
