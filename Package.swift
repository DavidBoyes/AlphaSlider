// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "AlphaSlider",
    platforms: [
        .iOS(.v13)
    ],
    products: [
        .library(
            name: "AlphaSlider",
            targets: ["AlphaSlider"]),
    ],
    dependencies: [
    ],
    targets: [
        .target(
            name: "AlphaSlider",
            dependencies: [],
            exclude: ["Images"]),
    ]
)
