import AppIntents

struct MemoEntity: AppEntity {
    // A stable ID the system uses to refer to this memo
    let id: UUID
    var title: String
    var isDone: Bool

    static let typeDisplayRepresentation: TypeDisplayRepresentation = "Memo"

    // How one memo looks in Siri's responses, suggestion lists and Spotlight
    var displayRepresentation: DisplayRepresentation {
        DisplayRepresentation(title: "\(title)")
    }

    // The query Siri uses to find memos by name or ID
    static let defaultQuery = MemoQuery()
}
