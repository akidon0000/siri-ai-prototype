import AppIntents
import CoreSpotlight

// IndexedEntity: このEntityをSpotlightのセマンティック索引に載せてよい、という宣言。
// 「あのメモ」のようなあいまいな言い方でもApple Intelligenceが見つけられるようになる。
extension MemoEntity: IndexedEntity {}

struct MemoSpotlightIndexer {
    private let index = CSSearchableIndex(name: "memos")

    // 追加・更新のたびに呼ぶ
    func reindex(_ memo: MemoEntity) async throws {
        try await index.indexAppEntities([memo])
    }

    // 削除したら索引からも消す
    func deindex(_ id: MemoEntity.ID) async throws {
        try await index.deleteAppEntities(identifiedBy: [id], ofType: MemoEntity.self)
    }
}
