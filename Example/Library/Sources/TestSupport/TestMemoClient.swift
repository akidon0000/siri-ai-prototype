import Clients
import Foundation

/// テスト用の `MemoClient`。決まったIDと日時を持つ固定データから始まる。
public actor TestMemoClient: MemoClient {
    public static let milkID = UUID(uuidString: "00000000-0000-0000-0000-000000000001")!
    public static let breadID = UUID(uuidString: "00000000-0000-0000-0000-000000000002")!

    public static let seed: [Memo] = [
        Memo(id: milkID, title: "牛乳を買う", priority: .high, creationDate: Date(timeIntervalSince1970: 100)),
        Memo(id: breadID, title: "パンを買う", creationDate: Date(timeIntervalSince1970: 200)),
    ]

    public private(set) var storage: [Memo]
    private var nextID = 100

    public init(memos: [Memo] = TestMemoClient.seed) {
        storage = memos
    }

    /// IDと作成日時は、テストで比べやすいように連番で振り直す。
    public func add(_ memo: Memo) -> Memo {
        nextID += 1
        var memo = memo
        memo = Memo(
            id: UUID(uuidString: String(format: "00000000-0000-0000-0000-%012d", nextID))!,
            title: memo.title, isCompleted: memo.isCompleted, priority: memo.priority,
            creationDate: Date(timeIntervalSince1970: Double(nextID * 100)),
            sharedWith: memo.sharedWith, note: memo.note, tags: memo.tags,
            dueDate: memo.dueDate, isFlagged: memo.isFlagged, listID: memo.listID,
            lockedBody: memo.lockedBody, revision: memo.revision
        )
        storage.append(memo)
        return memo
    }

    public func memos(for ids: [UUID]) -> [Memo] {
        ids.compactMap { id in storage.first { $0.id == id } }
    }

    public func recentMemos() -> [Memo] {
        storage.filter { !$0.isCompleted }.sorted { $0.creationDate > $1.creationDate }
    }

    public func memos(matching string: String) -> [Memo] {
        storage.filter { $0.title.localizedCaseInsensitiveContains(string) }
    }

    public func allMemos() -> [Memo] {
        storage
    }

    public func delete(_ ids: [UUID]) {
        storage.removeAll { ids.contains($0.id) }
    }

    public func contains(title: String) -> Bool {
        storage.contains { $0.title.caseInsensitiveCompare(title) == .orderedSame }
    }

    public func update(_ id: UUID, _ change: MemoChange) throws -> Memo {
        guard let index = storage.firstIndex(where: { $0.id == id }) else {
            throw MemoClientError.notFound(id)
        }
        change.apply(to: &storage[index])
        return storage[index]
    }

    public func allLists() -> [MemoList] {
        [.default]
    }

    // このアプリにはアカウントも添付も無いので、IDをそのまま名前にし、読み取った文字は空にする
    public func displayNames(for userIDs: [String]) -> [String] {
        userIDs
    }

    public func recognizedText(for id: UUID) -> String {
        ""
    }
}
