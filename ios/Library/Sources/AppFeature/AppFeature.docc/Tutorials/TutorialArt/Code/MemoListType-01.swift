import AppIntents

@AppEnum(schema: .reminders.listType)
enum MemoListType: String {
    case standard

    static let caseDisplayRepresentations: [Self: DisplayRepresentation] = [.standard: "通常"]
}
