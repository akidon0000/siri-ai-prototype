import AppIntents

struct DeleteMemoIntent: AppIntent {
    static let title: LocalizedStringResource = "メモを削除"

    @Parameter(title: "メモ")
    var memo: MemoEntity

    func perform() async throws -> some IntentResult {
        try await requestConfirmation(dialog: "「\(memo.title)」を削除しますか？")
        try await MemoStore.shared.delete(memo.id)
        return .result()
    }
}
