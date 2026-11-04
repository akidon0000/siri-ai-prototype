import AppIntents
import SwiftUI

struct MemoListFooter: View {
    var body: some View {
        // AddMemoIntent に登録したフレーズを「Siriに〜と話しかけてみてください」と表示する
        SiriTipView(intent: AddMemoIntent())
    }
}
