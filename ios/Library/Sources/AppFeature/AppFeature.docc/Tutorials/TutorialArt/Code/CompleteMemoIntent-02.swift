import AppIntents

struct CompleteMemoIntent: AppIntent {
    // ShortcutsアプリやSpotlightに表示される操作名
    static let title: LocalizedStringResource = "メモを完了にする"

    // 値が無ければ、システムが MemoEntity の候補を出して聞き返す
    @Parameter(title: "メモ")
    var memo: MemoEntity
}
