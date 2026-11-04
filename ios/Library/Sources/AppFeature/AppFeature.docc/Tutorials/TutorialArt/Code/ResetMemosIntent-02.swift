#if DEBUG
import AppIntents

struct ResetMemosIntent: AppIntent {
    static let title: LocalizedStringResource = "メモを初期データに戻す"
    static let isDiscoverable = false

    func perform() async throws -> some IntentResult {
        try await MemoStore.shared.resetToSeedData()
        return .result()
    }
}
#endif
