import AppIntents

// Search conditions Siri builds directly from the request. It creates the value without a query
// .generable is an AppEntityTraits value. [.generable] works too. No variables or computed values
// For a transient entity that follows a schema, write @AppEntity(.generable, schema: ...)
@AppEntity(.generable)
struct MemoSearch: TransientAppEntity {
    static let typeDisplayRepresentation: TypeDisplayRepresentation = "Memo Search"
}
