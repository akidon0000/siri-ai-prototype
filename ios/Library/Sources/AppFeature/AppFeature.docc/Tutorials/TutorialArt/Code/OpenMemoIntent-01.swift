import AppIntents

// .system.open: 検索結果のメモをタップしたときなどに、アプリでそのメモを開く
@AppIntent(schema: .system.open)
struct OpenMemoIntent: OpenIntent {
    var target: MemoEntity
}
