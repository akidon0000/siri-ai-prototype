import AppIntents

// At build time, metadata for Siri, Shortcuts and Spotlight is generated from this type
// "Complete Memo" appears in the Shortcuts app as soon as the app is installed
// Replaces SiriKit's CompleteMemoIntent. Shortcuts and donations of the old intent carry over
// Not needed in a new app. Conform only when migrating from SiriKit
struct CompleteMemoIntent: AppIntent, CustomIntentMigratedAppIntent {
    static let intentClassName = "CompleteMemoIntent"
    static let title: LocalizedStringResource = "Complete Memo"

    // If there's no value, the system asks back with MemoEntity suggestions
    @Parameter(title: "Memo")
    var memo: MemoEntity

    // Used when the system creates the intent
    init() {}

    // Used by the snippet's button to create the intent with the memo
    init(memo: MemoEntity) {
        self.memo = memo
    }

    // Return your own response only when the one Siri builds from the result isn't enough
    func perform() async throws -> some IntentResult & ProvidesDialog {
        // Throw an error that explains the situation. "Couldn't complete it" doesn't say what happened
        guard try await MemoStore.shared.exists(memo.id) else {
            throw MemoIntentError.memoDeleted
        }
        try await MemoStore.shared.complete(memo.id)
        // Keep it short and say only what happened. The system conveys the app name, so leave it out
        // Avoid device-dependent wording like "on this screen". Make full work by voice alone
        return .result(dialog: IntentDialog(full: "Completed '\(memo.title)'", supporting: "Completed"))
    }
}
