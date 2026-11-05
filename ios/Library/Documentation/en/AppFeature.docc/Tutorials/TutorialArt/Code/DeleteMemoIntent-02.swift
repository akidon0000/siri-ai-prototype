import AppIntents

struct DeleteMemoIntent: AppIntent {
    static let title: LocalizedStringResource = "Delete Memo"

    @Parameter(title: "Memo")
    var memo: MemoEntity

    func perform() async throws -> some IntentResult {
        // Confirm before deleting. If cancelled, an error is thrown and the next line doesn't run
        try await requestConfirmation(dialog: "Delete '\(memo.title)'?")
        try await MemoStore.shared.delete(memo.id)
        return .result()
    }
}
