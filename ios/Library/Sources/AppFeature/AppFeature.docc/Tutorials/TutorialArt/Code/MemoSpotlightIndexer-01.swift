import AppIntents
import CoreSpotlight

// Spotlightのセマンティック索引に、メモを入れたり消したりする
struct MemoSpotlightIndexer {
    private let searchIndex = CSSearchableIndex(name: "memos")
}
