import AppIntents
import SwiftUI

// Siri AIがメモを見せるときのカードを決める
extension MemoEntity: SnippetRepresentableEntity {
    static var snippet: some EntitySnippetContent<MemoEntity> {
        // メモを結果として返す操作（探して見つかったメモなど）の応答に、このカードが出る
        // 中身には第4章の MemoSnippetView をそのまま使う
        CardSnippet(supportedFamilies: [.standard]) { memo, _ in
            MemoSnippetView(memo: memo)
        }
    }
}
