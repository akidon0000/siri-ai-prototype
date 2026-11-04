import AppIntents
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
            let list = try await store.allLists().first
            let memo = try await store.add(title: title, list: list)
            draftTitle = ""

            // 実際に人が行った操作だけをdonateする。実際より多いと、システムはこのアプリのdonationを無視する
            // 同じ操作に当たるintentを組み立てる。システムはこれを実行せず、記録して学習に使う
            let intent = CreateMemoIntent()
            intent.title = title
            intent.list = list
            try await IntentDonationManager.shared.donate(intent: intent, result: .result(value: memo))
        } catch {
            errorMessage = String(describing: error)
        }
    }

    func setPriority(_ priority: MemoPriority, for memo: MemoEntity) async {
        do {
            try await store.setPriority(priority, for: memo.id)

            // スキーマに合わせていないツールのintentも、同じようにdonateできる
            #if SIRI_AI_PREVIEW
            guard #available(iOS 27.3, *) else { return }
            #endif
            let intent = SetMemoPriorityIntent()
            intent.memo = memo
            intent.priority = priority
            try await IntentDonationManager.shared.donate(intent: intent)
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
