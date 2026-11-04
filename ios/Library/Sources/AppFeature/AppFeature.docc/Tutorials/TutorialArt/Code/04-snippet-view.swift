import AppIntents
import SwiftUI

// dialogだけでなく、アプリ独自のビュー（スニペット）も一緒に返せる。
// Siriはそのままカード形式で表示する。
extension AddMemoIntent {
    func perform() async throws -> some IntentResult & ProvidesDialog & ShowsSnippetView {
        let memo = try await MemoStore.shared.add(title: title, priority: priority)
        return .result(
            dialog: IntentDialog(
                full: "「\(memo.title)」をメモに追加しました。",
                supporting: "追加しました"
            ),
            view: MemoSnippetView(memo: memo)
        )
    }
}

struct MemoSnippetView: View {
    let memo: MemoEntity

    var body: some View {
        HStack {
            Image(systemName: memo.isDone ? "checkmark.circle.fill" : "circle")
            Text(memo.title)
        }
        .padding()
    }
}
