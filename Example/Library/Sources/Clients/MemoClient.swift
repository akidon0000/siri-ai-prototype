import Foundation

/// Siri/App Intents から呼び出すドメインロジックのインターフェース。
///
/// 実装は `ClientsLive` に置き、`AppFeature` はこのプロトコルにだけ依存する。
/// チュートリアルの `MemoStore` が呼んでいるメソッドを、ここに揃える。
///
/// Siri 連携は App Intents だけで実装する。SiriKit（Intents / IntentsUI / `.intentdefinition`）は使わない。
public protocol MemoClient: Sendable {
    func add(_ memo: Memo) async throws -> Memo
    /// 渡した順に、見つかったメモだけを返す。
    func memos(for ids: [UUID]) async throws -> [Memo]
    /// 新しい順に並べた、未完了のメモ。
    func recentMemos() async throws -> [Memo]
    /// タイトルに `string` を含むメモ。大文字・小文字は区別しない。
    func memos(matching string: String) async throws -> [Memo]
    func allMemos() async throws -> [Memo]
    func update(_ id: UUID, _ change: MemoChange) async throws -> Memo
    func delete(_ ids: [UUID]) async throws
    /// 同じタイトル（大文字・小文字は区別しない）のメモがあるか。
    func contains(title: String) async throws -> Bool

    func allLists() async throws -> [MemoList]
}

extension MemoClient {
    public func add(title: String, priority: Memo.Priority) async throws -> Memo {
        try await add(Memo(title: title, priority: priority))
    }

    public func complete(_ id: UUID) async throws {
        _ = try await update(id, MemoChange(isCompleted: true))
    }
}
