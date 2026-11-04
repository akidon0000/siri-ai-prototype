import AppIntents

// ビルド時に、この型からSiri・Shortcuts・Spotlight用のメタデータが生成される
// インストールした時点でShortcutsアプリに「メモを完了にする」が並ぶ
// SiriKitの CompleteMemoIntent を置き換える。旧intentのショートカットとdonationが引き継がれる
// 新規アプリでは要らない。SiriKitから移行するときだけ準拠させる
struct CompleteMemoIntent: AppIntent, CustomIntentMigratedAppIntent {
    static let intentClassName = "CompleteMemoIntent"
    static let title: LocalizedStringResource = "メモを完了にする"

    // 値が無ければ、システムが MemoEntity の候補を出して聞き返す
    @Parameter(title: "メモ")
    var memo: MemoEntity

    // システムがintentを作るときに使う
    init() {}

    // スニペットのボタンから、対象のメモを渡して作るときに使う
    init(memo: MemoEntity) {
        self.memo = memo
    }

    // 独自の応答は、Siriが結果から組み立てる応答で足りないときだけ返す
    func perform() async throws -> some IntentResult & ProvidesDialog {
        try await MemoStore.shared.complete(memo.id)
        // 短く、何が起きたかだけを書く。アプリ名はシステムが伝えるので入れない
        return .result(dialog: "「\(memo.title)」を完了にしました")
    }
}
