// swift-tools-version:5.5
import PackageDescription

let package = Package(
    name: "LibreSensor",
    platforms: [
        .iOS(.v13),
        .macOS(.v10_15)
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
            swiftSettings: [
                .define("CORE_NFC", .when(platforms: [.iOS]))
            ]),
        .testTarget(
            name: "LibreSensorTests",
            dependencies: ["LibreSensor"],
            swiftSettings: [
                .define("CORE_NFC", .when(platforms: [.iOS]))
            ]),
    ]
)
