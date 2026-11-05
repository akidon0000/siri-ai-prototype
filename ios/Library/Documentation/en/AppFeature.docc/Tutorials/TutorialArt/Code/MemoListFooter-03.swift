import AppIntents
import SwiftUI

struct MemoListFooter: View {
    var body: some View {
        VStack {
            // Shows the phrase registered for AddMemoIntent as a "Try saying to Siri: …" hint
            SiriTipView(intent: AddMemoIntent())
            // Tapping it opens this app's list of shortcuts in the Shortcuts app
            ShortcutsLink()
        }
    }
}
