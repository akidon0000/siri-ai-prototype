import AppIntents

struct AddMemoIntent: AppIntent, PredictableIntent {
    static let title: LocalizedStringResource = "メモを追加"
    static let description = IntentDescription("新しいメモを1件追加する。")

    @Parameter(title: "タイトル", requestValueDialog: "どんなメモを追加しますか？")
    var title: String

    @Parameter(title: "優先度", default: .normal)
    var priority: MemoPriority

    static var parameterSummary: some ParameterSummary {
        Summary("\(\.$title)を優先度\(\.$priority)で追加")
    }

    static var predictionConfiguration: some IntentPredictionConfiguration {
        IntentPrediction(parameters: (\Self.$title)) { title in
            DisplayRepresentation(title: "「\(title)」をメモに追加")
        }
    }

    func perform() async throws -> some IntentResult & ReturnsValue<MemoEntity> & ProvidesDialog & ShowsSnippetIntent {
        if try await MemoStore.shared.contains(title: title) {
            title = try await $title.requestValue("同じ名前のメモがあります。別の名前にしますか？")
        }
        let memo = try await MemoStore.shared.add(title: title, priority: priority)
        return .result(
            value: memo,
            dialog: IntentDialog(full: "「\(memo.title)」をメモに追加しました。", supporting: "追加しました"),
            snippetIntent: MemoSnippetIntent(memo: memo)
        )
    }
}
