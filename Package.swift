// swift-tools-version:4.0
//
// FlatAnimation - Animation.swift.
//
// Copyright (c) 2017 The FlatAnimation authors.
// Licensed under MIT License.

import PackageDescription

let package = Package(
    name: "FlatAnimation",
    products: [
        .library(
            name: "FlatAnimation",
            targets: ["FlatAnimation"]
        )
    ],
    dependencies: [
        .package(
            url: "https://github.com/dche/GLMath.git",
            .branch("master")
        )
    ],
    targets: [
        .target(
            name: "FlatAnimation",
            dependencies: ["GLMath"],
            path: "Sources"
        ),
        .testTarget(
            name: "FlatAnimationTests",
            dependencies: ["FlatAnimation"],
            path: "Tests/FlatAnimationTests"
        )
    ]
)
