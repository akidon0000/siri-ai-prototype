import AppIntents

// SiriやショートカットがIDからメモを取り出すときのクエリ
struct MemoQuery: EntityQuery {
    func entities(for identifiers: [MemoEntity.ID]) async throws -> [MemoEntity] {
        try await MemoStore.shared.memos(for: identifiers)
    }
}
