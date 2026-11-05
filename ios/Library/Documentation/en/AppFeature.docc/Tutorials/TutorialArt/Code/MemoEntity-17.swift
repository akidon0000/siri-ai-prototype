import AppIntents
import CoreSpotlight

// Follows the Reminders domain's reminder schema. The macro adds the AppEntity conformance
@AppEntity(schema: .reminders.reminder)
// Making it an IndexedEntity lets you put it in the Spotlight index
struct MemoEntity: IndexedEntity {
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

    // Ask for device authentication (Face ID and so on) before a response that includes the body
    @Property(title: "Locked Memo Body", description: "The body of a locked memo",
              authenticationPolicy: .requiresLocalDeviceAuthentication)
    var lockedBody: String?

    // A value used only inside the app and its extensions. Hidden from Siri and Shortcuts
    @Property(title: "Sync Revision", visibility: .internal)
    var revision: Int

    // Compute a value that isn't stored and show it to Siri
    @ComputedProperty(title: "Overdue", description: "True if the due date has passed and the memo isn't completed")
    var isOverdue: Bool {
        !isCompleted && (dueDate?.date.map { $0 < .now } ?? false)
    }

    // Index the body as Spotlight's contentDescription
    @ComputedProperty(title: "Body", description: "The text of the memo's body", indexingKey: \.contentDescription)
    var noteText: String {
        note.map { String($0.characters) } ?? ""
    }

    // Spotlight has no matching attribute, so index it with the app's own key
    @ComputedProperty(title: "List Name", description: "The name of the list the memo is in",
                      customIndexingKey: CSCustomAttributeKey(keyName: "com_akidon0000_SiriAIPrototype_MemoEntity_listName")!)
    var listName: String {
        list.name
    }

    // A value that needs a server request. Siri fetches it only when it needs it
    @DeferredProperty(title: "Shared With", description: "The names of the people this memo is shared with", authenticationPolicy: .requiresAuthentication)
    var collaboratorNames: [String] {
        get async {
            await MemoStore.shared.displayNames(for: sharedWith)
        }
    }

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
