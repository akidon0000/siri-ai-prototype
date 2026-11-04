import AppIntents

// @AppIntent(.tool): 既存のAppIntentに付けるだけで、
// Siriが自律的に呼び出せる「ツール」になる。新しいentitlementは不要。
@AppIntent(.tool)
struct CompleteMemoIntent: AppIntent {
    static let title: LocalizedStringResource = "メモを完了にする"
    static let description = IntentDescription(
        LocalizedStringResource("指定したメモを完了済みにする。")
    )

    @Parameter(title: "メモ", description: LocalizedStringResource("完了にするメモ"))
    var memo: MemoEntity

    func perform() async throws -> some IntentResult {
        try await MemoStore.shared.complete(memo.id)
        return .result()
    }
}
