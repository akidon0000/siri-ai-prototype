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
    // section も .reminders.section スキーマに合わせたEntityを使う
    var section: MemoSectionEntity?

    // Shortcutsアプリには出さず、Siriからだけ使う。Shortcutsには旧 AddMemoIntent が残る
    static let isAssistantOnly: Bool = true

    func perform() async throws -> some ReturnsValue<MemoEntity> {
        let memo = try await MemoStore.shared.add(title: title, list: list, dueDate: dueDate)
        // スキーマは作ったリマインダー（MemoEntity）を返すことを求める
        return .result(value: memo)
    }
}
