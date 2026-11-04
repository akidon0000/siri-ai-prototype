import AppIntents
import CoreSpotlight

struct MemoSpotlightIndexer {
    private let searchIndex = CSSearchableIndex(name: "memos")

    func index(_ memos: [MemoEntity]) async throws {
        try await searchIndex.indexAppEntities(memos)
    }
}
