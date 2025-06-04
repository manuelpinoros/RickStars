// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "RickMortyData",
    platforms: [.iOS(.v17)],
    products: [.library(name: "RickMortyData", targets: ["RickMortyData"])],
    dependencies: [
        .package(path: "../NetworkKit")
    ],
    targets: [
        .target(name: "RickMortyData",
                dependencies: ["NetworkKit"]),
        .testTarget(name: "RickMortyDataTests",
                    dependencies: ["RickMortyData"])
    ]
)
