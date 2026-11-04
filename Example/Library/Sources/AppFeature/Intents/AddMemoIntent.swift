import AppIntents

// App Shortcuts はアプリのターゲットに置くので、そこから参照できるように public にする
public struct AddMemoIntent: AppIntent {
    public static let title: LocalizedStringResource = "メモを追加"
    // Shortcutsアプリでの説明。Siriもこれを読んでintentの役割を知る
    public static let description = IntentDescription("新しいメモを1件追加する。")

    @Parameter(title: "タイトル")
    public var title: String

    @Parameter(title: "優先度", default: .normal)
    public var priority: MemoPriority

    public init() {}

    public static var parameterSummary: some ParameterSummary {
        Summary("\(\.$title)を優先度\(\.$priority)で追加")
    }

    public func perform() async throws -> some IntentResult & ReturnsValue<MemoEntity> {
        let memo = try await MemoStore.shared.add(title: title, priority: priority)
        // 作ったメモを返すと、ショートカットの次のアクションに渡せる
        return .result(value: memo)
    }
}
