import AppIntents
import CoreSpotlight

extension MemoEntity {
    // 索引に入れる属性。タイトルなどの既定の属性に、足したい値を加える
    var attributeSet: CSSearchableItemAttributeSet {
        let attributes = CSSearchableItemAttributeSet()
        attributes.keywords = Array(tags)
        return attributes
    }
}
