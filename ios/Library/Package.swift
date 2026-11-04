// swift-tools-version: 6.2

import PackageDescription

let mainActorByDefault: [SwiftSetting] = [
    .defaultIsolation(MainActor.self)
]

let package = Package(
    name: "Library",
    defaultLocalization: "ja",
    platforms: [
        .iOS(.v18)
    ],
    products: [
        // 製品は 1 つにする。2 つ以上にすると、パッケージのスキーム名が Library-Package に変わる。
        // ClientsLive を使うのはアプリのターゲットだけ（AppFeature は ClientsLive に依存しない）
        .library(name: "AppFeature", targets: ["AppFeature", "ClientsLive"])
    ],
    targets: [
        .target(
            name: "Clients"
        ),
        .target(
            name: "ClientsLive",
            dependencies: ["Clients"]
        ),
        .target(
            name: "Components",
            swiftSettings: mainActorByDefault
        ),
        .target(
            name: "AppFeature",
            dependencies: ["Clients", "Components"],
            swiftSettings: mainActorByDefault
        ),
        .target(
            name: "TestSupport",
            dependencies: ["Clients"]
        ),
        .testTarget(
            name: "TestSupportTests",
            dependencies: ["Clients", "TestSupport"]
        ),
        .testTarget(
            name: "ClientsLiveTests",
            dependencies: ["Clients", "ClientsLive"]
        ),
        .testTarget(
            name: "AppFeatureTests",
            dependencies: ["AppFeature", "Clients", "TestSupport"],
            swiftSettings: mainActorByDefault
        )
    ]
)
