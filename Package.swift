// swift-tools-version: 5.7
import PackageDescription

let package = Package(
  name: "swift-apinotes",
  products: [
    .library(name: "APINotes", targets: ["APINotes"]),
  ],
  targets: [
    .target(name: "APINotes"),
    .testTarget(name: "APINotesTests", dependencies: ["APINotes"]),
  ]
)
