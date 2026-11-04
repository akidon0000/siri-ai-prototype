import AppIntents
import SwiftUI

struct MemoListView: View {
    let memos: [MemoEntity]
    @State private var selection = Set<MemoEntity.ID>()

    var body: some View {
        List(memos, selection: $selection) { memo in
            Text(memo.title)
        }
        // 選択中のメモをSiriに伝える。「これを完了にして」の「これ」になる
        .appEntityIdentifier(forSelectionType: MemoEntity.ID.self) { id in
            EntityIdentifier(for: MemoEntity.self, identifier: id)
        }
    }
}
