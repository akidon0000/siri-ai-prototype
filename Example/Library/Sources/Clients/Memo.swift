import Foundation

/// メモ1件。App Intents には依存しない、アプリ内部の表現。
public struct Memo: Sendable, Equatable, Identifiable {
    public enum Priority: String, Sendable, CaseIterable {
        case low, normal, high
    }

    public let id: UUID
    public var title: String
    public var isCompleted: Bool
    public var priority: Priority
    public var creationDate: Date
    public var completionDate: Date?
    /// 共有している相手のID。空なら自分だけのメモ。
    public var sharedWith: [String]
    public var note: String?
    public var tags: Set<String>
    public var dueDate: DateComponents?
    public var isFlagged: Bool
    public var listID: UUID
    /// ロックしたメモの本文。読むには端末の認証が要る。
    public var lockedBody: String?
    /// 同期のたびに増える番号。アプリの中だけで使う。
    public var revision: Int

    public init(
        id: UUID = UUID(),
        title: String,
        isCompleted: Bool = false,
        priority: Priority = .normal,
        creationDate: Date = .now,
        completionDate: Date? = nil,
        sharedWith: [String] = [],
        note: String? = nil,
        tags: Set<String> = [],
        dueDate: DateComponents? = nil,
        isFlagged: Bool = false,
        listID: UUID = MemoList.defaultID,
        lockedBody: String? = nil,
        revision: Int = 0
    ) {
        self.id = id
        self.title = title
        self.isCompleted = isCompleted
        self.priority = priority
        self.creationDate = creationDate
        self.completionDate = completionDate
        self.sharedWith = sharedWith
        self.note = note
        self.tags = tags
        self.dueDate = dueDate
        self.isFlagged = isFlagged
        self.listID = listID
        self.lockedBody = lockedBody
        self.revision = revision
    }
}

/// メモを入れるリスト。
public struct MemoList: Sendable, Equatable, Identifiable {
    public static let defaultID = UUID(uuidString: "10000000-0000-0000-0000-000000000000")!
    public static let `default` = MemoList(id: defaultID, name: "メモ")

    public let id: UUID
    public var name: String

    public init(id: UUID = UUID(), name: String) {
        self.id = id
        self.name = name
    }
}

/// `MemoClient.update(_:_:)` に渡す変更。nil の項目は変えない。
public struct MemoChange: Sendable, Equatable {
    public var title: String?
    public var isCompleted: Bool?
    public var note: String?
    public var tags: Set<String>?
    public var dueDate: DateComponents?
    public var isFlagged: Bool?
    public var listID: UUID?
    public var priority: Memo.Priority?

    public init(
        title: String? = nil,
        isCompleted: Bool? = nil,
        note: String? = nil,
        tags: Set<String>? = nil,
        dueDate: DateComponents? = nil,
        isFlagged: Bool? = nil,
        listID: UUID? = nil,
        priority: Memo.Priority? = nil
    ) {
        self.title = title
        self.isCompleted = isCompleted
        self.note = note
        self.tags = tags
        self.dueDate = dueDate
        self.isFlagged = isFlagged
        self.listID = listID
        self.priority = priority
    }

    /// 変更を `memo` に当てる。完了にしたときは完了日時も入れる。
    public func apply(to memo: inout Memo, now: Date = .now) {
        if let title { memo.title = title }
        if let isCompleted {
            memo.completionDate = isCompleted ? (memo.completionDate ?? now) : nil
            memo.isCompleted = isCompleted
        }
        if let note { memo.note = note }
        if let tags { memo.tags = tags }
        if let dueDate { memo.dueDate = dueDate }
        if let isFlagged { memo.isFlagged = isFlagged }
        if let listID { memo.listID = listID }
        if let priority { memo.priority = priority }
        memo.revision += 1
    }
}

public enum MemoClientError: Error, Equatable {
    case notFound(UUID)
}
