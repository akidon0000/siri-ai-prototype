import AppIntents

@AppEntity(schema: .reminders.list)
struct MemoListEntity {
    let id: UUID
    var name: String
    var type: MemoListType

    var displayRepresentation: DisplayRepresentation {
        DisplayRepresentation(title: "\(name)")
    }

    static let defaultQuery = MemoListQuery()
}
