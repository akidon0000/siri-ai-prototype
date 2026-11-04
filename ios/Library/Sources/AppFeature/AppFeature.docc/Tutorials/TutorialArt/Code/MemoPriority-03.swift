import AppIntents

// AppEnum にすると、Siriは決まった選択肢の中から値を選ぶ。フレーズにも埋め込める
enum MemoPriority: String, AppEnum {
    case low, normal, high

    // ShortcutsアプリやSiriでの型の名前
    static let typeDisplayRepresentation: TypeDisplayRepresentation = "優先度"

    // 読み上げと表示に使う、各ケースの名前
    static let caseDisplayRepresentations: [MemoPriority: DisplayRepresentation] = [
        .low: "低",
        .normal: "通常",
        .high: "高",
    ]
}
