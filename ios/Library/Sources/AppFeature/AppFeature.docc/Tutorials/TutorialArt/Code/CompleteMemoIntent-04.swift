import AppIntents

// ビルド時に、この型からSiri・Shortcuts・Spotlight用のメタデータが生成される
// インストールした時点でShortcutsアプリに「メモを完了にする」が並ぶ
struct CompleteMemoIntent: AppIntent {
    // ShortcutsアプリやSpotlightに表示される操作名
    static let title: LocalizedStringResource = "メモを完了にする"

    // 値が無ければ、システムが MemoEntity の候補を出して聞き返す
    @Parameter(title: "メモ")
    var memo: MemoEntity

    func perform() async throws -> some IntentResult {
        try await MemoStore.shared.complete(memo.id)
        return .result()
    }
}
