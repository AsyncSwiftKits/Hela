// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription
import Foundation

let package = Package(
    name: "Hela",
    platforms: [
        .iOS(.v13),
        .macOS(.v12),
        .tvOS(.v13),
        .watchOS(.v7)
    ],
    products: [
        .library(
            name: "Hela",
            targets: ["Hela"]),
    ],
    dependencies: [
        .package(url: "https://github.com/mattgallagher/CwlPreconditionTesting.git", .upToNextMajor(from: "2.1.0"))
    ],
    targets: [
        .target(
            name: "Hela",
            dependencies: [
                .product(name: "CwlPreconditionTesting", package: "CwlPreconditionTesting")
            ]
        ),
        .testTarget(
            name: "HelaTests",
            dependencies: ["Hela"]
        ),
    ]
)
