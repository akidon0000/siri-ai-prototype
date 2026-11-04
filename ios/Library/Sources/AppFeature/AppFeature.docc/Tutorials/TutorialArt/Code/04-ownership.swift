import AppIntents

// OwnershipProvidingEntity: このメモが「自分だけのもの」か「共有されたもの」かをSiriに伝える。
// 共有物を更新するアクションは、Siriが実行前に確認を挟みやすくなる。
extension MemoEntity: OwnershipProvidingEntity {
    var ownership: EntityOwnership {
        sharedWithIDs.isEmpty ? .unknown : .shared
    }
}
