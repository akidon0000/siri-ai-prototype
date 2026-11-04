import AppIntents

@MainActor
final class MemoListModel {
    func addMemoFromUI(title: String, list: MemoListEntity) async throws {
        let memo = try await MemoStore.shared.add(title: title, list: list, dueDate: nil)

        var intent = CreateMemoIntent()
        intent.title = title
        intent.list = list
        try await IntentDonationManager.shared.donate(intent: intent, result: .result(value: memo))
    }
}
