import AppIntents

struct AddMemoIntent: AppIntent {
    static let title: LocalizedStringResource = "Add Memo"
    // The description in the Shortcuts app. Siri also reads it to learn what the intent does
    static let description = IntentDescription("Adds one new memo.")
}
