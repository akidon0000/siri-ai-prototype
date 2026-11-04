import AppIntents

@AppIntent(schema: .reminders.createReminder)
struct CreateMemoIntent {
    // スキーマのプロパティ。perform() を呼ぶ前にシステムが値を入れる
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

    // Shortcutsアプリには出さず、Siriからだけ使う。Shortcutsには AddMemoIntent が残る
    static let isAssistantOnly: Bool = true

    func perform() async throws -> some ReturnsValue<MemoEntity> {
        let memo = try await MemoStore.shared.add(
            title: title,
            note: note.map { String($0.characters) },
            tags: tags,
            dueDate: dueDate,
            isFlagged: isFlagged ?? false,
            list: list
        )
        // スキーマは作ったリマインダー（MemoEntity）を返すことを求める
        return .result(value: memo)
    }
}
