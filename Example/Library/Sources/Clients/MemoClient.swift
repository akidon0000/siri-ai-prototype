/// Siri/App Intents から呼び出すドメインロジックのインターフェース。
///
/// 実装は `ClientsLive` に置き、`AppFeature` はこのプロトコルにだけ依存する。
/// チュートリアルの `MemoStore` に当たる。
///
/// Siri 連携は App Intents だけで実装する。SiriKit（Intents / IntentsUI / `.intentdefinition`）は使わない。
/// このアプリは SiriKit を一度も使っていないので、`CustomIntentMigratedAppIntent` による移行も要らない。
///
/// TODO: 第2章で実装する
/// - `Memo`（id, title, isDone, priority）を `Clients` に定義する
/// - `add(title:priority:)` / `memos(for:)` / `recentMemos()` / `memos(matching:)` / `complete(_:)` を定義する
/// - `LiveMemoClient` をメモリ内配列で実装する
/// - `TestMemoClient` を固定データを返すスタブにする
public protocol MemoClient: Sendable {}
