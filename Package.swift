// swift-tools-version: 6.0
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
        .package(url: "https://github.com/swiftlang/swift-docc-plugin.git", from: "1.1.0"),
        .package(url: "https://github.com/fwcd/swift-utils.git", from: "4.1.3"),
        .package(url: "https://github.com/fwcd/swift-geodesy.git", from: "0.2.8"),
        .package(url: "https://github.com/fwcd/swift-graphics.git", from: "4.0.3"),
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "StaticMap",
            dependencies: [
                .product(name: "CairoGraphics", package: "swift-graphics"),
                .product(name: "Geodesy", package: "swift-geodesy"),
                .product(name: "Utils", package: "swift-utils"),
            ]
        ),
        .testTarget(
            name: "StaticMapTests",
            dependencies: ["StaticMap"]
        ),
    ]
)
