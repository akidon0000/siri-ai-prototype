import AppIntents

struct AddMemoIntent: AppIntent {
    // ShortcutsアプリやSpotlightに表示される操作名
    static let title: LocalizedStringResource = "メモを追加"
    // Shortcutsアプリでの説明。Siriもこれを読んでintentの役割を知る
    static let description = IntentDescription("新しいメモを1件追加する。")
}
