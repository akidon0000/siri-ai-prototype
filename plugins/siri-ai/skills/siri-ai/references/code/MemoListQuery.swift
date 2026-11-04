import AppIntents

// リストは数が少ないので、Spotlightの索引に入れずに全件を返す
// EnumerableEntityQuery にすると、Siriはこの全件の中からリストを見つけられる
struct MemoListQuery: EnumerableEntityQuery {
    func allEntities() async throws -> [MemoListEntity] {
        try await MemoStore.shared.allLists()
    }

    // EntityQuery としての、IDからリストを返す処理も要る
    func entities(for identifiers: [MemoListEntity.ID]) async throws -> [MemoListEntity] {
        try await MemoStore.shared.lists(for: identifiers)
    }
}
