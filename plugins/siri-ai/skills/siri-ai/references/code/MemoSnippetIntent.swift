import AppIntents
import SwiftUI

// スニペットの表示を作るintent。ボタンで操作したあと、システムがもう一度 perform() を呼ぶ
struct MemoSnippetIntent: SnippetIntent {
    static let title: LocalizedStringResource = "メモのスニペット"

    @Parameter var memo: MemoEntity

    init() {}

    init(memo: MemoEntity) {
        self.memo = memo
    }

    func perform() async throws -> some IntentResult & ShowsSnippetView {
        // 呼ばれるたびに最新の状態を読み直して表示する
        let latest = try await MemoStore.shared.memo(for: memo.id)
        return .result(view: MemoSnippetView(memo: latest))
    }
}
