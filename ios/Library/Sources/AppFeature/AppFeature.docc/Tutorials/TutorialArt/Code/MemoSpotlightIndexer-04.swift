import AppIntents
import CoreSpotlight

// Spotlightのセマンティック索引に、メモを入れたり消したりする
// 索引をやり直したいときは、端末の 設定 > デベロッパ > CoreSpotlight Testing で初期化できる
struct MemoSpotlightIndexer {
    private let searchIndex = CSSearchableIndex(name: "memos")

    // 追加・更新したメモを索引に入れる
    func index(_ memos: [MemoEntity]) async throws {
        try await searchIndex.indexAppEntities(memos)
    }

    // 削除したメモを索引から消す
    func remove(_ ids: [MemoEntity.ID]) async throws {
        try await searchIndex.deleteAppEntities(identifiedBy: ids, ofType: MemoEntity.self)
    }
}
