import AppIntents

// App Shortcuts はアプリのターゲットに置くので、そこから参照できるように public にする
// PredictableIntent: 提案として表示されるときの文言を決められる
public struct AddMemoIntent: AppIntent, PredictableIntent {
    public static let title: LocalizedStringResource = "メモを追加"
    // Shortcutsアプリでの説明。Siriもこれを読んでintentの役割を知る
    public static let description = IntentDescription("新しいメモを1件追加する。")

    // 値が無いとき、Siriはこの文で聞き返す
    @Parameter(title: "タイトル", requestValueDialog: "どんなメモを追加しますか？")
    public var title: String

    @Parameter(title: "優先度", default: .normal)
    public var priority: MemoPriority

    public init() {}

    // 対応する全ての言語で、自然な1文として読めるかをShortcutsアプリで確かめる
    public static var parameterSummary: some ParameterSummary {
        Summary("\(\.$title)を優先度\(\.$priority)で追加")
    }

    public static var predictionConfiguration: some IntentPredictionConfiguration {
        IntentPrediction(parameters: (\.$title)) { title in
            DisplayRepresentation(title: "「\(title)」をメモに追加")
        }
    }

    // Shortcutsから実行すると、この行に置いたブレークポイントで止まる
    public func perform() async throws -> some IntentResult & ReturnsValue<MemoEntity> & ProvidesDialog & ShowsSnippetIntent {
        // 同じ名前のメモがあれば、その場で別の名前を聞き返す
        if try await MemoStore.shared.contains(title: title) {
            title = try await $title.requestValue("同じ名前のメモがあります。別の名前にしますか？")
        }
        let memo = try await MemoStore.shared.add(title: title, priority: priority)
        return .result(
            value: memo,
            // full は画面が無いときに読み上げる文、supporting は画面と一緒に出す短い文
            dialog: IntentDialog(full: "「\(memo.title)」をメモに追加しました。", supporting: "追加しました"),
            // ボタンを押せるスニペットは、ビューではなく SnippetIntent で返す
            snippetIntent: MemoSnippetIntent(memo: memo)
        )
    }
}
