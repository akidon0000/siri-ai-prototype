// swift-tools-version: 6.2

import PackageDescription

// iOS 27.3 beta の SDK でビルドするときだけ true にする。
// CardSnippet・@AppIntent(.tool)・Siri Evaluations など、27.1 の SDK に無いAPIを #if SIRI_AI_PREVIEW で囲んでいる
let siriAIPreview = true

let siriAIPreviewSettings: [SwiftSetting] = siriAIPreview ? [.define("SIRI_AI_PREVIEW")] : []

let mainActorByDefault: [SwiftSetting] = [
    .defaultIsolation(MainActor.self)
] + siriAIPreviewSettings

let package = Package(
    name: "Library",
    defaultLocalization: "ja",
    platforms: [
        // チュートリアルで使う App Intents の API（スニペット、OwnershipProvidingEntity、IndexedEntityQuery など）が iOS 26〜27 以降なので、27.0 からにする
        // siriAIPreview を true にしたときは、27.3 beta にしか無いAPIを呼べるように 27.3 からにする
        .iOS(siriAIPreview ? "27.3" : "27.0")
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
