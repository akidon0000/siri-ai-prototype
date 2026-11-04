import AppIntents

// Siriが依頼の文から直接組み立てる検索条件。クエリで探さずに値を作れる
@AppEntity(.generable)
struct MemoSearch: TransientAppEntity {
    static let typeDisplayRepresentation: TypeDisplayRepresentation = "メモ検索"
}
