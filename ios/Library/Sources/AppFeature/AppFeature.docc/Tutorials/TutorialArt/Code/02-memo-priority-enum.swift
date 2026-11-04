import AppIntents

// AppEnum: アプリ独自の列挙値をシステムに公開する型。
// caseDisplayRepresentationsで各caseの表示名（Siriが読む言葉）を決める。
enum MemoPriority: String, AppEnum {
    case low, normal, high

    static let typeDisplayRepresentation: TypeDisplayRepresentation = "優先度"

    static let caseDisplayRepresentations: [MemoPriority: DisplayRepresentation] = [
        .low: "低",
        .normal: "通常",
        .high: "高",
    ]
}
