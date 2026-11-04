import AppIntents

@AppEntity(schema: .reminders.reminder)
struct MemoEntity {
    let id: UUID
    var title: String
    var isCompleted: Bool
    var sharedWith: [String]

    var displayRepresentation: DisplayRepresentation {
        DisplayRepresentation(
            title: "\(title)",
            subtitle: isCompleted ? "完了" : "未完了",
            image: .init(systemName: isCompleted ? "checkmark.circle.fill" : "circle")
        )
    }

    static let defaultQuery = MemoQuery()
}
