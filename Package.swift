// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "QuietPin",
    platforms: [.macOS(.v13)],
    products: [.executable(name: "QuietPin", targets: ["QuietPin"])],
    targets: [
        .target(name: "QuietPinCore"),
        .executableTarget(name: "QuietPin", dependencies: ["QuietPinCore"])
    ]
)
