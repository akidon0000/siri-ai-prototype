import AppIntents

// .system.open: opens the memo in the app, for example when a memo in search results is tapped
@AppIntent(schema: .system.open)
struct OpenMemoIntent: OpenIntent {
    var target: MemoEntity
}
