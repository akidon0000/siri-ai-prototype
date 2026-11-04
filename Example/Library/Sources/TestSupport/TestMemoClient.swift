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

    public func add(title: String, priority: Memo.Priority) -> Memo {
        nextID += 1
        let id = UUID(uuidString: String(format: "00000000-0000-0000-0000-%012d", nextID))!
        let memo = Memo(id: id, title: title, priority: priority, creationDate: Date(timeIntervalSince1970: Double(nextID * 100)))
        storage.append(memo)
        return memo
    }

    public func memos(for ids: [UUID]) -> [Memo] {
        ids.compactMap { id in storage.first { $0.id == id } }
    }

    public func recentMemos() -> [Memo] {
        storage.filter { !$0.isDone }.sorted { $0.creationDate > $1.creationDate }
    }

    public func memos(matching string: String) -> [Memo] {
        storage.filter { $0.title.localizedCaseInsensitiveContains(string) }
    }

    public func allMemos() -> [Memo] {
        storage
    }

    public func complete(_ id: UUID) throws {
        guard let index = storage.firstIndex(where: { $0.id == id }) else {
            throw MemoClientError.notFound(id)
        }
        storage[index].isDone = true
    }
}
