import AppIntents
import SwiftUI

// 画面上のどのMemoEntityが「今見えているか」をSiriに伝える。
// これで「3番目を完了にして」のような指示語がそのまま通じるようになる。
struct MemoListView: View {
    let memos: [MemoEntity]
    @State private var selection = Set<MemoEntity.ID>()

    var body: some View {
        List(memos, selection: $selection) { memo in
            Text(memo.title)
        }
        // 一覧表示: 行ごとにアノテーションを付けるのではなく、
        // システムが必要になった時点でidから引けるようにする
        .appEntityIdentifier(forSelectionType: MemoEntity.ID.self) { id in
            EntityIdentifier(for: MemoEntity.self, identifier: id)
        }
    }
}

// 画面全体が1件のMemoに専念している場合はNSUserActivityを使う
struct MemoDetailView: View {
    let memo: MemoEntity

    var body: some View {
        Text(memo.title)
            .userActivity("com.akidon0000.siri-ai-prototype.memoDetail", isActive: true) { activity in
                activity.title = memo.title
                activity.appEntityIdentifier = EntityIdentifier(
                    for: MemoEntity.self,
                    identifier: memo.id
                )
            }
    }
}
