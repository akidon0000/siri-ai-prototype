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
    var dueDate: DateComponents?
    var recurrence: Calendar.RecurrenceRule?
    var locationTrigger: MemoLocationTriggerEntity?
    // section also uses an entity that follows the .reminders.section schema
    var section: MemoSectionEntity?

    // Hidden from the Shortcuts app and used only from Siri. The old AddMemoIntent stays in Shortcuts
    static let isAssistantOnly: Bool = true

    func perform() async throws -> some ReturnsValue<MemoEntity> {
        let memo = try await MemoStore.shared.add(title: title, list: list, dueDate: dueDate)
        // The schema requires returning the created reminder (MemoEntity)
        return .result(value: memo)
    }
}
