import AppIntents
import CoreSpotlight

/// Spotlightの索引への登録と削除。テストでは記録するだけの実装に差し替える。
nonisolated public protocol MemoIndexing: Sendable {
    func index(_ memos: [MemoEntity]) async throws
    func remove(_ ids: [MemoEntity.ID]) async throws
}

// 索引をやり直したいときは、端末の 設定 > デベロッパ > CoreSpotlight Testing で初期化できる
nonisolated struct MemoSpotlightIndexer: MemoIndexing {
    // 名前付きの索引にすると、このアプリのメモだけをまとめて消したり作り直したりできる
    // CSSearchableIndex は Sendable ではないので、保持せずに使うたびに作る
    private var searchIndex: CSSearchableIndex { CSSearchableIndex(name: "memos") }

    func index(_ memos: [MemoEntity]) async throws {
        try await searchIndex.indexAppEntities(memos)
    }

    func remove(_ ids: [MemoEntity.ID]) async throws {
        try await searchIndex.deleteAppEntities(identifiedBy: ids, ofType: MemoEntity.self)
    }
}
