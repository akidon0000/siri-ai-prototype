import SwiftUI

// A view shown in Siri's results. Smaller than the app's screens, showing only the essentials
struct MemoSnippetView: View {
    let memo: MemoEntity

    var body: some View {
        Label(memo.title, systemImage: memo.isDone ? "checkmark.circle.fill" : "circle")
    }
}
