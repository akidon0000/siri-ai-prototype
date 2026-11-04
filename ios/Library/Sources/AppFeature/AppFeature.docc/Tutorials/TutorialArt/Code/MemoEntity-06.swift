import AppIntents

struct MemoEntity: AppEntity {
    let id: UUID
    var title: String
    var isDone: Bool
    var sharedWith: [String]

    static let typeDisplayRepresentation: TypeDisplayRepresentation = "メモ"

    var displayRepresentation: DisplayRepresentation {
        DisplayRepresentation(
            title: "\(title)",
            subtitle: isDone ? "完了" : "未完了",
            image: .init(systemName: isDone ? "checkmark.circle.fill" : "circle")
        )
    }

    static let defaultQuery = MemoQuery()
}
