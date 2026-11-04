/// Siri/App Intents から呼び出すドメインロジックのインターフェース。
///
/// 実装は `ClientsLive` に置き、`AppFeature` はこのプロトコルにだけ依存する。
/// チュートリアルの `MemoStore` に当たる。中身は第2章で実装する。
public protocol MemoClient: Sendable {}
