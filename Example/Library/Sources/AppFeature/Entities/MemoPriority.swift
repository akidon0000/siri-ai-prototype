import AppIntents
import Clients

// AppEnum にすると、Siriは決まった選択肢の中から値を選ぶ。フレーズにも埋め込める
enum MemoPriority: String, AppEnum {
    case low, normal, high

    static let typeDisplayRepresentation: TypeDisplayRepresentation = "優先度"

    static let caseDisplayRepresentations: [MemoPriority: DisplayRepresentation] = [
        .low: "低",
        .normal: "通常",
        .high: "高",
    ]
}

extension MemoPriority {
    nonisolated init(_ priority: Memo.Priority) {
        switch priority {
        case .low: self = .low
        case .normal: self = .normal
        case .high: self = .high
        }
    }

    nonisolated var clientValue: Memo.Priority {
        switch self {
        case .low: .low
        case .normal: .normal
        case .high: .high
        }
    }
}
