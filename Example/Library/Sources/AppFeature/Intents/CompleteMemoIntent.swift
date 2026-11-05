import AppIntents

// SiriKitを使ったことが無いので、CustomIntentMigratedAppIntent には準拠しない（第1章）
public struct CompleteMemoIntent: AppIntent {
    public static let title: LocalizedStringResource = "メモを完了にする"

    // 値が無ければ、システムが MemoEntity の候補を出して聞き返す
    @Parameter(title: "メモ")
    public var memo: MemoEntity

    public init() {}

    // スニペットのボタンから、対象のメモを渡して作るときに使う
    init(memo: MemoEntity) {
        self.memo = memo
    }

    // 独自の応答は、Siriが結果から組み立てる応答で足りないときだけ返す
    public func perform() async throws -> some IntentResult & ProvidesDialog & ShowsSnippetIntent {
        // 状況が分かるエラーを投げる。「完了できませんでした」では何が起きたか分からない
        guard try await MemoStore.shared.exists(memo.id) else {
            throw MemoIntentError.memoDeleted
        }
        try await MemoStore.shared.complete(memo.id)
        // アプリ名はシステムが伝えるので入れない。full は音声だけで伝わる文にする
        // 返答のたびに、画像つきのスニペットを添える。スニペットは呼ばれた時点の最新の状態を読み直す
        return .result(
            dialog: IntentDialog(full: "「\(memo.title)」を完了にしました", supporting: "完了にしました"),
            snippetIntent: MemoSnippetIntent(memo: memo)
        )
    }
}
