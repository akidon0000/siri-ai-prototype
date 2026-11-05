import AppIntents

// Follows the Reminders domain's reminder schema. The macro adds the AppEntity conformance
@AppEntity(schema: .reminders.reminder)
struct MemoEntity {
    // A stable ID the system uses to refer to this memo
    let id: UUID
    var title: String
    // The schema names the completion state isCompleted
    var isCompleted: Bool
    var sharedWith: [String]
    // Properties the schema requires. Return nil or empty values for unsupported features
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

    // How one memo looks in Siri's responses, suggestion lists and Spotlight
    var displayRepresentation: DisplayRepresentation {
        DisplayRepresentation(
            title: "\(title)",
            subtitle: isCompleted ? "Done" : "Not Done",
            image: .init(systemName: isCompleted ? "checkmark.circle.fill" : "circle")
        )
    }

    // The query Siri uses to find memos by name or ID
    static let defaultQuery = MemoQuery()
}
