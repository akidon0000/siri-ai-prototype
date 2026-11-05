import AppIntents

// Search conditions Siri builds directly from the request. It creates the value without a query
@AppEntity(.generable)
struct MemoSearch: TransientAppEntity {
    static let typeDisplayRepresentation: TypeDisplayRepresentation = "Memo Search"
}
