import SwiftUI

struct MemoSnippetView: View {
    let memo: MemoEntity

    var body: some View {
        Label(memo.title, systemImage: memo.isDone ? "checkmark.circle.fill" : "circle")
    }
}
