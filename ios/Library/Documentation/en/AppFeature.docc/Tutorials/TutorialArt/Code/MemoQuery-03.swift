import AppIntents

// The query Siri and shortcuts use to get memos from their IDs
// With EntityStringQuery, memos can also be found by name (a string)
struct MemoQuery: EntityStringQuery {
    func entities(for identifiers: [MemoEntity.ID]) async throws -> [MemoEntity] {
        try await MemoStore.shared.memos(for: identifiers)
    }

    // Memos to list as suggestions. Here it returns recent memos
    func suggestedEntities() async throws -> [MemoEntity] {
        try await MemoStore.shared.recentMemos()
    }

    // Search by the name Siri heard
    func entities(matching string: String) async throws -> [MemoEntity] {
        try await MemoStore.shared.memos(matching: string)
    }
}
