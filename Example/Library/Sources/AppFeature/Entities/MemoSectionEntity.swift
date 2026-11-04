import AppIntents

// createReminder スキーマの section に入る型。Memoはセクションを持たないので、見つかるものは無い
// スキーマの必須プロパティは name と list
@AppEntity(schema: .reminders.section)
struct MemoSectionEntity {
    let id: UUID
    var name: String
    var list: MemoListEntity

    var displayRepresentation: DisplayRepresentation {
        DisplayRepresentation(title: "\(name)")
    }

    static let defaultQuery = MemoSectionQuery()
}

// スキーマのintentに渡すEntityは、名前で探せるクエリ（EntityStringQuery）が要る
struct MemoSectionQuery: EntityStringQuery {
    func entities(for identifiers: [MemoSectionEntity.ID]) async throws -> [MemoSectionEntity] {
        []
    }

    func entities(matching string: String) async throws -> [MemoSectionEntity] {
        []
    }
}
