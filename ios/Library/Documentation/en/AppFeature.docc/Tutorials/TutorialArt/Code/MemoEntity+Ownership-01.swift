import AppIntents

// Tell Siri whether the memo is shared. Updating a shared memo then asks for confirmation
extension MemoEntity: OwnershipProvidingEntity {
    var ownership: EntityOwnership {
        sharedWith.isEmpty ? .unknown : .shared
    }
}
