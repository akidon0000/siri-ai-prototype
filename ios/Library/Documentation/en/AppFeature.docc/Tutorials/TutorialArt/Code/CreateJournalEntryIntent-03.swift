import AppIntents

// A Journaling domain schema. As is, it can be used only in the Shortcuts app
@AppIntent(schema: .journal.createEntry)
struct CreateJournalEntryIntent {
    // Declare the schema's properties without @Parameter
    var message: AttributedString
    var title: String?
    var location: GeoToolbox.PlaceDescriptor?
    var mediaItems: [IntentFile]
    var entryDate: Date?

    func perform() async throws -> some ReturnsValue<JournalEntryEntity> {
        .result(value: try await JournalStore.shared.add(message: message, title: title))
    }
}
