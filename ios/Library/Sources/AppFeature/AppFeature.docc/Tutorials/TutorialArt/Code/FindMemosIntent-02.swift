import AppIntents

// 条件でメモを探すツール。スキーマに無い操作なので .tool でSiriに公開する
@AppIntent(.tool)
struct FindMemosIntent: AppIntent {
    static let title: LocalizedStringResource = "メモを探す"
    // Siriのモデルはこの説明を読んで、このツールをいつ使うかを決める
    static let description = IntentDescription("キーワードと優先度に合う未完了のメモを探す。")

    // MemoSearch はGenerableなので、Siriが依頼の文から値を組み立てて渡す
    @Parameter(title: "検索条件", description: "探したいメモの条件")
    var search: MemoSearch
}
