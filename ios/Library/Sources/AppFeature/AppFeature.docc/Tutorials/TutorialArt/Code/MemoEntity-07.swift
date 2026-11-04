import AppIntents

@AppEntity(schema: .reminders.reminder)
struct MemoEntity {
    let id: UUID
    var title: String
    var isDone: Bool
    var sharedWith: [String]

    var displayRepresentation: DisplayRepresentation {
        DisplayRepresentation(
            title: "\(title)",
            subtitle: isDone ? "完了" : "未完了",
            image: .init(systemName: isDone ? "checkmark.circle.fill" : "circle")
        )
    }

    static let defaultQuery = MemoQuery()
}
