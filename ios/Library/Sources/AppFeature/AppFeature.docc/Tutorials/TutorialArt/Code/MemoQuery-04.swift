import AppIntents
import CoreSpotlight

struct MemoQuery: EntityStringQuery {
    func entities(for identifiers: [MemoEntity.ID]) async throws -> [MemoEntity] {
        try await MemoStore.shared.memos(for: identifiers)
    }

    func suggestedEntities() async throws -> [MemoEntity] {
        try await MemoStore.shared.recentMemos()
    }

    func entities(matching string: String) async throws -> [MemoEntity] {
        try await MemoStore.shared.memos(matching: string)
    }
}

extension MemoQuery: IndexedEntityQuery {
    func reindexAllEntities(indexDescription: CSSearchableIndexDescription) async throws {
        try await MemoSpotlightIndexer().index(MemoStore.shared.allMemos())
    }
}
