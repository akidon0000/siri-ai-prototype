import AppIntents
import SwiftUI

struct MemoDetailView: View {
    let memo: MemoEntity

    var body: some View {
        Text(memo.title)
            // 表示中のメモをNSUserActivityに載せ、「これ」がどのメモかをSiriに伝える
            // 無いと、画面を開いたまま「これを完了にして」と言っても、Siriは「どのメモですか」と聞き返す
            // 有効なのは、この画面が表示されている間だけ。閉じれば「これ」の対象からも外れる
            // Siriが使うのは appEntityIdentifier のID。種類の名前（末尾の .memo）は自分で決める識別子で、動作には関係しない
            .userActivity("com.akidon0000.SiriAIPrototype.memo") { activity in
                activity.title = memo.title
                activity.appEntityIdentifier = EntityIdentifier(for: MemoEntity.self, identifier: memo.id)
            }
    }
}
