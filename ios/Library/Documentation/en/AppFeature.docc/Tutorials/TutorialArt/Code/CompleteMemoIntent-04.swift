import AppIntents

// At build time, metadata for Siri, Shortcuts and Spotlight is generated from this type
// "Complete Memo" appears in the Shortcuts app as soon as the app is installed
struct CompleteMemoIntent: AppIntent {
    static let title: LocalizedStringResource = "Complete Memo"

    // If there's no value, the system asks back with MemoEntity suggestions
    @Parameter(title: "Memo")
    var memo: MemoEntity

    func perform() async throws -> some IntentResult {
        try await MemoStore.shared.complete(memo.id)
        return .result()
    }
}
