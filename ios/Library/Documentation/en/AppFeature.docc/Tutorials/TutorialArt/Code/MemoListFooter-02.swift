import AppIntents
import SwiftUI

struct MemoListFooter: View {
    var body: some View {
        // Shows the phrase registered for AddMemoIntent as a "Try saying to Siri: …" hint
        SiriTipView(intent: AddMemoIntent())
    }
}
