// swift-tools-version:5.7
import PackageDescription

let package = Package(
    name: "HealthAssistant",
    dependencies: [
        .package(url: "https://github.com/swift-server/async-http-client.git", from: "1.10.0")
    ],
    targets: [
        .executableTarget(
            name: "HealthAssistant",
            dependencies: [
                .product(name: "AsyncHTTPClient", package: "async-http-client")
            ]
        ),
    ]
)
