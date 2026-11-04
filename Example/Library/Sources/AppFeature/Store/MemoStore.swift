import Clients
import Foundation
import Synchronization

/// チュートリアルの `MemoStore.shared` に当たる型。
///
/// `MemoClient` を包み、`Memo` と `MemoEntity` の変換と、変更の通知をまとめて受け持つ。
/// intent も画面もこの型を通して読み書きする。
public nonisolated final class MemoStore: Sendable {
    public static let shared = MemoStore()

    /// メモが増減・更新されたときに流れる通知。画面はこれを見て読み直す。
    public static let didChangeNotification = Notification.Name("MemoStore.didChange")

    private let client = Mutex<(any MemoClient)?>(nil)
    private let onChange = Mutex<(@Sendable () -> Void)?>(nil)

    init() {}

    /// アプリの起動時とテストの前に、使う `MemoClient` を渡す。
    /// `onChange` はメモが増減・更新されるたびに呼ばれる。アプリはここで App Shortcuts のパラメータを更新する。
    public func configure(client: any MemoClient, onChange: (@Sendable () -> Void)? = nil) {
        self.client.withLock { $0 = client }
        self.onChange.withLock { $0 = onChange }
    }

    private var memoClient: any MemoClient {
        get throws {
            guard let client = client.withLock({ $0 }) else { throw MemoStoreError.notConfigured }
            return client
        }
    }

    func add(title: String, priority: MemoPriority) async throws -> MemoEntity {
        let memo = try await memoClient.add(title: title, priority: priority.clientValue)
        memosDidChange()
        return MemoEntity(memo)
    }

    func memos(for ids: [MemoEntity.ID]) async throws -> [MemoEntity] {
        try await memoClient.memos(for: ids).map(MemoEntity.init)
    }

    func recentMemos() async throws -> [MemoEntity] {
        try await memoClient.recentMemos().map(MemoEntity.init)
    }

    func memos(matching string: String) async throws -> [MemoEntity] {
        try await memoClient.memos(matching: string).map(MemoEntity.init)
    }

    func allMemos() async throws -> [MemoEntity] {
        try await memoClient.allMemos().map(MemoEntity.init)
    }

    func memo(for id: MemoEntity.ID) async throws -> MemoEntity {
        guard let memo = try await memos(for: [id]).first else { throw MemoIntentError.memoDeleted }
        return memo
    }

    func exists(_ id: MemoEntity.ID) async throws -> Bool {
        try await !memoClient.memos(for: [id]).isEmpty
    }

    func contains(title: String) async throws -> Bool {
        try await memoClient.contains(title: title)
    }

    func delete(_ ids: [MemoEntity.ID]) async throws {
        try await memoClient.delete(ids)
        memosDidChange()
    }

    func complete(_ id: MemoEntity.ID) async throws {
        try await memoClient.complete(id)
        memosDidChange()
    }

    func memosDidChange() {
        onChange.withLock { $0 }?()
        NotificationCenter.default.post(name: Self.didChangeNotification, object: nil)
    }
}

enum MemoStoreError: Error {
    case notConfigured
}
