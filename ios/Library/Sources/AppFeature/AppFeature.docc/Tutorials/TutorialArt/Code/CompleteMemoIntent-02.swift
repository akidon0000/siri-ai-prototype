import AppIntents

struct CompleteMemoIntent: AppIntent {
    static let title: LocalizedStringResource = "メモを完了にする"

    @Parameter(title: "メモ")
    var memo: MemoEntity
}
