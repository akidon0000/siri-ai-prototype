import AppIntents

// メモが共有されているかをSiriに伝える
// 伝えないと、Siriは全てのメモを「自分だけのもの」とみなし、確認なしで書き換えることがある
// .shared を返すと、家族と共有中のメモを「完了にして」と言われたときに、実行前に確認が挟まる
extension MemoEntity: OwnershipProvidingEntity {
    var ownership: EntityOwnership {
        sharedWith.isEmpty ? .unknown : .shared
    }
}
