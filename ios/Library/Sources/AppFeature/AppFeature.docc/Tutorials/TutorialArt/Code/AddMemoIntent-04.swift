import AppIntents

struct AddMemoIntent: AppIntent {
    static let title: LocalizedStringResource = "メモを追加"
    static let description = IntentDescription("新しいメモを1件追加する。")

    @Parameter(title: "タイトル")
    var title: String

    @Parameter(title: "優先度", default: .normal)
    var priority: MemoPriority
}
