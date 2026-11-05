import AppIntents

// Offers options for a parameter. Siri can find entities among them even if they aren't indexed
// Usage: @Parameter(title: "Memo", optionsProvider: PinnedMemosOptionsProvider()) var memo: MemoEntity
struct PinnedMemosOptionsProvider: DynamicOptionsProvider {
    func results() async throws -> [MemoEntity] {
        try await MemoStore.shared.pinnedMemos()
    }
}
