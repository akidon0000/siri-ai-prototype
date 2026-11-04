import AppIntents

// 複数のメモを消す deleteReminders スキーマ。準拠先は DeleteIntent
@AppIntent(schema: .reminders.deleteReminders)
struct DeleteMemoIntent: DeleteIntent {
    // スキーマが定める、削除するメモの配列
    var entities: [MemoEntity]

    func perform() async throws -> some IntentResult {
        // 消す前に確認する。取り消されると例外が投げられ、次の行は実行されない
        try await requestConfirmation(dialog: "\(entities.count)件のメモを削除しますか？")
        try await MemoStore.shared.delete(entities.map(\.id))
        return .result()
    }
}
