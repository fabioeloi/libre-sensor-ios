// swift-tools-version:5.7
import PackageDescription

let package = Package(
    name: "LibreSensor",
    platforms: [
        .iOS(.v14),
        .macOS(.v11)
    ],
    products: [
        .library(
            name: "LibreSensor",
            targets: ["LibreSensor"]),
    ],
    dependencies: [],
    targets: [
        .target(
            name: "LibreSensor",
            dependencies: [],
            path: "LibreSensor/Sources"),
        .testTarget(
            name: "LibreSensorTests",
            dependencies: ["LibreSensor"],
            path: "LibreSensor/Tests"),
    ]
)
