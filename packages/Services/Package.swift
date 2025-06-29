// swift-tools-version: 6.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Services",
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "ApiService",
            targets: ["ApiService"]
        ),
        .library(
            name: "ApiServicing",
            targets: ["ApiServicing"]
        ),
        .library(
            name: "ApiDecoder",
            targets: ["ApiDecoder"]
        ),
    ],
    targets: [
        .target(
            name: "ApiServicing"
        ),
        .target(
            name: "ApiService",
            dependencies: ["ApiServicing"]
        ),
        .testTarget(
            name: "ApiServiceTests",
            dependencies: ["ApiService", "ApiServicing"]
        ),
        .target(
            name: "ApiDecoder",
            dependencies: ["ApiServicing"]
        ),
        .testTarget(
            name: "ApiDecoderTests",
            dependencies: ["ApiDecoder", "ApiServicing"]
        ),
    ]
)
