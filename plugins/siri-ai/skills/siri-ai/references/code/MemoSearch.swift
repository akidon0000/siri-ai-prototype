import AppIntents

// Siriが依頼の文から直接組み立てる検索条件。クエリで探さずに値を作れる
// .generable は AppEntityTraits の値。[.generable] と配列でも書ける。変数や計算した値は渡せない
// スキーマに合わせた一時的なEntityなら @AppEntity(.generable, schema: ...) と書く
@AppEntity(.generable)
struct MemoSearch: TransientAppEntity {
    static let typeDisplayRepresentation: TypeDisplayRepresentation = "メモ検索"

    // Siriはこの description を見て、依頼のどの部分をどのプロパティに入れるかを決める
    @Property(title: "キーワード", description: "メモのタイトルに含まれる語")
    var keyword: String

    // 使える型は値型・AppEnum・GenerableなEntityと、それらの配列だけ
    @Property(title: "優先度", description: "絞り込む優先度。空なら全ての優先度")
    var priorities: [MemoPriority]

    var displayRepresentation: DisplayRepresentation {
        "「\(keyword)」の検索"
    }

    // システムが値を作るときに使う
    init() {}
}
