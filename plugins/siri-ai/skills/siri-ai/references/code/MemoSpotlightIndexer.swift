import AppIntents
import CoreSpotlight

// 索引をやり直したいときは、端末の 設定 > デベロッパ > CoreSpotlight Testing で初期化できる
struct MemoSpotlightIndexer {
    private let searchIndex = CSSearchableIndex(name: "memos")

    func index(_ memos: [MemoEntity]) async throws {
        try await searchIndex.indexAppEntities(memos)
    }

    func remove(_ ids: [MemoEntity.ID]) async throws {
        try await searchIndex.deleteAppEntities(identifiedBy: ids, ofType: MemoEntity.self)
    }
}
