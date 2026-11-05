import AppIntents

// Search conditions Siri builds directly from the request. It creates the value without a query
// .generable is an AppEntityTraits value. [.generable] works too. No variables or computed values
// For a transient entity that follows a schema, write @AppEntity(.generable, schema: ...)
@AppEntity(.generable)
struct MemoSearch: TransientAppEntity {
    static let typeDisplayRepresentation: TypeDisplayRepresentation = "Memo Search"

    // Siri reads these descriptions to decide which part of the request goes into which property
    @Property(title: "Keyword", description: "A word contained in the memo's title")
    var keyword: String

    // Only value types, AppEnums, generable entities and arrays of these are allowed
    @Property(title: "Priorities", description: "Priorities to filter by. Empty means all priorities")
    var priorities: [MemoPriority]

    var displayRepresentation: DisplayRepresentation {
        "Search for '\(keyword)'"
    }

    // Used when the system creates the value
    init() {}
}
