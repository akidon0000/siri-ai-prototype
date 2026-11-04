import AppIntents

// Remindersドメインの createReminder スキーマに合わせる
@AppIntent(schema: .reminders.createReminder)
struct CreateMemoIntent {
    // スキーマのプロパティ。perform() を呼ぶ前にシステムが値を入れる
    var title: String
    var list: MemoListEntity?
    // ここからはスキーマが定める残りのプロパティ
    var note: AttributedString?
    var isFlagged: Bool?
    var images: [IntentFile]
    var tags: Set<String>
    var urls: [URL]
}
