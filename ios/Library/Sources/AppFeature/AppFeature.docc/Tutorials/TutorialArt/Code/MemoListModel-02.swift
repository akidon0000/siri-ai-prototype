import AppIntents

@MainActor
final class MemoListModel {
    // 画面の「追加」ボタンから呼ぶ
    func addMemoFromUI(title: String, list: MemoListEntity) async throws {
        let memo = try await MemoStore.shared.add(title: title, list: list, dueDate: nil)
    }
}
