import AppIntents

// Journalingドメインのスキーマ。このままではShortcutsアプリでしか使えない
// .tool を足すとSiriのツールにもなる。この書き方ができるのはShortcuts専用ドメインのスキーマだけ
@AppIntent(.tool, schema: .journal.createEntry)
struct CreateJournalEntryIntent {
    // スキーマのプロパティは @Parameter を書かずに宣言する
    var message: AttributedString
    var title: String?
    var location: GeoToolbox.PlaceDescriptor?
    var mediaItems: [IntentFile]
    var entryDate: Date?

    func perform() async throws -> some ReturnsValue<JournalEntryEntity> {
        .result(value: try await JournalStore.shared.add(message: message, title: title))
    }
}
