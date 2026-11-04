import AppIntents

// メモが共有されているかをSiriに伝える。共有メモの更新では確認が挟まる
extension MemoEntity: OwnershipProvidingEntity {
    public var ownership: EntityOwnership {
        sharedWith.isEmpty ? .unknown : .shared
    }
}
