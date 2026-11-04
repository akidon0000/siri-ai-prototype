import AppIntents
import CoreSpotlight

// Spotlightのセマンティック索引に、メモを入れたり消したりする
struct MemoSpotlightIndexer {
    private let searchIndex = CSSearchableIndex(name: "memos")

    // 追加・更新したメモを索引に入れる
    func index(_ memos: [MemoEntity]) async throws {
        try await searchIndex.indexAppEntities(memos)
    }
}
