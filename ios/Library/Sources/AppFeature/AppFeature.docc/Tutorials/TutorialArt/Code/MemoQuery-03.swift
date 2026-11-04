import AppIntents

// SiriやショートカットがIDからメモを取り出すときのクエリ
// EntityStringQuery にすると、名前（文字列）からも探せる
struct MemoQuery: EntityStringQuery {
    // 渡されたIDのメモを返す
    func entities(for identifiers: [MemoEntity.ID]) async throws -> [MemoEntity] {
        try await MemoStore.shared.memos(for: identifiers)
    }

    // 候補の一覧に出すメモ。ここでは最近のメモを返す
    func suggestedEntities() async throws -> [MemoEntity] {
        try await MemoStore.shared.recentMemos()
    }

    // Siriが聞き取った名前で探す
    func entities(matching string: String) async throws -> [MemoEntity] {
        try await MemoStore.shared.memos(matching: string)
    }
}
