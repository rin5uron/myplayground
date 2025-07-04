// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "STTInput",
    platforms: [
        .macOS(.v13)
    ],
    products: [
        .executable(name: "STTInput", targets: ["STTInput"])
    ],
    dependencies: [
        .package(url: "https://github.com/exPHAT/SwiftWhisper.git", branch: "master")
    ],
    targets: [
        .executableTarget(
            name: "STTInput",
            dependencies: [
                "InputMonitorKit",
                "OverlayUI",
                "AudioCaptureKit",
                "WhisperClient",
                "TextInjector",
                .product(name: "SwiftWhisper", package: "SwiftWhisper")
            ],
            exclude: ["Info.plist"]
        ),
        .target(
            name: "InputMonitorKit",
            dependencies: []
        ),
        .target(
            name: "OverlayUI",
            dependencies: []
        ),
        .target(
            name: "AudioCaptureKit",
            dependencies: []
        ),
        .target(
            name: "WhisperClient",
            dependencies: []
        ),
        .target(
            name: "TextInjector",
            dependencies: []
        ),
        
        // MARK: - Test Targets
        .testTarget(
            name: "STTInputTests",
            dependencies: [
                "STTInput",
                "InputMonitorKit",
                "OverlayUI",
                "AudioCaptureKit",
                "WhisperClient",
                "TextInjector"
            ]
        ),
        .testTarget(
            name: "InputMonitorKitTests",
            dependencies: ["InputMonitorKit"]
        ),
        .testTarget(
            name: "AudioCaptureKitTests",
            dependencies: ["AudioCaptureKit"]
        ),
        .testTarget(
            name: "WhisperClientTests",
            dependencies: ["WhisperClient"]
        )
    ]
)
