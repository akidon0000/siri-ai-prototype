import AppIntents
import Clients

struct MemoEntity: AppEntity {
    // システムがこのメモを指すときに使う、変わらないID
    let id: UUID
    var title: String
    var isDone: Bool

    static let typeDisplayRepresentation: TypeDisplayRepresentation = "メモ"

    var displayRepresentation: DisplayRepresentation {
        DisplayRepresentation(title: "\(title)")
    }

    static let defaultQuery = MemoQuery()
}

extension MemoEntity {
    nonisolated init(_ memo: Memo) {
        id = memo.id
        title = memo.title
        isDone = memo.isDone
    }
}
