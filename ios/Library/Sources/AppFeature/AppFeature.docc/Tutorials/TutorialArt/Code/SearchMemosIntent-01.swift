import AppIntents

@AppIntent(schema: .system.searchInApp)
struct SearchMemosIntent: ShowInAppSearchResultsIntent {
    static let searchScopes: [StringSearchScope] = [.general]
    var criteria: StringSearchCriteria
}
