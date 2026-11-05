import AppIntents

@AppIntent(schema: .reminders.createReminder)
struct CreateMemoIntent {
    // The schema's properties. The system fills them in before calling perform()
    var title: String
    var list: MemoListEntity?
    var note: AttributedString?
    var isFlagged: Bool?
    var images: [IntentFile]
    var tags: Set<String>
    var urls: [URL]
}
