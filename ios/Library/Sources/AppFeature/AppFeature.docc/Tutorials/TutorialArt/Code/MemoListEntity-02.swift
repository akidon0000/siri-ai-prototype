import AppIntents

// Remindersドメインの list スキーマ。id と name は名前も型もスキーマ通りにする
@AppEntity(schema: .reminders.list)
struct MemoListEntity {
    let id: UUID
    var name: String
    var type: MemoListType

    var displayRepresentation: DisplayRepresentation {
        DisplayRepresentation(title: "\(name)")
    }
}
