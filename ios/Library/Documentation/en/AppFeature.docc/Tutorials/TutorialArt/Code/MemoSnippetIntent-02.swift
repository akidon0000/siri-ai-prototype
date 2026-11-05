import AppIntents
import SwiftUI

// An intent that builds the snippet. After a button is used, the system calls perform() again
struct MemoSnippetIntent: SnippetIntent {
    static let title: LocalizedStringResource = "Memo Snippet"

    @Parameter var memo: MemoEntity
}
