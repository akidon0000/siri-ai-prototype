import AppIntents
import CoreSpotlight

extension MemoEntity {
    // Attributes to index. Adds your own values to the default ones such as the title
    var attributeSet: CSSearchableItemAttributeSet {
        let attributes = CSSearchableItemAttributeSet()
        attributes.keywords = Array(tags)
        return attributes
    }
}
