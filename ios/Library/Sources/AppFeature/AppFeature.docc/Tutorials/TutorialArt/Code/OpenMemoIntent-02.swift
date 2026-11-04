import AppIntents

@AppIntent(schema: .system.open)
struct OpenMemoIntent: OpenIntent {
    var target: MemoEntity

    func perform() async throws -> some IntentResult {
        await MemoNavigator.shared.show(target.id)
        return .result()
    }
}
