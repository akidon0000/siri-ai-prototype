import AppIntents

// Remindersドメインの reminder スキーマに合わせる。AppEntity への準拠はマクロが付ける
@AppEntity(schema: .reminders.reminder)
struct MemoEntity {
    // システムがこのメモを指すときに使う、変わらないID
    let id: UUID
    var title: String
    // スキーマでの完了状態の名前は isCompleted
    var isCompleted: Bool
    // 共有相手の一覧
    var sharedWith: [String]
    // ここからはスキーマが求めるプロパティ。対応していない機能は nil や空の値を返す
    var note: AttributedString?
    var tags: Set<String>
    var urls: [URL]
    var dueDate: DateComponents?
    var recurrence: Calendar.RecurrenceRule?

    // Siriの応答・候補の一覧・Spotlightでメモ1件を表示するときの見た目
    var displayRepresentation: DisplayRepresentation {
        DisplayRepresentation(
            title: "\(title)",
            subtitle: isCompleted ? "完了" : "未完了",
            image: .init(systemName: isCompleted ? "checkmark.circle.fill" : "circle")
        )
    }

    // Siriが名前やIDからメモを探すときに使うクエリ
    static let defaultQuery = MemoQuery()
}
