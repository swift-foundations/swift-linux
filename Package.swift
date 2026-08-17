// swift-tools-version: 6.3.3

import PackageDescription

let package = Package(
    name: "swift-linux",
    platforms: [
        .macOS("27"),
        .iOS("27"),
        .tvOS("27"),
        .watchOS("27"),
        .visionOS("27"),
    ],
    products: [
        // MARK: - Kernel Domain
        .library(name: "Linux Kernel File", targets: ["Linux Kernel File"]),
        .library(name: "Linux Kernel Pipe", targets: ["Linux Kernel Pipe"]),
        .library(name: "Linux Kernel Socket", targets: ["Linux Kernel Socket"]),
        .library(name: "Linux Kernel Memory", targets: ["Linux Kernel Memory"]),
        .library(name: "Linux Kernel Descriptor", targets: ["Linux Kernel Descriptor"]),
        .library(name: "Linux Kernel Futex", targets: ["Linux Kernel Futex"]),
        .library(name: "Linux Kernel System", targets: ["Linux Kernel System"]),
        .library(name: "Linux Kernel Event", targets: ["Linux Kernel Event"]),
        .library(name: "Linux Kernel IO", targets: ["Linux Kernel IO"]),
        .library(name: "Linux Kernel IO Uring", targets: ["Linux Kernel IO Uring"]),
        .library(name: "Linux Kernel Thread", targets: ["Linux Kernel Thread"]),
        .library(name: "Linux Kernel Random", targets: ["Linux Kernel Random"]),
        // MARK: - Umbrella
        .library(name: "Linux Kernel", targets: ["Linux Kernel"]),
        // MARK: - Other
        .library(name: "Linux Loader", targets: ["Linux Loader"]),
        .library(name: "Linux Memory", targets: ["Linux Memory"]),
        .library(name: "Linux System", targets: ["Linux System"]),
        .library(name: "Linux Test Support", targets: ["Linux Test Support"]),
    ],
    dependencies: [
        .package(url: "https://github.com/swift-linux-foundation/swift-linux-standard.git", branch: "main"),
        .package(url: "https://github.com/swift-primitives/swift-system-primitives.git", branch: "main"),
        .package(url: "https://github.com/swift-primitives/swift-random-primitives.git", branch: "main"),
        .package(url: "https://github.com/swift-primitives/swift-error-primitives.git", branch: "main"),
        .package(url: "https://github.com/swift-iso/swift-iso-9945.git", branch: "main"),
        .package(url: "https://github.com/swift-foundations/swift-posix.git", branch: "main"),
    ],
    targets: [

        // MARK: - Kernel Domain (re-export L2 + policy)

        .target(
            name: "Linux Kernel File",
            dependencies: [
                .product(name: "Linux Kernel File Standard", package: "swift-linux-standard"),
                .product(name: "ISO 9945 Kernel File", package: "swift-iso-9945"),
            ]
        ),
        .target(
            name: "Linux Kernel Pipe",
            dependencies: [
                .product(name: "Linux Kernel Pipe Standard", package: "swift-linux-standard"),
            ]
        ),
        .target(
            name: "Linux Kernel Socket",
            dependencies: [
                .product(name: "Linux Kernel Socket Standard", package: "swift-linux-standard"),
            ]
        ),
        .target(
            name: "Linux Kernel Memory",
            dependencies: [
                .product(name: "Linux Kernel Memory Standard", package: "swift-linux-standard"),
            ]
        ),
        .target(
            name: "Linux Kernel Descriptor",
            dependencies: [
                .product(name: "Linux Kernel Descriptor Standard", package: "swift-linux-standard"),
            ]
        ),
        .target(
            name: "Linux Kernel Futex",
            dependencies: [
                .product(name: "Linux Kernel Futex Standard", package: "swift-linux-standard"),
            ]
        ),
        .target(
            name: "Linux Kernel System",
            dependencies: [
                .product(name: "Linux Kernel System Standard", package: "swift-linux-standard"),
            ]
        ),
        .target(
            name: "Linux Kernel Event",
            dependencies: [
                .product(name: "Linux Kernel Event Standard", package: "swift-linux-standard"),
            ]
        ),
        .target(
            name: "Linux Kernel IO",
            dependencies: [
                .product(name: "Linux Kernel IO Standard", package: "swift-linux-standard"),
            ]
        ),
        .target(
            name: "Linux Kernel IO Uring",
            dependencies: [
                .product(name: "Linux Kernel IO Uring Standard", package: "swift-linux-standard"),
                .product(name: "ISO 9945 Kernel Environment", package: "swift-iso-9945"),
                .product(name: "POSIX Kernel", package: "swift-posix"),
            ]
        ),

        // MARK: - L3-only (no L2 counterpart)

        .target(
            name: "Linux Kernel Thread",
            dependencies: [
                .product(name: "Linux Kernel System Standard", package: "swift-linux-standard"),
                .product(name: "ISO 9945 Kernel Thread", package: "swift-iso-9945"),
                .product(name: "System Primitives", package: "swift-system-primitives"),
                .product(name: "Error Primitives", package: "swift-error-primitives"),
            ]
        ),
        .target(
            name: "Linux Kernel Random",
            dependencies: [
                .product(name: "Linux Kernel System Standard", package: "swift-linux-standard"),
                .product(name: "Random Primitives", package: "swift-random-primitives"),
            ]
        ),

        // MARK: - Umbrella

        .target(
            name: "Linux Kernel",
            dependencies: [
                "Linux Kernel File",
                "Linux Kernel Pipe",
                "Linux Kernel Socket",
                "Linux Kernel Memory",
                "Linux Kernel Descriptor",
                "Linux Kernel Futex",
                "Linux Kernel System",
                "Linux Kernel Event",
                "Linux Kernel IO",
                "Linux Kernel IO Uring",
                "Linux Kernel Thread",
                "Linux Kernel Random",
                // Wave 3.5-Final-Atomic (2026-05-02): umbrella POSIX Kernel for Kernel = POSIX.Kernel typealias
                .product(name: "POSIX Kernel", package: "swift-posix"),
                .product(name: "ISO 9945 Kernel", package: "swift-iso-9945"),
                .product(name: "ISO 9945 Core", package: "swift-iso-9945"),
                .product(name: "ISO 9945 Kernel Thread", package: "swift-iso-9945"),
            ]
        ),

        // MARK: - Loader

        .target(
            name: "Linux Loader",
            dependencies: [
                .product(name: "Linux Loader Standard", package: "swift-linux-standard"),
            ]
        ),

        // MARK: - Memory

        .target(
            name: "Linux Memory",
            dependencies: [
                .product(name: "Linux Memory Standard", package: "swift-linux-standard"),
            ]
        ),

        // MARK: - System

        .target(
            name: "Linux System",
            dependencies: [
                .product(name: "Linux Kernel System Standard", package: "swift-linux-standard"),
                .product(name: "System Primitives", package: "swift-system-primitives"),
            ]
        ),

        // MARK: - Test Support

        .target(
            name: "Linux Test Support",
            dependencies: [
                "Linux Kernel",
                "Linux Loader",
                "Linux System",
            ],
            path: "Tests/Support"
        ),

        // MARK: - Tests

        .testTarget(
            name: "Linux Kernel Tests",
            dependencies: [
                "Linux Kernel Thread",
                "Linux Kernel Random",
                "Linux Kernel IO Uring",
                "Linux Test Support",
            ]
        ),
    ],
    swiftLanguageModes: [.v6]
)

for target in package.targets where ![.system, .binary, .plugin, .macro].contains(target.type) {
    let ecosystem: [SwiftSetting] = [
        .strictMemorySafety(),
        .enableUpcomingFeature("ExistentialAny"),
        .enableUpcomingFeature("InternalImportsByDefault"),
        .enableUpcomingFeature("MemberImportVisibility"),
        .enableUpcomingFeature("NonisolatedNonsendingByDefault"),
        .enableExperimentalFeature("LifetimeDependence"),
        .enableExperimentalFeature("Lifetimes"),
        .enableExperimentalFeature("SuppressedAssociatedTypes"),
        .enableUpcomingFeature("InferIsolatedConformances"),
        .enableUpcomingFeature("LifetimeDependence"),
    ]

    let package: [SwiftSetting] = []

    target.swiftSettings = (target.swiftSettings ?? []) + ecosystem + package
}
