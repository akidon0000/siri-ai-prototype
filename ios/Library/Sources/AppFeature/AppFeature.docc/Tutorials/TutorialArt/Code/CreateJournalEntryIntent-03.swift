import AppIntents

// Journalingドメインのスキーマ。このままではShortcutsアプリでしか使えない
@AppIntent(schema: .journal.createEntry)
struct CreateJournalEntryIntent {
    // スキーマのプロパティは @Parameter を書かずに宣言する
    var message: AttributedString
    var title: String?
    // スキーマが定める残りのプロパティ
    var location: GeoToolbox.PlaceDescriptor?
    var mediaItems: [IntentFile]
    var entryDate: Date?

    // 作った日記のEntityを返す
    func perform() async throws -> some ReturnsValue<JournalEntryEntity> {
        .result(value: try await JournalStore.shared.add(message: message, title: title))
    }
}
