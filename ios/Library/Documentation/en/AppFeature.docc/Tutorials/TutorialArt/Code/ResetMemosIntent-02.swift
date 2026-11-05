// A test-only intent. Keep it out of release builds
#if DEBUG
import AppIntents

struct ResetMemosIntent: AppIntent {
    static let title: LocalizedStringResource = "Reset Memos to Seed Data"
    static let isDiscoverable = false

    func perform() async throws -> some IntentResult {
        try await MemoStore.shared.resetToSeedData()
        return .result()
    }
}
#endif
