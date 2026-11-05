import AppIntents

struct CompleteMemoIntent: AppIntent {
    static let title: LocalizedStringResource = "Complete Memo"

    // If there's no value, the system asks back with MemoEntity suggestions
    @Parameter(title: "Memo")
    var memo: MemoEntity

    func perform() async throws -> some IntentResult {
        try await MemoStore.shared.complete(memo.id)
        return .result()
    }
}
