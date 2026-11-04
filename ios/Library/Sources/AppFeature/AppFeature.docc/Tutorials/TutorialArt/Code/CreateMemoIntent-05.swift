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
    var dueDate: DateComponents?
    var recurrence: Calendar.RecurrenceRule?
    var locationTrigger: MemoLocationTriggerEntity?
    var section: MemoSectionEntity?

    static let isAssistantOnly: Bool = true

    func perform() async throws -> some ReturnsValue<MemoEntity> {
        let memo = try await MemoStore.shared.add(title: title, list: list, dueDate: dueDate)
        return .result(value: memo)
    }
}
