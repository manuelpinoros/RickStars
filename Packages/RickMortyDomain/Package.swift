// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "RickMortyDomain",
    platforms: [.iOS(.v16)],
    products: [.library(name: "RickMortyDomain", targets: ["RickMortyDomain"])],
    targets: [
        .target(name: "RickMortyDomain"),
        .testTarget(name: "RickMortyDomainTests", dependencies: ["RickMortyDomain"])
    ]
)
