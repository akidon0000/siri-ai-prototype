import AppIntents
import SwiftUI

struct MemoListView: View {
    let memos: [MemoEntity]
    @State private var selection = Set<MemoEntity.ID>()

    var body: some View {
        List(memos, selection: $selection) { memo in
            Text(memo.title)
        }
    }
}
