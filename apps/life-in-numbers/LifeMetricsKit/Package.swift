// swift-tools-version:5.9
import PackageDescription

let package = Package(
    name: "LifeMetricsKit",
    platforms: [
        .iOS(.v17),
        .macOS(.v14)
    ],
    products: [
        .library(name: "LifeMetricsKit", targets: ["LifeMetricsKit"])
    ],
    targets: [
        .target(name: "LifeMetricsKit"),
        .testTarget(name: "LifeMetricsKitTests", dependencies: ["LifeMetricsKit"])
    ]
)
