import AppIntents
import VisualIntelligence

// ビジュアルインテリジェンスの「さらに表示」から呼ばれ、アプリ内の検索結果を開く
@AppIntent(schema: .visualIntelligence.semanticContentSearch)
struct ShowMemoSearchResultsIntent {
    // カメラやスクリーンショットから読み取った内容
    var semanticContent: VisualIntelligence.SceneDescriptor
}
