import AppIntents

struct MemoQuery: EntityQuery {
    func entities(for identifiers: [MemoEntity.ID]) async throws -> [MemoEntity] {
        try await MemoStore.shared.memos(for: identifiers)
    }
}
