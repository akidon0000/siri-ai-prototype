import AppIntents

// .system.searchInApp: 「〜をアプリで検索して」で呼ばれ、アプリ内の検索結果を開く
@AppIntent(schema: .system.searchInApp)
struct SearchMemosIntent: ShowInAppSearchResultsIntent {
    static let searchScopes: [StringSearchScope] = [.general]
    // 検索語は criteria.term に入る
    var criteria: StringSearchCriteria

    func perform() async throws -> some IntentResult {
        await MemoNavigator.shared.showSearchResults(for: criteria.term)
        return .result()
    }
}
