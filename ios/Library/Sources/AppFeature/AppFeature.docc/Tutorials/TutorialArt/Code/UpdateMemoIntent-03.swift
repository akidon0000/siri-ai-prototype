import AppIntents

@AppIntent(schema: .reminders.updateReminder)
struct UpdateMemoIntent {
    var target: MemoEntity
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
