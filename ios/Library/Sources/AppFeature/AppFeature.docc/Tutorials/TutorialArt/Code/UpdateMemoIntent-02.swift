import AppIntents

// 完了・期限・タイトルなどの変更を、この1つのintentで受ける
@AppIntent(schema: .reminders.updateReminder)
struct UpdateMemoIntent {
    // 変更するメモ
    var target: MemoEntity
    // 更新のスキーマなので全てオプショナル。nil は「変更しない」
    var isCompleted: Bool?
    var title: String?
    var note: AttributedString?
    var tags: Set<String>?
    var urls: [URL]?
    var dueDate: DateComponents?
}
