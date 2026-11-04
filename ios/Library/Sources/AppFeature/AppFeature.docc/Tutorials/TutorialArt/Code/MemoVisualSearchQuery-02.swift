import AppIntents
import VisualIntelligence

struct MemoVisualSearchQuery: IntentValueQuery {
    func values(for input: SemanticContentDescriptor) async throws -> [MemoEntity] {
        try await MemoStore.shared.memos(matchingAnyOf: input.labels)
    }
}
