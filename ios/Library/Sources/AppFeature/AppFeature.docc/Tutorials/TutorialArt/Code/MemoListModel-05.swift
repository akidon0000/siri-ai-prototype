import AppIntents

@MainActor
final class MemoListModel {
    // 画面の「追加」ボタンから呼ぶ
    func addMemoFromUI(title: String, list: MemoListEntity) async throws {
        let memo = try await MemoStore.shared.add(title: title, list: list, dueDate: nil)

        // 実際に人が行った操作だけをdonateする。実際より多いと、システムはこのアプリのdonationを無視する
        // パラメータはなるべく埋める。ただし予測に使ってほしくない値（本文など）は入れない
        // 同じ操作に当たるintentを組み立てる。システムはこれを実行せず、記録して学習に使う
        var intent = CreateMemoIntent()
        intent.title = title
        intent.list = list
        try await IntentDonationManager.shared.donate(intent: intent, result: .result(value: memo))
    }

    // 画面の優先度メニューから呼ぶ
    func setPriorityFromUI(_ memo: MemoEntity, to priority: MemoPriority) async throws {
        try await MemoStore.shared.setPriority(priority, for: memo.id)
    }
}
