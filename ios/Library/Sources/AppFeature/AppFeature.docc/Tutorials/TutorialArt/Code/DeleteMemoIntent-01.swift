import AppIntents

struct DeleteMemoIntent: AppIntent {
    static let title: LocalizedStringResource = "メモを削除"

    @Parameter(title: "メモ")
    var memo: MemoEntity
}
