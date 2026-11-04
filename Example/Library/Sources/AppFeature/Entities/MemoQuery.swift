import AppIntents
import CoreSpotlight

// EntityStringQuery にすると、名前（文字列）からも探せる
public struct MemoQuery: EntityStringQuery {
    public init() {}

    public func entities(for identifiers: [MemoEntity.ID]) async throws -> [MemoEntity] {
        try await MemoStore.shared.memos(for: identifiers)
    }

    // 候補の一覧に出すメモ。ここでは最近のメモを返す
    public func suggestedEntities() async throws -> [MemoEntity] {
        try await MemoStore.shared.recentMemos()
    }

    // Siriが聞き取った名前で探す
    public func entities(matching string: String) async throws -> [MemoEntity] {
        try await MemoStore.shared.memos(matching: string)
    }

    // 表示だけが要るときに、Entity全体を作らずに表示を返す
    // iOS 27.1 のSDKには requestedComponents を取る形が無いので、IDだけを受け取る形にする
    public func displayRepresentations(for identifiers: [MemoEntity.ID]) async throws -> [MemoEntity.ID: DisplayRepresentation] {
        try await MemoStore.shared.titles(for: identifiers).mapValues { DisplayRepresentation(title: "\($0)") }
    }
}

// Spotlightから索引のやり直しを頼まれたときに呼ばれる
extension MemoQuery: IndexedEntityQuery {
    public func reindexAllEntities(indexDescription: CSSearchableIndexDescription) async throws {
        try await MemoStore.shared.reindexAll()
    }

    public func reindexEntities(for identifiers: [MemoEntity.ID],
                                indexDescription: CSSearchableIndexDescription) async throws {
        try await MemoStore.shared.reindex(identifiers)
    }
}
