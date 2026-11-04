import AppIntents

@AppIntent(schema: .system.open)
struct OpenMemoIntent: OpenIntent {
    var target: MemoEntity
}
