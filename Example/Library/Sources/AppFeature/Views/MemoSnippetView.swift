import AppIntents
import SwiftUI

// Siriの結果に出すビュー。アプリの画面より小さく、要点だけを見せる
struct MemoSnippetView: View {
    let memo: MemoEntity

    var body: some View {
        HStack {
            // 仮の画像。メモごとの画像を持たせるときは、ここを差し替える
            Image(systemName: "photo")
                .font(.title)
                .foregroundStyle(.secondary)
                .frame(width: 56, height: 56)
                .background(.quaternary, in: RoundedRectangle(cornerRadius: 12))
            Label(memo.title, systemImage: memo.isCompleted ? "checkmark.circle.fill" : "circle")
            Spacer()
            // ボタンにintentを渡すと、押したときにアプリを開かずにそのintentが実行される
            Button("完了", intent: CompleteMemoIntent(memo: memo))
                .disabled(memo.isCompleted)
        }
        .padding()
    }
}
