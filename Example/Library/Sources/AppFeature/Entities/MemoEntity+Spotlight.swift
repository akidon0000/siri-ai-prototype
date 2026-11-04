import AppIntents
import CoreSpotlight

// IndexedEntity にすると、Spotlightの索引に入れられる
extension MemoEntity: IndexedEntity {
    // 索引に入れる属性。タイトルなどの既定の属性に、足したい値を加える
    public var attributeSet: CSSearchableItemAttributeSet {
        let attributes = CSSearchableItemAttributeSet()
        attributes.keywords = Array(tags)
        return attributes
    }
}
