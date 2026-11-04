import AppIntents

@AppIntent(schema: .reminders.updateReminder)
struct UpdateMemoIntent {
    var target: MemoEntity
    var isCompleted: Bool?
}
