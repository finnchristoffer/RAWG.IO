// swift-tools-version: 6.0
import PackageDescription

let package = Package(
    name: "DangerRAWG",
    platforms: [.macOS(.v14)],
    products: [
        .library(name: "DangerDeps", type: .dynamic, targets: ["DangerDeps"])
    ],
    dependencies: [
        .package(url: "https://github.com/danger/swift.git", from: "3.19.0")
    ],
    targets: [
        .target(
            name: "DangerDeps",
            dependencies: [
                .product(name: "Danger", package: "swift")
            ]
        )
    ]
)
