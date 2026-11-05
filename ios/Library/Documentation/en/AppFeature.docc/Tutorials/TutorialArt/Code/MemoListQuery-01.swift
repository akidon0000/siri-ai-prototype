import AppIntents

// There are few lists, so return them all instead of putting them in the Spotlight index
// With EnumerableEntityQuery, Siri can find a list among all of these
struct MemoListQuery: EnumerableEntityQuery {
    func allEntities() async throws -> [MemoListEntity] {
        try await MemoStore.shared.allLists()
    }
}
