import AppIntents
import VisualIntelligence

// ビジュアルインテリジェンスの「さらに表示」から呼ばれ、アプリ内の検索結果を開く
@AppIntent(schema: .visualIntelligence.semanticContentSearch)
struct ShowMemoSearchResultsIntent {
    // カメラやスクリーンショットから読み取った内容
    var semanticContent: VisualIntelligence.SceneDescriptor

    func perform() async throws -> some IntentResult {
        // MemoVisualSearchQuery と同じ条件で探した一覧を、アプリの画面に出す
        await MemoNavigator.shared.showVisualSearchResults(for: semanticContent)
        return .result()
    }
}
