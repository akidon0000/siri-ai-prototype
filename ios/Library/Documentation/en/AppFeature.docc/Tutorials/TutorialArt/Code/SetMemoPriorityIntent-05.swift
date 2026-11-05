import AppIntents

// .tool is an AppIntentTraits value. [.tool] works too. No variables or computed values
@AppIntent(.tool)
struct SetMemoPriorityIntent: AppIntent {
    static let title: LocalizedStringResource = "Change Memo Priority"

    @Parameter(title: "Memo")
    var memo: MemoEntity

    @Parameter(title: "Priority")
    var priority: MemoPriority

    func perform() async throws -> some IntentResult {
        try await MemoStore.shared.setPriority(priority, for: memo.id)
        return .result()
    }
}
