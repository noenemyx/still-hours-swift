// swift-tools-version: 6.0
import PackageDescription

let package = Package(
    name: "InventoryCore",
    // Ship target: iOS 26 only — Liquid Glass + SwiftUI 26 + SF Symbols 7.
    // No backport. See PRD.md §0.2 + DEVPLAN.md §1.
    //
    // macOS 26 is declared so `swift build` on the developer Mac host can
    // compile-check the package (SortDescriptor, SwiftData, modern actors).
    // The shipped app is iOS-only — there is no macOS target in project.yml
    // and no macOS-specific code paths beyond `#if canImport(UIKit)` guards.
    platforms: [
        .iOS("26.0"),
        .macOS("26.0"),
    ],
    products: [
        .library(
            name: "InventoryCore",
            targets: ["InventoryCore"]
        ),
    ],
    targets: [
        .target(
            name: "InventoryCore",
            path: "Sources/InventoryCore",
            swiftSettings: [
                .swiftLanguageMode(.v6),
                .enableExperimentalFeature("StrictConcurrency"),
            ]
        ),
        .testTarget(
            name: "InventoryCoreTests",
            dependencies: ["InventoryCore"],
            path: "Tests/InventoryCoreTests",
            swiftSettings: [
                .swiftLanguageMode(.v6),
            ]
        ),
    ]
)
