import AppIntents

// パラメータに選択肢を出す。索引に入れていないEntityも、Siriはこの選択肢から見つけられる
// 使う側: @Parameter(title: "メモ", optionsProvider: PinnedMemosOptionsProvider()) var memo: MemoEntity
struct PinnedMemosOptionsProvider: DynamicOptionsProvider {
    func results() async throws -> [MemoEntity] {
        try await MemoStore.shared.pinnedMemos()
    }
}
