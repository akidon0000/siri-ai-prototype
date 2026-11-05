import SwiftUI

// A view shown in Siri's results. Smaller than the app's screens, showing only the essentials
struct MemoSnippetView: View {
    let memo: MemoEntity

    var body: some View {
        HStack {
            Label(memo.title, systemImage: memo.isDone ? "checkmark.circle.fill" : "circle")
            // A button with an intent runs that intent when pressed, without opening the app
            Button("Complete", intent: CompleteMemoIntent(memo: memo))
        }
    }
}
