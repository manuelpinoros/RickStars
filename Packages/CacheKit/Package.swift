// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "CacheKit",
    platforms: [.iOS(.v17)],
    products: [.library(name: "CacheKit", targets: ["CacheKit"])],
    targets: [
        .target(name: "CacheKit"),
        .testTarget(name: "CacheKitTests", dependencies: ["CacheKit"])
    ]
)
