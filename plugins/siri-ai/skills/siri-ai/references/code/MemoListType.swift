import AppIntents

// Remindersドメインの listType スキーマ。AppEnum への準拠はマクロが付ける
@AppEnum(schema: .reminders.listType)
enum MemoListType: String {
    case standard

    static let caseDisplayRepresentations: [Self: DisplayRepresentation] = [.standard: "通常"]
}
