import AppIntents

@MainActor
final class MemoListModel {
    func addMemoFromUI(title: String, list: MemoListEntity) async throws {
        let memo = try await MemoStore.shared.add(title: title, list: list, dueDate: nil)

        // Siri経由の操作はiOSが記録するが、画面を直接触った操作は見えない。保存が成功したあとに、アプリから報告する
        // 同じ操作に当たるintentを組み立てる。システムはこれを実行せず、記録して学習に使う
        // 毎朝メモを追加する人なら、その時間帯にロック画面やショートカットの候補に出ることがある
        var intent = CreateMemoIntent()
        intent.title = title
        intent.list = list
        try await IntentDonationManager.shared.donate(intent: intent, result: .result(value: memo))
    }
}
