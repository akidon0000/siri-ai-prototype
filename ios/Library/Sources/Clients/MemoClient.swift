/// Siri/App Intents から呼び出すドメインロジックのインターフェース。
///
/// 実装は `ClientsLive` に置き、`AppFeature` はこのプロトコルにだけ依存する。
/// App Intent / App Entity の実装は DocC チュートリアル (`AppFeature.docc`) を読んだ後、
/// チュートリアル末尾のプロンプトでこの型を実装してもらう。
///
/// TODO: Tutorial 2 (App Intentsの基礎) 完了後、Memoの定義とCRUDメソッドを実装する。
public protocol MemoClient: Sendable {}
