import AppIntents

// .system.open: 検索結果のメモをタップしたときなどに、アプリでそのメモを開く
@AppIntent(schema: .system.open)
struct OpenMemoIntent: OpenIntent {
    // 開くメモ
    var target: MemoEntity

    func perform() async throws -> some IntentResult {
        // アプリの画面をそのメモに切り替える
        await MemoNavigator.shared.show(target.id)
        return .result()
    }
}
