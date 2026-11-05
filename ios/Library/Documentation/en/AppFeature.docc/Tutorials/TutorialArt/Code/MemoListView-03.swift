import AppIntents
import SwiftUI

struct MemoListView: View {
    let memos: [MemoEntity]
    @State private var selection = Set<MemoEntity.ID>()

    var body: some View {
        List(memos, selection: $selection) { memo in
            Text(memo.title)
        }
        // Tell Siri which memos are selected. They become the "this" in "Mark this done"
        .appEntityIdentifier(forSelectionType: MemoEntity.ID.self) { id in
            EntityIdentifier(for: MemoEntity.self, identifier: id)
        }
    }
}
