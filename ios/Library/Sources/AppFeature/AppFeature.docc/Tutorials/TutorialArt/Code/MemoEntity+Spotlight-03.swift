import AppIntents
import CoreSpotlight

extension MemoEntity {
    var attributeSet: CSSearchableItemAttributeSet {
        let attributes = CSSearchableItemAttributeSet()
        attributes.keywords = Array(tags)
        return attributes
    }
}
