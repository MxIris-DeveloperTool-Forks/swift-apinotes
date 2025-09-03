// swift-tools-version: 6.1
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
        .package(url: "https://github.com/jpsim/Yams", from: "6.1.0"),
    ],
    targets: [
        .target(
            name: "APINotes",
            dependencies: [
                .product(name: "MetaCodable", package: "MetaCodable"),
                .product(name: "Yams", package: "Yams"),
            ]
        ),
        .testTarget(name: "APINotesTests", dependencies: ["APINotes"]),
    ],
    swiftLanguageModes: [.v5],
)
