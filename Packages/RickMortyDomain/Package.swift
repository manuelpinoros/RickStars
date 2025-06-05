// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "RickMortyDomain",
    platforms: [.iOS(.v17)],
    products: [.library(name: "RickMortyDomain", targets: ["RickMortyDomain"])],
    dependencies: [],
    targets: [
        .target(name: "RickMortyDomain",
                dependencies: []),
        .testTarget(name: "RickMortyDomainTests",
                    dependencies: ["RickMortyDomain"])
    ]
) 