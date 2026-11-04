import AppIntents
import SwiftUI

struct MemoListFooter: View {
    var body: some View {
        SiriTipView(intent: AddMemoIntent())
    }
}
