import AppIntents

// メモが共有されているかをSiriに伝える。共有メモの更新では確認が挟まる
extension MemoEntity: OwnershipProvidingEntity {
    var ownership: EntityOwnership {
        // 共有相手がいなければ、持ち主は分からないとして .unknown を返す
        sharedWith.isEmpty ? .unknown : .shared
    }
}
