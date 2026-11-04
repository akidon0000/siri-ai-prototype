import AppIntents

@AppIntent(schema: .system.searchInApp)
struct SearchMemosIntent: ShowInAppSearchResultsIntent {
    static let searchScopes: [StringSearchScope] = [.general]
    var criteria: StringSearchCriteria

    func perform() async throws -> some IntentResult {
        await MemoNavigator.shared.showSearchResults(for: criteria.term)
        return .result()
    }
}
