// Generable なEntityと @AppIntent(.tool) は iOS 27.3 beta のAPI
#if SIRI_AI_PREVIEW
import AppIntents

// Siriが依頼の文から直接組み立てる検索条件。クエリで探さずに値を作れる
@available(iOS 27.3, *)
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

    init() {}
}

// 条件でメモを探すツール。スキーマに無い操作なので .tool でSiriに公開する
@available(iOS 27.3, *)
@AppIntent(.tool)
struct FindMemosIntent: AppIntent {
    static let title: LocalizedStringResource = "メモを探す"
    static let description = IntentDescription("キーワードと優先度に合う未完了のメモを探す。")

    @Parameter(title: "検索条件", description: "探したいメモの条件")
    var search: MemoSearch

    // 返したメモは、次に呼ぶツールのパラメータにそのまま渡される
    func perform() async throws -> some ReturnsValue<[MemoEntity]> {
        .result(value: try await MemoStore.shared.memos(matching: search.keyword, priorities: search.priorities))
    }
}
#endif
