import Clients
import Foundation

/// `MemoClient` の実機実装。アプリターゲットだけがこのモジュールに依存する。
///
/// メモはメモリ内の配列に置く。アプリを終了すると消える。
public actor LiveMemoClient: MemoClient {
    private var storage: [Memo]

    public init(memos: [Memo] = []) {
        storage = memos
    }

    public func add(title: String, priority: Memo.Priority) -> Memo {
        let memo = Memo(title: title, priority: priority)
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

    public func delete(_ ids: [UUID]) {
        storage.removeAll { ids.contains($0.id) }
    }

    public func contains(title: String) -> Bool {
        storage.contains { $0.title.caseInsensitiveCompare(title) == .orderedSame }
    }

    public func complete(_ id: UUID) throws {
        try update(id) { $0.isDone = true }
    }

    private func update(_ id: UUID, _ change: (inout Memo) -> Void) throws {
        guard let index = storage.firstIndex(where: { $0.id == id }) else {
            throw MemoClientError.notFound(id)
        }
        change(&storage[index])
    }
}
