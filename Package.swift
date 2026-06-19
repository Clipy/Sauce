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
            name: "Sauce"
        ),
        .testTarget(
            name: "SauceTests",
            dependencies: ["Sauce"],
        ),
    ],
    swiftLanguageVersions: [.v5]
)
