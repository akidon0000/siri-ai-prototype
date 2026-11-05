import AppIntents

// .tool is an AppIntentTraits value. [.tool] works too. No variables or computed values
@AppIntent(.tool)
// Called without the app name if the app is in front, has a Live Activity, or came up in a Siri app conversation
struct SetMemoPriorityIntent: AppIntent {
    static let title: LocalizedStringResource = "Change Memo Priority"
    // Siri's model reads this to decide when to use the tool. Write for someone who doesn't know the app
    static let description = IntentDescription("Changes the priority of one memo to Low, Normal or High.")

    // Say what to pass
    @Parameter(title: "Memo", description: "The memo whose priority to change")
    var memo: MemoEntity

    // List the possible values, if any
    @Parameter(title: "Priority", description: "The new priority. One of Low, Normal or High")
    var priority: MemoPriority

    func perform() async throws -> some IntentResult {
        try await MemoStore.shared.setPriority(priority, for: memo.id)
        return .result()
    }
}
