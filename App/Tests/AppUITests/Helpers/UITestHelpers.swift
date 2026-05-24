// UITestHelpers.swift — App/Tests/AppUITests/Helpers
// Copyright 2026 sunghun.ahn — Still Hours
// R11A.2: Shared UI-test launch helper
// Created: 2026-05-21

import XCTest

// MARK: - UITestHelpers

/// Shared launch helper used by all AppUITests classes.
///
/// Centralises standard launch arguments and waits for first-paint so
/// individual tests start from a known, stable state.
enum UITestHelpers {

    // MARK: - Launch

    /// Configures and launches `app` with standard UI-testing arguments.
    ///
    /// - Parameters:
    ///   - app: The `XCUIApplication` to configure.
    static func launchAppForTesting(_ app: XCUIApplication) {
        app.launchArguments.append("--ui-testing")
        app.launch()
    }

    // MARK: - Wait Helpers

    /// Waits up to `timeout` seconds for `element` to appear, then asserts.
    ///
    /// Prefer this over raw `waitForExistence` + `XCTAssertTrue` pairs — it
    /// surfaces a clear failure message without boilerplate at call sites.
    @discardableResult
    static func assertExists(
        _ element: XCUIElement,
        timeout: TimeInterval = 5,
        message: String,
        file: StaticString = #filePath,
        line: UInt = #line
    ) -> Bool {
        let exists = element.waitForExistence(timeout: timeout)
        XCTAssertTrue(exists, message, file: file, line: line)
        return exists
    }

    /// Waits up to `timeout` seconds for `element` to disappear, then asserts.
    static func assertGone(
        _ element: XCUIElement,
        timeout: TimeInterval = 5,
        message: String,
        file: StaticString = #filePath,
        line: UInt = #line
    ) {
        let waiterResult = XCTWaiter.wait(
            for: [XCTNSPredicateExpectation(
                predicate: NSPredicate(format: "exists == false"),
                object: element
            )],
            timeout: timeout
        )
        XCTAssertEqual(waiterResult, .completed, message, file: file, line: line)
    }
}
