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
        DisplayRepresentation(title: "\(title)")
    }

    // Siriが名前やIDからメモを探すときに使うクエリ
    static let defaultQuery = MemoQuery()
}
