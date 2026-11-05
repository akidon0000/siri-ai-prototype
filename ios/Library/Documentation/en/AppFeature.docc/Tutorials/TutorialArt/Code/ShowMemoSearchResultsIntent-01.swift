import AppIntents
import VisualIntelligence

// Called from visual intelligence's "More results", and opens the in-app search results
@AppIntent(schema: .visualIntelligence.semanticContentSearch)
struct ShowMemoSearchResultsIntent {
    // What was recognized from the camera or a screenshot
    var semanticContent: VisualIntelligence.SceneDescriptor
}
