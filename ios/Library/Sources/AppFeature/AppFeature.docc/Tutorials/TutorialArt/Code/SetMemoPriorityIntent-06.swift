import AppIntents

// .tool は AppIntentTraits の値。[.tool] と配列でも書ける。変数や計算した値は渡せない
@AppIntent(.tool)
struct SetMemoPriorityIntent: AppIntent {
    static let title: LocalizedStringResource = "メモの優先度を変える"
    // Siriのモデルはこの説明を読んで、いつこのツールを使うかを決める。アプリを知らない人に向けて書く
    static let description = IntentDescription("メモ1件の優先度を、低・通常・高のいずれかに変更する。")

    // 何を渡せばよいかを書く
    @Parameter(title: "メモ", description: "優先度を変えたいメモ")
    var memo: MemoEntity

    // 取りうる値があれば書いておく
    @Parameter(title: "優先度", description: "変更後の優先度。低・通常・高のいずれか")
    var priority: MemoPriority

    func perform() async throws -> some IntentResult {
        try await MemoStore.shared.setPriority(priority, for: memo.id)
        return .result()
    }
}
