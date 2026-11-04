import AppIntents

struct SetMemoPriorityIntent: AppIntent {
    static let title: LocalizedStringResource = "メモの優先度を変える"

    @Parameter(title: "メモ")
    var memo: MemoEntity

    @Parameter(title: "優先度")
    var priority: MemoPriority
}
