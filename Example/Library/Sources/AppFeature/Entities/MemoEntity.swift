import AppIntents
import Clients

public struct MemoEntity: AppEntity {
    // システムがこのメモを指すときに使う、変わらないID
    public let id: UUID
    var title: String
    var isDone: Bool
    var sharedWith: [String]

    public static let typeDisplayRepresentation: TypeDisplayRepresentation = "メモ"

    // Siriの応答・候補の一覧・Spotlightでメモ1件を表示するときの見た目
    public var displayRepresentation: DisplayRepresentation {
        DisplayRepresentation(
            title: "\(title)",
            subtitle: isDone ? "完了" : "未完了",
            image: .init(systemName: isDone ? "checkmark.circle.fill" : "circle")
        )
    }

    public static let defaultQuery = MemoQuery()
}

extension MemoEntity {
    nonisolated init(_ memo: Memo) {
        id = memo.id
        title = memo.title
        isDone = memo.isDone
        sharedWith = memo.sharedWith
    }
}
