import AppIntents

// AppEntity: アプリのデータのうち、Siriなど外部から参照されうる部分。
// id・typeDisplayRepresentation・displayRepresentationの3つが必須。
struct MemoEntity: AppEntity {
    let id: UUID
    var title: String
    var isDone: Bool

    static let typeDisplayRepresentation: TypeDisplayRepresentation = "メモ"

    var displayRepresentation: DisplayRepresentation {
        DisplayRepresentation(
            title: "\(title)",
            subtitle: isDone ? "完了" : "未完了"
        )
    }

    static var defaultQuery = MemoQuery()
}

// EntityQuery: idやキーワードから実際のMemoEntityを取得する窓口。
// SiriやShortcutsはこれを通じてMemoEntityを解決する。
struct MemoQuery: EntityQuery {
    func entities(for identifiers: [MemoEntity.ID]) async throws -> [MemoEntity] {
        try await MemoStore.shared.memos(for: identifiers)
    }

    func suggestedEntities() async throws -> [MemoEntity] {
        try await MemoStore.shared.recentMemos()
    }
}
