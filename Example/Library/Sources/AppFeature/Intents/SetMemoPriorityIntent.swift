import AppIntents

// 27.3 beta では @AppIntent(.tool) でSiriのツールにする。27.1 では普通のAppIntentとしてShortcutsに出る
// .tool は AppIntentTraits の値。変数や計算した値は渡せない
#if SIRI_AI_PREVIEW
@available(iOS 27.3, *)
@AppIntent(.tool)
#endif
// アプリが前面にある・Live Activityを表示中・Siriアプリの会話に出てきた、のどれかならアプリ名なしで呼ばれる
// アプリが後ろにあるときは、依頼にアプリ名があるか、MemoEntityが検索結果に出たときに呼ばれる
struct SetMemoPriorityIntent: AppIntent {
    static let title: LocalizedStringResource = "メモの優先度を変える"
    // Siriのモデルはこの説明を読んで、いつこのツールを使うかを決める。アプリを知らない人に向けて書く
    static let description = IntentDescription("メモ1件の優先度を、低・通常・高のいずれかに変更する。")

    @Parameter(title: "メモ", description: "優先度を変えたいメモ")
    var memo: MemoEntity

    @Parameter(title: "優先度", description: "変更後の優先度。低・通常・高のいずれか")
    var priority: MemoPriority

    func perform() async throws -> some IntentResult {
        try await MemoStore.shared.setPriority(priority, for: memo.id)
        return .result()
    }
}
