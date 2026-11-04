import AppIntents
import SwiftUI

// スニペットの表示を作るintent。ボタンで操作したあと、システムがもう一度 perform() を呼ぶ
struct MemoSnippetIntent: SnippetIntent {
    static let title: LocalizedStringResource = "メモのスニペット"

    // 表示するメモ
    @Parameter var memo: MemoEntity

    init() {}

    init(memo: MemoEntity) {
        self.memo = memo
    }
}
