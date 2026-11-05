import AppIntents

// Defines the card Siri AI uses to show a memo
extension MemoEntity: SnippetRepresentableEntity {
    static var snippet: some EntitySnippetContent<MemoEntity> {
        // Reuse chapter 4's MemoSnippetView as the content
        CardSnippet(supportedFamilies: [.standard]) { memo, _ in
            MemoSnippetView(memo: memo)
        }
    }
}
