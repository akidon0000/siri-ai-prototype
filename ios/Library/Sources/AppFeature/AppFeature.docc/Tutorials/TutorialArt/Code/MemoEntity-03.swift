import AppIntents

struct MemoEntity: AppEntity {
    let id: UUID
    var title: String
    var isDone: Bool

    static let typeDisplayRepresentation: TypeDisplayRepresentation = "メモ"

    var displayRepresentation: DisplayRepresentation {
        DisplayRepresentation(title: "\(title)")
    }
}
