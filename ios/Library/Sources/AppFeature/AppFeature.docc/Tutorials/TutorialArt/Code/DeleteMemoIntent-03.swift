import AppIntents

@AppIntent(schema: .reminders.deleteReminders)
struct DeleteMemoIntent: DeleteIntent {
    var entities: [MemoEntity]

    func perform() async throws -> some IntentResult {
        try await requestConfirmation(dialog: "\(entities.count)件のメモを削除しますか？")
        try await MemoStore.shared.delete(entities.map(\.id))
        return .result()
    }
}
