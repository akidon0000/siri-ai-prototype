import AppIntents
import SwiftUI

struct MemoListView: View {
    let memos: [MemoEntity]
    @State private var selection = Set<MemoEntity.ID>()
}
