import AppIntents

// The Reminders domain's listType schema. The macro adds the AppEnum conformance
@AppEnum(schema: .reminders.listType)
enum MemoListType: String {
    case standard

    static let caseDisplayRepresentations: [Self: DisplayRepresentation] = [.standard: "Standard"]
}
