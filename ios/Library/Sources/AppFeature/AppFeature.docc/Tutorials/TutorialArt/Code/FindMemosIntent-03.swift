import AppIntents

@AppIntent(.tool)
struct FindMemosIntent: AppIntent {
    static let title: LocalizedStringResource = "メモを探す"
    static let description = IntentDescription("キーワードと優先度に合う未完了のメモを探す。")

    @Parameter(title: "検索条件", description: "探したいメモの条件")
    var search: MemoSearch

    func perform() async throws -> some ReturnsValue<[MemoEntity]> {
        .result(value: try await MemoStore.shared.memos(matching: search))
    }
}
