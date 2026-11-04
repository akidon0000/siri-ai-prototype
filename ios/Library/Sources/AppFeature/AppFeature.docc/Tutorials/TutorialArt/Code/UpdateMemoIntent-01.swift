import AppIntents

// 完了・期限・タイトルなどの変更を、この1つのintentで受ける
@AppIntent(schema: .reminders.updateReminder)
struct UpdateMemoIntent {
    var target: MemoEntity
    // 更新のスキーマなので全てオプショナル。nil は「変更しない」
    var isCompleted: Bool?
}
