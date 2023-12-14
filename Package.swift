// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Courier",
    platforms: [
        .iOS(.v13),
        .macOS(.v11)
    ],
    products: [
        .library(
            name: "Courier",
            targets: ["Courier"])
    ],
    dependencies: [
    ],
    targets: [
        .target(
            name: "Courier"
        ),
        .testTarget(
            name: "CourierTests",
            dependencies: [
                "Courier"
            ]
        )
    ]
)
