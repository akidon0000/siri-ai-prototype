import AppIntents

struct DeleteMemoIntent: AppIntent {
    static let title: LocalizedStringResource = "メモを削除"

    @Parameter(title: "メモ")
    var memo: MemoEntity

    func perform() async throws -> some IntentResult {
        // 消す前に確認する。取り消されると例外が投げられ、次の行は実行されない
        try await requestConfirmation(dialog: "「\(memo.title)」を削除しますか？")
        try await MemoStore.shared.delete(memo.id)
        return .result()
    }
}
