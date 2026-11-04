import AppIntents
import CoreSpotlight

// SiriやショートカットがIDからメモを取り出すときのクエリ
// EntityStringQuery にすると、名前（文字列）からも探せる
struct MemoQuery: EntityStringQuery {
    // 渡されたIDのメモを返す
    func entities(for identifiers: [MemoEntity.ID]) async throws -> [MemoEntity] {
        try await MemoStore.shared.memos(for: identifiers)
    }

    // 候補の一覧に出すメモ。ここでは最近のメモを返す
    func suggestedEntities() async throws -> [MemoEntity] {
        try await MemoStore.shared.recentMemos()
    }

    // Siriが聞き取った名前で探す
    func entities(matching string: String) async throws -> [MemoEntity] {
        try await MemoStore.shared.memos(matching: string)
    }

    // 表示だけが要るときに、Entity全体を作らずに表示を返す
    func displayRepresentations(
        for identifiers: [MemoEntity.ID],
        requestedComponents: DisplayRepresentation.Components = .text
    ) async throws -> [MemoEntity.ID: DisplayRepresentation] {
        try await MemoStore.shared.titles(for: identifiers).mapValues { DisplayRepresentation(title: "\($0)") }
    }
}

// Spotlightから索引のやり直しを頼まれたときに呼ばれる
extension MemoQuery: IndexedEntityQuery {
    // 全てのメモを入れ直す
    func reindexAllEntities(indexDescription: CSSearchableIndexDescription) async throws {
        try await MemoSpotlightIndexer().index(MemoStore.shared.allMemos())
    }

    // 指定されたメモだけを入れ直す
    func reindexEntities(for identifiers: [MemoEntity.ID],
                         indexDescription: CSSearchableIndexDescription) async throws {
        try await MemoSpotlightIndexer().index(MemoStore.shared.memos(for: identifiers))
    }
}
