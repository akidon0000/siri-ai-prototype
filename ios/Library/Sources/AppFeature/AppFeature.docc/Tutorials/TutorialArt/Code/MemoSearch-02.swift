import AppIntents

@AppEntity(.generable)
struct MemoSearch: TransientAppEntity {
    static let typeDisplayRepresentation: TypeDisplayRepresentation = "メモ検索"

    @Property(title: "キーワード", description: "メモのタイトルに含まれる語")
    var keyword: String

    @Property(title: "優先度", description: "絞り込む優先度。空なら全ての優先度")
    var priorities: [MemoPriority]
}
