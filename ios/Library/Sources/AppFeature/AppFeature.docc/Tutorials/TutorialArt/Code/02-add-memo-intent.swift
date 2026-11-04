import AppIntents

// AppIntent: アプリの1つの操作をカプセル化した型。
// @Parameterが入力、perform()が実行本体。返り値でSiriに渡す値を指定する。
struct AddMemoIntent: AppIntent {
    static let title: LocalizedStringResource = "メモを追加"

    @Parameter(title: "タイトル")
    var title: String

    @Parameter(title: "優先度", default: .normal)
    var priority: MemoPriority

    func perform() async throws -> some IntentResult & ReturnsValue<MemoEntity> {
        let memo = try await MemoStore.shared.add(title: title, priority: priority)
        return .result(value: memo)
    }
}
