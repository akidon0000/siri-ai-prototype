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

    /// 共有相手のIDから表示名を引く。サーバーへの問い合わせを想定した、時間のかかる処理。
    func displayNames(for userIDs: [String]) async throws -> [String]
    /// 添付画像から読み取った文字。
    func recognizedText(for id: UUID) async throws -> String
}

extension MemoClient {
    public func add(title: String, priority: Memo.Priority) async throws -> Memo {
        try await add(Memo(title: title, priority: priority))
    }

    public func complete(_ id: UUID) async throws {
        _ = try await update(id, MemoChange(isCompleted: true))
    }
}
