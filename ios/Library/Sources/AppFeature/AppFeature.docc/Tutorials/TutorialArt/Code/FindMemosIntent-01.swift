import AppIntents

// 条件でメモを探すツール。スキーマに無い操作なので .tool でSiriに公開する
@AppIntent(.tool)
struct FindMemosIntent: AppIntent {
    static let title: LocalizedStringResource = "メモを探す"
}
