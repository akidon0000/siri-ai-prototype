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

    func displayRepresentations(
        for identifiers: [MemoEntity.ID],
        requestedComponents: DisplayRepresentation.Components = .text
    ) async throws -> [MemoEntity.ID: DisplayRepresentation] {
        try await MemoStore.shared.titles(for: identifiers).mapValues { DisplayRepresentation(title: "\($0)") }
    }
}

extension MemoQuery: IndexedEntityQuery {
    func reindexAllEntities(indexDescription: CSSearchableIndexDescription) async throws {
        try await MemoSpotlightIndexer().index(MemoStore.shared.allMemos())
    }

    func reindexEntities(for identifiers: [MemoEntity.ID],
                         indexDescription: CSSearchableIndexDescription) async throws {
        try await MemoSpotlightIndexer().index(MemoStore.shared.memos(for: identifiers))
    }
}
