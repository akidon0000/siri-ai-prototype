import SwiftUI

struct MemoSnippetView: View {
    let memo: MemoEntity

    var body: some View {
        HStack {
            Label(memo.title, systemImage: memo.isDone ? "checkmark.circle.fill" : "circle")
            Button("完了", intent: CompleteMemoIntent(memo: memo))
        }
    }
}
