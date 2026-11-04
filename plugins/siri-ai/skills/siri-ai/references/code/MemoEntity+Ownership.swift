import AppIntents

// メモが共有されているかをSiriに伝える。共有メモの更新では確認が挟まる
extension MemoEntity: OwnershipProvidingEntity {
    var ownership: EntityOwnership {
        sharedWith.isEmpty ? .unknown : .shared
    }
}
