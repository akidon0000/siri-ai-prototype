import AppIntents
import SwiftUI

struct MemoListFooter: View {
    var body: some View {
        VStack {
            SiriTipView(intent: AddMemoIntent())
            ShortcutsLink()
        }
    }
}
