import AppIntents

@AppEntity(schema: .reminders.reminder)
struct MemoEntity: IndexedEntity {
    let id: UUID
    var title: String
    var isCompleted: Bool
    var sharedWith: [String]
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

    @Property(title: "鍵付きメモの本文", description: "ロックしたメモの本文",
              authenticationPolicy: .requiresLocalDeviceAuthentication)
    var lockedBody: String?

    @Property(title: "同期リビジョン", visibility: .internal)
    var revision: Int

    @ComputedProperty(title: "期限切れ", description: "期限を過ぎていて、まだ完了していなければtrue")
    var isOverdue: Bool {
        !isCompleted && (dueDate?.date.map { $0 < .now } ?? false)
    }

    var displayRepresentation: DisplayRepresentation {
        DisplayRepresentation(
            title: "\(title)",
            subtitle: isCompleted ? "完了" : "未完了",
            image: .init(systemName: isCompleted ? "checkmark.circle.fill" : "circle")
        )
    }

    static let defaultQuery = MemoQuery()
}
