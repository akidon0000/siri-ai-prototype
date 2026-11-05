import AppIntents

struct AddMemoIntent: AppIntent {
    static let title: LocalizedStringResource = "Add Memo"
    // The description in the Shortcuts app. Siri also reads it to learn what the intent does
    static let description = IntentDescription("Adds one new memo.")

    // When the value is missing, Siri asks with this sentence
    @Parameter(title: "Title", requestValueDialog: "What memo do you want to add?")
    var title: String

    // It's an AppEnum, so Siri picks from Low, Normal and High. Normal if not said
    @Parameter(title: "Priority", default: .normal)
    var priority: MemoPriority

    // The Shortcuts app shows the action as this one sentence with the parameters embedded
    static var parameterSummary: some ParameterSummary {
        Summary("Add \(\.$title) with priority \(\.$priority)")
    }

    func perform() async throws -> some IntentResult & ReturnsValue<MemoEntity> & ProvidesDialog {
        let memo = try await MemoStore.shared.add(title: title, priority: priority)
        // Returning the new memo lets the next action in a shortcut use it
        return .result(
            value: memo,
            // full is read aloud when there's no screen; supporting is a short line shown with the screen
            dialog: IntentDialog(full: "Added '\(memo.title)' to your memos.", supporting: "Added")
        )
    }
}
