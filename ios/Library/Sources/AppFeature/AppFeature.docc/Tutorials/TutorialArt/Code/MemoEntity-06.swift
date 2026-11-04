import AppIntents

struct MemoEntity: AppEntity {
    // システムがこのメモを指すときに使う、変わらないID
    let id: UUID
    var title: String
    var isDone: Bool
    var sharedWith: [String]

    static let typeDisplayRepresentation: TypeDisplayRepresentation = "メモ"

    // Siriの応答・候補の一覧・Spotlightでメモ1件を表示するときの見た目
    var displayRepresentation: DisplayRepresentation {
        DisplayRepresentation(
            title: "\(title)",
            subtitle: isDone ? "完了" : "未完了",
            image: .init(systemName: isDone ? "checkmark.circle.fill" : "circle")
        )
    }

    // Siriが名前やIDからメモを探すときに使うクエリ
    static let defaultQuery = MemoQuery()
}
