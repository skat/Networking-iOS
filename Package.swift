// swift-tools-version: 5.6
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SharedHelper-iOS",
    platforms: [
        .iOS(.v15)
    ],
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "Networking",
            targets: ["Networking"]),
        .library(
            name: "Authentication",
            targets: ["Authentication"]),
        .library(
            name: "Tracking",
            targets: ["Tracking"]),
        .library(
            name: "VersionCheck",
            targets: ["VersionCheck"]),
        .library(
            name: "Maintenance",
            targets: ["Maintenance"]),
        .library(
            name: "Helpers",
            targets: ["Helpers"])
    ],
    dependencies: [
        .package(
            url: "https://github.com/mixpanel/mixpanel-swift",
            from: "4.0.3"
        ),
        .package(
            url: "https://github.com/firebase/firebase-ios-sdk",
            from: "9.3.0"
        ),
        .package(url: "https://github.com/realm/SwiftLint.git",
                 branch: "main")
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(
            name: "Networking",
            dependencies: [],
            plugins: [.plugin(name: "SwiftLintPlugin", package: "SwiftLint")]),
        .testTarget(
            name: "NetworkingTests",
            dependencies: ["Networking"],
            plugins: [.plugin(name: "SwiftLintPlugin", package: "SwiftLint")]),
        .target(
            name: "Authentication",
            dependencies: [],
            plugins: [.plugin(name: "SwiftLintPlugin", package: "SwiftLint")]),
        .target(
            name: "Tracking",
            dependencies: [
                .product(name: "Mixpanel", package: "mixpanel-swift"),
            ],
            plugins: [.plugin(name: "SwiftLintPlugin", package: "SwiftLint")]),
        .target(
            name: "Maintenance",
            dependencies: [
                .product(name: "FirebaseRemoteConfig", package: "firebase-ios-sdk"),
                "Helpers"
            ],
            plugins: [.plugin(name: "SwiftLintPlugin", package: "SwiftLint")]),
        .testTarget(
            name: "MaintenanceTests",
            dependencies: ["Maintenance"],
            plugins: [.plugin(name: "SwiftLintPlugin", package: "SwiftLint")]),
        .target(
            name: "Helpers",
            dependencies: [
                .product(name: "FirebaseRemoteConfig", package: "firebase-ios-sdk"),
            ],
            plugins: [.plugin(name: "SwiftLintPlugin", package: "SwiftLint")]),
        .testTarget(
            name: "HelpersTests",
            dependencies: ["Helpers"],
            plugins: [.plugin(name: "SwiftLintPlugin", package: "SwiftLint")]),
        .target(
            name: "VersionCheck",
            dependencies: [
                .product(name: "FirebaseRemoteConfig", package: "firebase-ios-sdk"),
                "Helpers"
            ],
            plugins: [.plugin(name: "SwiftLintPlugin", package: "SwiftLint")]),
        .testTarget(
            name: "VersionCheckTests",
            dependencies: ["VersionCheck"],
            plugins: [.plugin(name: "SwiftLintPlugin", package: "SwiftLint")]),
    ]
)
