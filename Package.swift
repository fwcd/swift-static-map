// swift-tools-version: 5.10
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "swift-static-map",
    platforms: [.macOS(.v13)],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "StaticMap",
            targets: ["StaticMap"]
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/fwcd/swift-utils.git", from: "3.0.18"),
        .package(url: "https://github.com/fwcd/swift-graphics.git", from: "3.0.2"),
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "StaticMap",
            dependencies: [
                .product(name: "Graphics", package: "swift-graphics"),
                .product(name: "Utils", package: "swift-utils"),
            ]
        ),
        .testTarget(
            name: "StaticMapTests",
            dependencies: ["StaticMap"]
        ),
    ]
)
