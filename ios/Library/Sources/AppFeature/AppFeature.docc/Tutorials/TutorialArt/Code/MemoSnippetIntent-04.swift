import AppIntents
import SwiftUI

struct MemoSnippetIntent: SnippetIntent {
    static let title: LocalizedStringResource = "メモのスニペット"

    @Parameter var memo: MemoEntity

    init() {}

    init(memo: MemoEntity) {
        self.memo = memo
    }

    func perform() async throws -> some IntentResult & ShowsSnippetView {
        let latest = try await MemoStore.shared.memo(for: memo.id)
        return .result(view: MemoSnippetView(memo: latest))
    }
}
