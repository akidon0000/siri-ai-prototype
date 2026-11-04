import AppIntents

// EntityStringQuery にすると、名前（文字列）からも探せる
public struct MemoQuery: EntityStringQuery {
    public init() {}

    public func entities(for identifiers: [MemoEntity.ID]) async throws -> [MemoEntity] {
        try await MemoStore.shared.memos(for: identifiers)
    }

    // 候補の一覧に出すメモ。ここでは最近のメモを返す
    public func suggestedEntities() async throws -> [MemoEntity] {
        try await MemoStore.shared.recentMemos()
    }

    // Siriが聞き取った名前で探す
    public func entities(matching string: String) async throws -> [MemoEntity] {
        try await MemoStore.shared.memos(matching: string)
    }
}
