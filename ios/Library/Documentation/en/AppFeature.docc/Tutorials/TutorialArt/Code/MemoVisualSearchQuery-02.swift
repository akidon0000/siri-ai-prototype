import AppIntents
import VisualIntelligence

// The query that receives visual intelligence searches. An app can have only one
struct MemoVisualSearchQuery: IntentValueQuery {
    func values(for input: SemanticContentDescriptor) async throws -> [MemoEntity] {
        // labels holds English labels like "milk", with no translation or synonym expansion
        try await MemoStore.shared.memos(matchingAnyOf: input.labels)
    }
}
