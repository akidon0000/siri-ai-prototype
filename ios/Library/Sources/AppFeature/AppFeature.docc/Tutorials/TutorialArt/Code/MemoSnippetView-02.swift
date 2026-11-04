import SwiftUI

// Siriの結果に出すビュー。アプリの画面より小さく、要点だけを見せる
struct MemoSnippetView: View {
    let memo: MemoEntity

    var body: some View {
        Label(memo.title, systemImage: memo.isDone ? "checkmark.circle.fill" : "circle")
    }
}
