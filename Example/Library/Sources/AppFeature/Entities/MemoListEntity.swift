import AppIntents
import Clients

// Remindersドメインの list スキーマ。id と name は名前も型もスキーマ通りにする
@AppEntity(schema: .reminders.list)
struct MemoListEntity {
    let id: UUID
    var name: String
    var type: MemoListType

    var displayRepresentation: DisplayRepresentation {
        DisplayRepresentation(title: "\(name)")
    }

    static let defaultQuery = MemoListQuery()
}

extension MemoListEntity {
    nonisolated init(_ list: MemoList) {
        id = list.id
        name = list.name
        type = .standard
    }
}

// スキーマのintentに渡すEntityは、名前で探せるクエリ（EntityStringQuery）が要る
struct MemoListQuery: EntityStringQuery {
    func entities(for identifiers: [MemoListEntity.ID]) async throws -> [MemoListEntity] {
        try await MemoStore.shared.allLists().filter { identifiers.contains($0.id) }
    }

    func suggestedEntities() async throws -> [MemoListEntity] {
        try await MemoStore.shared.allLists()
    }

    func entities(matching string: String) async throws -> [MemoListEntity] {
        try await MemoStore.shared.allLists().filter { $0.name.localizedCaseInsensitiveContains(string) }
    }
}
