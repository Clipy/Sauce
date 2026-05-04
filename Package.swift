// swift-tools-version:5.9
import PackageDescription

let package = Package(
    name: "Sauce",
    platforms: [
      .macOS(.v11)
    ],
    products: [
        .library(
            name: "Sauce",
            targets: ["Sauce"]
        ),
    ],
    targets: [
        .target(
            name: "Sauce",
            dependencies: [],
            path: "Lib/Sauce"
        ),
        .testTarget(
            name: "SauceTests",
            dependencies: ["Sauce"],
            path: "Lib/SauceTests"
        ),
    ],
    swiftLanguageVersions: [.v5]
)
