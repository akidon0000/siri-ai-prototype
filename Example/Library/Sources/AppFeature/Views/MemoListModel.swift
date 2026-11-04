import Foundation
import Observation

/// メモ一覧の画面の状態。intent と同じ `MemoStore` を通して読み書きする。
@Observable
final class MemoListModel {
    private(set) var memos: [MemoEntity] = []
    var draftTitle = ""
    var errorMessage: String?

    private let store: MemoStore

    init(store: MemoStore = .shared) {
        self.store = store
    }

    func load() async {
        do {
            memos = try await store.allMemos()
        } catch {
            errorMessage = String(describing: error)
        }
    }

    /// Siri やショートカットからメモが変わったときにも、一覧を読み直す。
    func observeChanges() async {
        for await _ in NotificationCenter.default.notifications(named: MemoStore.didChangeNotification) {
            await load()
        }
    }

    func addDraft() async {
        let title = draftTitle.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !title.isEmpty else { return }
        do {
            _ = try await store.add(title: title, priority: .normal)
            draftTitle = ""
        } catch {
            errorMessage = String(describing: error)
        }
    }

    func delete(_ memos: [MemoEntity]) async {
        do {
            try await store.delete(memos.map(\.id))
        } catch {
            errorMessage = String(describing: error)
        }
    }

    func complete(_ memo: MemoEntity) async {
        do {
            try await store.complete(memo.id)
        } catch {
            errorMessage = String(describing: error)
        }
    }
}
