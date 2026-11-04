import AppIntents

// @AppEntity(.generable) + TransientAppEntity:
// アプリに問い合わせず、Siriが発言内容からこの型の値を直接組み立てられるようにする。
// 「優先度高の買い物メモを探して」のような曖昧な発話を検索条件として渡せる。
@AppEntity(.generable)
struct MemoSearch: TransientAppEntity {
    static let typeDisplayRepresentation: TypeDisplayRepresentation = "メモ検索"

    @Property(title: "キーワード", description: "探したいメモの内容")
    var keyword: String

    @Property(title: "優先度", description: "絞り込みたい優先度")
    var priority: MemoPriority?

    var displayRepresentation: DisplayRepresentation {
        "\(keyword)の検索"
    }

    init() {}
}
