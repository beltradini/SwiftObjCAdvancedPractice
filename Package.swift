// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "SwiftObjCAdvancedPractice",
    platforms: [
        .macOS(.v13),
        .iOS(.v16)
    ],
    products: [
        .library(
            name: "SwiftObjCAdvancedPractice",
            targets: ["SwiftObjCAdvancedPractice"]
        ),
        .executable(
            name: "SwiftObjCAdvancedPracticeCLI",
            targets: ["SwiftObjCAdvancedPracticeCLI"]
        ),
        .executable(
            name: "SwiftObjCAdvancedPracticeServer",
            targets: ["SwiftObjCAdvancedPracticeServer"]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/vapor/vapor.git", from: "4.89.0")
    ],
    targets: [
        .target(
            name: "RuntimeHelperObjC",
            dependencies: [],
            path: "Sources/RuntimeHelperObjC",
            publicHeadersPath: "include"
        ),
        .target(
            name: "SwiftObjCAdvancedPractice",
            dependencies: ["RuntimeHelperObjC"],
            path: "Sources/SwiftObjCAdvancedPractice"
        ),
        .executableTarget(
            name: "SwiftObjCAdvancedPracticeCLI",
            dependencies: ["SwiftObjCAdvancedPractice"],
            path: "Sources/SwiftObjCAdvancedPracticeCLI"
        ),
        .executableTarget(
            name: "SwiftObjCAdvancedPracticeServer",
            dependencies: [
                "SwiftObjCAdvancedPractice",
                .product(name: "Vapor", package: "vapor")
            ],
            path: "Sources/SwiftObjCAdvancedPracticeServer"
        ),
        .testTarget(
            name: "SwiftObjCAdvancedPracticeTests",
            dependencies: ["SwiftObjCAdvancedPractice"],
            path: "Tests/SwiftObjCAdvancedPracticeTests"
        ),
    ]
)
