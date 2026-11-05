import AppIntents

// .system.searchInApp: called by "Search the app for …", and opens the in-app search results
@AppIntent(schema: .system.searchInApp)
struct SearchMemosIntent: ShowInAppSearchResultsIntent {
    static let searchScopes: [StringSearchScope] = [.general]
    // The search term is in criteria.term
    var criteria: StringSearchCriteria

    func perform() async throws -> some IntentResult {
        await MemoNavigator.shared.showSearchResults(for: criteria.term)
        return .result()
    }
}
