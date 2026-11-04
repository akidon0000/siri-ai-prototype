import AppIntents

struct CompleteMemoIntent: AppIntent {
    static let title: LocalizedStringResource = "メモを完了にする"

    @Parameter(title: "メモ")
    var memo: MemoEntity

    func perform() async throws -> some IntentResult {
        try await MemoStore.shared.complete(memo.id)
        return .result()
    }
}
