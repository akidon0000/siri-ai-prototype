import AppIntents

// A tool that finds memos by conditions. No schema covers it, so .tool exposes it to Siri
@AppIntent(.tool)
struct FindMemosIntent: AppIntent {
    static let title: LocalizedStringResource = "Find Memos"
    // Siri's model reads this description to decide when to use this tool
    static let description = IntentDescription("Finds incomplete memos that match a keyword and priorities.")

    // MemoSearch is generable, so Siri builds the value from the request and passes it in
    @Parameter(title: "Search Conditions", description: "The conditions of the memos to find")
    var search: MemoSearch

    // The memos you return are passed as is to the parameters of the next tool called
    func perform() async throws -> some ReturnsValue<[MemoEntity]> {
        .result(value: try await MemoStore.shared.memos(matching: search))
    }
}
