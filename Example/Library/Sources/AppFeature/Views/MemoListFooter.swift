import AppIntents
import SwiftUI

struct MemoListFooter: View {
    var body: some View {
        VStack(spacing: 12) {
            // AddMemoIntent に登録したフレーズを「Siriに〜と話しかけてみてください」と表示する
            SiriTipView(intent: AddMemoIntent())
            // タップすると、Shortcutsアプリでこのアプリのショートカット一覧が開く
            ShortcutsLink()
        }
    }
}
