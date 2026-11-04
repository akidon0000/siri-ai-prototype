import AppIntents
import SwiftUI

struct MemoDetailView: View {
    let memo: MemoEntity

    var body: some View {
        Text(memo.title)
            .userActivity("com.akidon0000.SiriAIPrototype.memo") { activity in
                activity.title = memo.title
                activity.appEntityIdentifier = EntityIdentifier(for: MemoEntity.self, identifier: memo.id)
            }
    }
}
