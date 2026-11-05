import AppIntents

struct AddMemoIntent: AppIntent {
    static let title: LocalizedStringResource = "Add Memo"
    // The description in the Shortcuts app. Siri also reads it to learn what the intent does
    static let description = IntentDescription("Adds one new memo.")

    @Parameter(title: "Title")
    var title: String

    // It's an AppEnum, so Siri picks from Low, Normal and High. Normal if not said
    @Parameter(title: "Priority", default: .normal)
    var priority: MemoPriority
}
