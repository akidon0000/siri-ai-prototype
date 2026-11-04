import AppIntents

@AppIntent(.tool)
struct FindMemosIntent: AppIntent {
    static let title: LocalizedStringResource = "メモを探す"
}
