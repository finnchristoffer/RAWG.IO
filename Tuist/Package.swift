// swift-tools-version: 6.0
import PackageDescription

#if TUIST
import ProjectDescription

let packageSettings = PackageSettings(
    productTypes: [
        "Factory": .framework,
        "SnapshotTesting": .framework
    ]
)
#endif

let package = Package(
    name: "RAWGDependencies",
    dependencies: [
        .package(url: "https://github.com/hmlongco/Factory", from: "2.3.0"),
        .package(url: "https://github.com/pointfreeco/swift-snapshot-testing", from: "1.15.0")
    ]
)
