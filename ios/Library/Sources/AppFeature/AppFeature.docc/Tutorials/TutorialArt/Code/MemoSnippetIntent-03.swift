import AppIntents
import SwiftUI

struct MemoSnippetIntent: SnippetIntent {
    static let title: LocalizedStringResource = "メモのスニペット"

    @Parameter var memo: MemoEntity

    init() {}

    init(memo: MemoEntity) {
        self.memo = memo
    }
}
