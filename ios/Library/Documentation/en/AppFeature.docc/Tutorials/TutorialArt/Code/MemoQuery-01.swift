import AppIntents

// The query Siri and shortcuts use to get memos from their IDs
struct MemoQuery: EntityQuery {
    func entities(for identifiers: [MemoEntity.ID]) async throws -> [MemoEntity] {
        try await MemoStore.shared.memos(for: identifiers)
    }
}
