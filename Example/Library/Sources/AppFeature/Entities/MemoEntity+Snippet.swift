#if SIRI_AI_PREVIEW
import AppIntents

// Siri AIがメモを見せるときのカードを決める（iOS 27.3 beta）
@available(iOS 27.3, *)
extension MemoEntity: SnippetRepresentableEntity {
    public static var snippet: some EntitySnippetContent<MemoEntity> {
        CardSnippet(supportedFamilies: [.standard]) { memo, _ in
            MemoSnippetView(memo: memo)
        }
    }
}
#endif
