import AppIntents
import SwiftUI

struct MemoDetailView: View {
    let memo: MemoEntity

    var body: some View {
        Text(memo.title)
    }
}
