import AppIntents

@AppIntent(schema: .reminders.createReminder)
struct CreateMemoIntent {
    var title: String
    var list: MemoListEntity?
}
