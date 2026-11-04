import AppIntents

/// パッケージに置いた intent・Entity をアプリに登録するための型。
/// アプリ側の `AppIntentsPackage` から `includedPackages` で参照する。
public struct AppFeaturePackage: AppIntentsPackage {}
