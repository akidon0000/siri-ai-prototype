import AppIntents

@MainActor
final class MemoListModel {
    func addMemoFromUI(title: String, list: MemoListEntity) async throws {
        let memo = try await MemoStore.shared.add(title: title, list: list, dueDate: nil)

        // Donate only actions people actually took. Donating more makes the system ignore this app's donations
        // Fill in as many parameters as you can, but leave out values not meant for predictions (bodies etc.)
        // Build the intent for the same action. The system doesn't run it; it records it and learns from it
        var intent = CreateMemoIntent()
        intent.title = title
        intent.list = list
        try await IntentDonationManager.shared.donate(intent: intent, result: .result(value: memo))
    }

    func setPriorityFromUI(_ memo: MemoEntity, to priority: MemoPriority) async throws {
        try await MemoStore.shared.setPriority(priority, for: memo.id)

        // Tool intents that don't follow a schema can be donated the same way
        var intent = SetMemoPriorityIntent()
        intent.memo = memo
        intent.priority = priority
        try await IntentDonationManager.shared.donate(intent: intent)
    }
}
