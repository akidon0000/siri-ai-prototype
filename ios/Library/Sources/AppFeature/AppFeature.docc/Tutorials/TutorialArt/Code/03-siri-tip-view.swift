import AppIntents
import SwiftUI

// アプリ内でも「この言い方で呼び出せます」をヒント表示できる。
struct MemoListFooter: View {
    var body: some View {
        SiriTipView(intent: AddMemoIntent())
            .padding()
    }
}
