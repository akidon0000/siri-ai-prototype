import AppIntents

@AppIntent(.tool)
struct SetMemoPriorityIntent: AppIntent {
    static let title: LocalizedStringResource = "メモの優先度を変える"
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
