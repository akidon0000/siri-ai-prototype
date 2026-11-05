import AppIntents
import VisualIntelligence

// Called from visual intelligence's "More results", and opens the in-app search results
@AppIntent(schema: .visualIntelligence.semanticContentSearch)
struct ShowMemoSearchResultsIntent {
    // What was recognized from the camera or a screenshot
    var semanticContent: VisualIntelligence.SceneDescriptor

    func perform() async throws -> some IntentResult {
        // Show the list found with the same conditions as MemoVisualSearchQuery on the app's screen
        await MemoNavigator.shared.showVisualSearchResults(for: semanticContent)
        return .result()
    }
}
