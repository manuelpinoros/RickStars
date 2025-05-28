// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "RickMortyData",
    platforms: [.iOS(.v17)],
    products: [.library(name: "RickMortyData", targets: ["RickMortyData"])],
    dependencies: [
        .package(path: "../NetworkKit"),
        .package(path: "../RickMortyDomain")
    ],
    targets: [
        .target(name: "RickMortyData",
                dependencies: ["NetworkKit", "RickMortyDomain"]),
        .testTarget(name: "RickMortyDataTests",
                    dependencies: ["RickMortyData"])
    ]
)
