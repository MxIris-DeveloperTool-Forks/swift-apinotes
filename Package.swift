// swift-tools-version: 5.7
import PackageDescription

let package = Package(
    name: "swift-apinotes",
    platforms: [
        .macOS(.v10_15),
    ],
    products: [
        .library(name: "APINotes", targets: ["APINotes"]),
    ],
    dependencies: [
        .package(url: "https://github.com/SwiftyLab/MetaCodable", from: "1.5.0"),
    ],
    targets: [
        .target(
            name: "APINotes",
            dependencies: [
                .product(name: "MetaCodable", package: "MetaCodable"),
            ]
        ),
        .testTarget(name: "APINotesTests", dependencies: ["APINotes"]),
    ]
)
