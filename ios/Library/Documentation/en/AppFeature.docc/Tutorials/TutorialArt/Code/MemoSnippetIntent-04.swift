import AppIntents
import SwiftUI

// An intent that builds the snippet. After a button is used, the system calls perform() again
struct MemoSnippetIntent: SnippetIntent {
    static let title: LocalizedStringResource = "Memo Snippet"

    @Parameter var memo: MemoEntity

    init() {}

    init(memo: MemoEntity) {
        self.memo = memo
    }

    func perform() async throws -> some IntentResult & ShowsSnippetView {
        // Read the latest state every time it's called
        let latest = try await MemoStore.shared.memo(for: memo.id)
        return .result(view: MemoSnippetView(memo: latest))
    }
}
