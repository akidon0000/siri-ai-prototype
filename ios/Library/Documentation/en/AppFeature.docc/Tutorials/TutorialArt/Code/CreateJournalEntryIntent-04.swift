import AppIntents

// A Journaling domain schema. As is, it can be used only in the Shortcuts app
// Adding .tool makes it a Siri tool too. Only schemas from Shortcuts-only domains allow this
@AppIntent(.tool, schema: .journal.createEntry)
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
