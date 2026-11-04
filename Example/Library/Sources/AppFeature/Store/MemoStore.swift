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

    // MARK: 読み取り

    func memos(for ids: [MemoEntity.ID]) async throws -> [MemoEntity] {
        try await entities(memoClient.memos(for: ids))
    }

    func recentMemos() async throws -> [MemoEntity] {
        try await entities(memoClient.recentMemos())
    }

    func memos(matching string: String) async throws -> [MemoEntity] {
        try await entities(memoClient.memos(matching: string))
    }

    func allMemos() async throws -> [MemoEntity] {
        try await entities(memoClient.allMemos())
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

    func allLists() async throws -> [MemoListEntity] {
        try await memoClient.allLists().map(MemoListEntity.init)
    }

    // MARK: 書き込み

    func add(title: String, priority: MemoPriority) async throws -> MemoEntity {
        try await add(Memo(title: title, priority: priority.clientValue))
    }

    func add(
        title: String,
        note: String? = nil,
        tags: Set<String> = [],
        dueDate: DateComponents? = nil,
        isFlagged: Bool = false,
        list: MemoListEntity? = nil
    ) async throws -> MemoEntity {
        try await add(Memo(
            title: title,
            note: note,
            tags: tags,
            dueDate: dueDate,
            isFlagged: isFlagged,
            listID: list?.id ?? MemoList.defaultID
        ))
    }

    private func add(_ memo: Memo) async throws -> MemoEntity {
        let added = try await memoClient.add(memo)
        memosDidChange()
        return try await entities([added])[0]
    }

    func update(_ id: MemoEntity.ID, _ change: MemoChange) async throws -> MemoEntity {
        let updated = try await memoClient.update(id, change)
        memosDidChange()
        return try await entities([updated])[0]
    }

    func delete(_ ids: [MemoEntity.ID]) async throws {
        try await memoClient.delete(ids)
        memosDidChange()
    }

    func complete(_ id: MemoEntity.ID) async throws {
        _ = try await update(id, MemoChange(isCompleted: true))
    }

    // MARK: 変換と通知

    /// リストの名前も入れた `MemoEntity` を作る。
    private func entities(_ memos: [Memo]) async throws -> [MemoEntity] {
        let lists = try await memoClient.allLists()
        return memos.map { memo in
            MemoEntity(memo, list: lists.first { $0.id == memo.listID } ?? .default)
        }
    }

    func memosDidChange() {
        onChange.withLock { $0 }?()
        NotificationCenter.default.post(name: Self.didChangeNotification, object: nil)
    }
}

enum MemoStoreError: Error {
    case notConfigured
}
