// swift-tools-version:5.1
// The swift-tools-version declares the minimum version of Swift required to build this package.
import PackageDescription

let package = Package(
    name: "Sauce",
    platforms: [
      .macOS(.v10_10)
    ],
    products: [
        .library(
            name: "Sauce",
            targets: ["Sauce"]),
    ],
    targets: [
        .target(
            name: "Sauce",
            dependencies: [],
            path: "Lib/Sauce"),
        .testTarget(
            name: "SauceTests",
            dependencies: ["Sauce"],
            path: "Lib/SauceTests"),
    ],
    swiftLanguageVersions: [.v5]
)
