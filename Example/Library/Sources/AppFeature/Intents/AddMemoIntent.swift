import AppIntents

struct AddMemoIntent: AppIntent {
    static let title: LocalizedStringResource = "メモを追加"
    // Shortcutsアプリでの説明。Siriもこれを読んでintentの役割を知る
    static let description = IntentDescription("新しいメモを1件追加する。")

    @Parameter(title: "タイトル")
    var title: String

    @Parameter(title: "優先度", default: .normal)
    var priority: MemoPriority

    static var parameterSummary: some ParameterSummary {
        Summary("\(\.$title)を優先度\(\.$priority)で追加")
    }

    func perform() async throws -> some IntentResult & ReturnsValue<MemoEntity> {
        let memo = try await MemoStore.shared.add(title: title, priority: priority)
        // 作ったメモを返すと、ショートカットの次のアクションに渡せる
        return .result(value: memo)
    }
}
