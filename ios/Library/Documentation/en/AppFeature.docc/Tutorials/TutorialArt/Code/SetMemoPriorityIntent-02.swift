import AppIntents

struct SetMemoPriorityIntent: AppIntent {
    static let title: LocalizedStringResource = "Change Memo Priority"

    @Parameter(title: "Memo")
    var memo: MemoEntity

    @Parameter(title: "Priority")
    var priority: MemoPriority
}
