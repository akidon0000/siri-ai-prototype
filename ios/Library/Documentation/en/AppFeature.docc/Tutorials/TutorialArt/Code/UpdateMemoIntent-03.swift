import AppIntents

// This one intent handles changes to completion, due date, title and so on
@AppIntent(schema: .reminders.updateReminder)
struct UpdateMemoIntent {
    var target: MemoEntity
    // It's an update schema, so everything is optional. nil means "don't change"
    var isCompleted: Bool?
    var title: String?
    var note: AttributedString?
    var tags: Set<String>?
    var urls: [URL]?
    var dueDate: DateComponents?
    var recurrence: Calendar.RecurrenceRule?
    var isFlagged: Bool?
    var list: MemoListEntity?
    var locationTrigger: MemoLocationTriggerEntity?
}
