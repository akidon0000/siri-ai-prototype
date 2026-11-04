import AppIntents
import VisualIntelligence

// ビジュアルインテリジェンスの検索を受けるクエリ。アプリに1つだけ置ける
struct MemoVisualSearchQuery: IntentValueQuery {
    func values(for input: SemanticContentDescriptor) async throws -> [MemoEntity] {
        // labels には「milk」のような英語のラベルが入る。翻訳も類義語の展開もされない
        try await MemoStore.shared.memos(matchingAnyOf: input.labels)
    }
}
