import AppIntents

// The deleteReminders schema, which deletes several memos. It conforms to DeleteIntent
@AppIntent(schema: .reminders.deleteReminders)
struct DeleteMemoIntent: DeleteIntent {
    var entities: [MemoEntity]

    func perform() async throws -> some IntentResult {
        // Confirm before deleting. If cancelled, an error is thrown and the next line doesn't run
        try await requestConfirmation(dialog: "Delete \(entities.count) memos?")
        try await MemoStore.shared.delete(entities.map(\.id))
        return .result()
    }
}
