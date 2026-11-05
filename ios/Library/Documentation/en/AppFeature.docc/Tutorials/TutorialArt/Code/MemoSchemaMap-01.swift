import AppIntents

// Following a schema from a Siri-enabled domain (Reminders, Mail, Photos, ...) exposes it to Siri
@AppIntent(schema: .reminders.createReminder)
struct CreateMemoIntent { /* … */ }

// Schemas from Shortcuts-only domains (Journaling, Books, ...) aren't exposed to Siri
@AppIntent(schema: .journal.createEntry)
struct CreateJournalEntryIntent { /* … */ }
