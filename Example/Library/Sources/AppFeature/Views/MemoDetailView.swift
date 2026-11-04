import AppIntents
import SwiftUI

struct MemoDetailView: View {
    let id: UUID
    @State private var memo: MemoEntity?

    var body: some View {
        Group {
            if let memo {
                Form {
                    Section("タイトル") { Text(memo.title) }
                    Section("状態") { Text(memo.isCompleted ? "完了" : "未完了") }
                    Section("リスト") { Text(memo.list.name) }
                }
                .navigationTitle(memo.title)
                // 表示中のメモをNSUserActivityに載せ、「これ」がどのメモかをSiriに伝える
                .userActivity("com.akidon0000.SiriAIPrototype.memo") { activity in
                    activity.title = memo.title
                    activity.appEntityIdentifier = EntityIdentifier(for: MemoEntity.self, identifier: memo.id)
                }
            } else {
                ContentUnavailableView("メモが見つかりません", systemImage: "questionmark.circle")
            }
        }
        .task(id: id) { memo = try? await MemoStore.shared.memo(for: id) }
    }
}
