import AppFeature
import AppIntents

// ビルド時のメタデータ抽出は、ここから辿れるパッケージの intent・Entity まで見に行く
struct AppPackage: AppIntentsPackage {
    static var includedPackages: [any AppIntentsPackage.Type] {
        [AppFeaturePackage.self]
    }
}
