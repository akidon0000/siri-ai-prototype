import AppIntents

struct MemoEntity: AppEntity {
    // A stable ID the system uses to refer to this memo
    let id: UUID
    var title: String
    var isDone: Bool

    static let typeDisplayRepresentation: TypeDisplayRepresentation = "Memo"
}
