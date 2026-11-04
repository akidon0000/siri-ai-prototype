import AppIntents

// Siri AIがメモを見せるときのカードを決める
extension MemoEntity: SnippetRepresentableEntity {
    static var snippet: some EntitySnippetContent<MemoEntity> {
        // 中身には第4章の MemoSnippetView をそのまま使う
        CardSnippet(supportedFamilies: [.standard]) { memo, _ in
            MemoSnippetView(memo: memo)
        }
    }
}
