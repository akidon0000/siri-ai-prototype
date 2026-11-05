import AppIntents

// The Reminders domain's list schema. id and name must match the schema in name and type
@AppEntity(schema: .reminders.list)
struct MemoListEntity {
    let id: UUID
    var name: String
    var type: MemoListType

    var displayRepresentation: DisplayRepresentation {
        DisplayRepresentation(title: "\(name)")
    }
}
