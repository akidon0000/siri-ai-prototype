import AppIntents

extension MemoEntity: SnippetRepresentableEntity {
    static var snippet: some EntitySnippetContent<MemoEntity> {
        CardSnippet(supportedFamilies: [.standard]) { memo, _ in
            MemoSnippetView(memo: memo)
        }
    }
}
