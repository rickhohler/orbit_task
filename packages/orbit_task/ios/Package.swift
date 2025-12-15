// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "orbit_task",
    platforms: [
        .iOS("13.0")
    ],
    products: [
        .library(name: "orbit-task", targets: ["orbit_task"])
    ],
    dependencies: [],
    targets: [
        .target(
            name: "orbit_task",
            dependencies: [],
            resources: [
                .process("Resources"),
            ]
        )
    ]
)
