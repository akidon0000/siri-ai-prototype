// VisualIntelligence はシミュレータのSDKに無いので、実機向けのビルドでだけ入れる
#if canImport(VisualIntelligence)
import AppIntents
import VisualIntelligence

// ビジュアルインテリジェンスの検索を受けるクエリ。アプリに1つだけ置ける
struct MemoVisualSearchQuery: IntentValueQuery {
    func values(for input: SemanticContentDescriptor) async throws -> [MemoEntity] {
        // labels には「milk」のような英語のラベルが入る。翻訳も類義語の展開もされない
        try await MemoStore.shared.memos(matchingAnyOf: input.labels)
    }
}

// ビジュアルインテリジェンスの「さらに表示」から呼ばれ、アプリ内の検索結果を開く
@AppIntent(schema: .visualIntelligence.semanticContentSearch)
struct ShowMemoSearchResultsIntent {
    var semanticContent: SemanticContentDescriptor

    func perform() async throws -> some IntentResult {
        // MemoVisualSearchQuery と同じ条件で探した一覧を、アプリの画面に出す
        await MemoNavigator.shared.showSearchResults(for: semanticContent.labels.joined(separator: " "))
        return .result()
    }
}
#endif
