import AppIntents

@AppIntent(schema: .reminders.createReminder)
struct CreateMemoIntent {
    var title: String
    var list: MemoListEntity?
    var note: AttributedString?
    var isFlagged: Bool?
    var images: [IntentFile]
    var tags: Set<String>
    var urls: [URL]
}
