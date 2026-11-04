import Foundation

/// メモ1件。App Intents には依存しない、アプリ内部の表現。
public struct Memo: Sendable, Equatable, Identifiable {
    public enum Priority: String, Sendable, CaseIterable {
        case low, normal, high
    }

    public let id: UUID
    public var title: String
    public var isDone: Bool
    public var priority: Priority
    public var creationDate: Date
    /// 共有している相手のID。空なら自分だけのメモ。
    public var sharedWith: [String]

    public init(
        id: UUID = UUID(),
        title: String,
        isDone: Bool = false,
        priority: Priority = .normal,
        creationDate: Date = .now,
        sharedWith: [String] = []
    ) {
        self.id = id
        self.title = title
        self.isDone = isDone
        self.priority = priority
        self.creationDate = creationDate
        self.sharedWith = sharedWith
    }
}

public enum MemoClientError: Error, Equatable {
    case notFound(UUID)
}
