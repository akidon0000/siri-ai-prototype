import AppIntents

// App Intentsなら .intentdefinition も resolve/confirm/handleの分割も不要。
// パラメータは@Parameterで型安全に宣言し、perform()が1つあるだけでよい。
struct CompleteMemoIntent: AppIntent {
    static let title: LocalizedStringResource = "メモを完了にする"

    @Parameter(title: "メモ")
    var memo: MemoEntity

    func perform() async throws -> some IntentResult {
        try await MemoStore.shared.complete(memo.id)
        return .result()
    }
}
