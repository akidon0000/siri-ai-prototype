import AppIntents
import Clients

// 完了・期限・タイトルなどの変更を、この1つのintentで受ける
@AppIntent(schema: .reminders.updateReminder)
struct UpdateMemoIntent {
    var target: MemoEntity
    // 更新のスキーマなので全てオプショナル。nil は「変更しない」
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

    func perform() async throws -> some ReturnsValue<MemoEntity> {
        let change = MemoChange(
            title: title,
            isCompleted: isCompleted,
            note: note.map { String($0.characters) },
            tags: tags,
            dueDate: dueDate,
            isFlagged: isFlagged,
            listID: list?.id
        )
        let memo = try await MemoStore.shared.update(target.id, change)
        return .result(value: memo)
    }
}
