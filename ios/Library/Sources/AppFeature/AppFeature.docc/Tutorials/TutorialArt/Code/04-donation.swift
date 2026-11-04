import AppIntents

// Siri経由の操作はシステムが自動的に学習するが、
// アプリのUI操作からの行動はこちらから明示的にdonateしないと学習されない。
@MainActor
final class MemoListModel {
    func addMemoFromUI(title: String, priority: MemoPriority) async throws {
        let memo = try await MemoStore.shared.add(title: title, priority: priority)

        let intent = AddMemoIntent()
        intent.title = title
        intent.priority = priority

        Task {
            try await IntentDonationManager.shared.donate(
                intent: intent,
                result: .result(value: memo)
            )
        }
    }
}
