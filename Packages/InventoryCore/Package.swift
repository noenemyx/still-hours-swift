// swift-tools-version: 6.0
import PackageDescription

let package = Package(
    name: "InventoryCore",
    // iOS 26 only — Liquid Glass + SwiftUI 26 + SF Symbols 7.
    // No backport. See PRD.md §0.2 + DEVPLAN.md §1.
    platforms: [
        .iOS("26.0"),
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
                .swiftLanguageVersion(.v6),
                .enableExperimentalFeature("StrictConcurrency"),
            ]
        ),
        .testTarget(
            name: "InventoryCoreTests",
            dependencies: ["InventoryCore"],
            path: "Tests/InventoryCoreTests",
            swiftSettings: [
                .swiftLanguageVersion(.v6),
            ]
        ),
    ]
)
