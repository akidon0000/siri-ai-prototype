import AppIntents
import CoreSpotlight

extension MemoEntity {
    // 索引に入れる属性。タイトルなどの既定の属性に、足したい値を加える
    // ホーム画面を下にスワイプして「買い物」と打つと、タグに持つメモが候補に出る。選ぶと OpenMemoIntent でそのメモが開く
    var attributeSet: CSSearchableItemAttributeSet {
        let attributes = CSSearchableItemAttributeSet()
        attributes.keywords = Array(tags)
        return attributes
    }
}
