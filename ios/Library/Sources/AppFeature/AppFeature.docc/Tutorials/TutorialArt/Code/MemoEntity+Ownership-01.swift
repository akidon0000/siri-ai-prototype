import AppIntents

extension MemoEntity: OwnershipProvidingEntity {
    var ownership: EntityOwnership {
        sharedWith.isEmpty ? .unknown : .shared
    }
}
