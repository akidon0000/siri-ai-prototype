import AppIntents
import Clients

// Remindersドメインの reminder スキーマに合わせる。AppEntity への準拠はマクロが付ける
@AppEntity(schema: .reminders.reminder)
public struct MemoEntity {
    // システムがこのメモを指すときに使う、変わらないID
    public let id: UUID
    var title: String
    // スキーマでの完了状態の名前は isCompleted
    var isCompleted: Bool
    var sharedWith: [String]
    // ここからはスキーマが求めるプロパティ。対応していない機能は nil や空の値を返す
    var note: AttributedString?
    var tags: Set<String>
    var urls: [URL]
    var dueDate: DateComponents?
    var recurrence: Calendar.RecurrenceRule?
    var isFlagged: Bool?
    var creationDate: Date?
    var completionDate: Date?
    var list: MemoListEntity
    var locationTrigger: MemoLocationTriggerEntity?

    public var displayRepresentation: DisplayRepresentation {
        DisplayRepresentation(
            title: "\(title)",
            subtitle: isCompleted ? "完了" : "未完了",
            image: .init(systemName: isCompleted ? "checkmark.circle.fill" : "circle")
        )
    }

    public static let defaultQuery = MemoQuery()
}

extension MemoEntity {
    nonisolated init(_ memo: Memo, list: MemoList = .default) {
        // マクロがスキーマのプロパティを @Property に変えるので、スキーマ外の保存プロパティを先に入れる
        id = memo.id
        sharedWith = memo.sharedWith
        title = memo.title
        isCompleted = memo.isCompleted
        note = memo.note.map { AttributedString($0) }
        tags = memo.tags
        urls = []
        dueDate = memo.dueDate
        recurrence = nil
        isFlagged = memo.isFlagged
        creationDate = memo.creationDate
        completionDate = memo.completionDate
        self.list = MemoListEntity(list)
        locationTrigger = nil
    }
}
