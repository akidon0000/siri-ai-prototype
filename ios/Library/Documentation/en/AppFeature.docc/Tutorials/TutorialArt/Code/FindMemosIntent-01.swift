import AppIntents

// A tool that finds memos by conditions. No schema covers it, so .tool exposes it to Siri
@AppIntent(.tool)
struct FindMemosIntent: AppIntent {
    static let title: LocalizedStringResource = "Find Memos"
}
