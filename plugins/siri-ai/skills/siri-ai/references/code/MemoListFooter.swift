import AppIntents
import SwiftUI

struct MemoListFooter: View {
    var body: some View {
        VStack {
            // AddMemoIntent に登録したフレーズを「Siriに〜と話しかけてみてください」と表示する
            SiriTipView(intent: AddMemoIntent())
            // タップすると、Shortcutsアプリでこのアプリのショートカット一覧が開く
            ShortcutsLink()
        }
    }
}
