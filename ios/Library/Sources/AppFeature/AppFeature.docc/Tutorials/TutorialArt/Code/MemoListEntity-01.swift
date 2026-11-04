import AppIntents

@AppEntity(schema: .reminders.list)
struct MemoListEntity {
    let id: UUID
    var name: String
}
