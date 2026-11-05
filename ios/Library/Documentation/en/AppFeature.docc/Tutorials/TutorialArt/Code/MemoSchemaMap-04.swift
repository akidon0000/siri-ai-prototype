import AppIntents

// Following a schema from a Siri-enabled domain (Reminders, Mail, Photos, ...) exposes it to Siri
@AppIntent(schema: .reminders.createReminder)
struct CreateMemoIntent { /* … */ }

// Schemas from Shortcuts-only domains (Journaling, Books, ...) aren't exposed to Siri
@AppIntent(schema: .journal.createEntry)
struct CreateJournalEntryIntent { /* … */ }

// A memo is done or not done, so follow the Reminders schemas rather than Notes
@AppEntity(schema: .reminders.reminder)
struct MemoEntity { /* … */ }
// Updating and deleting also follow .reminders.updateReminder and .reminders.deleteReminders

// In domains with use-case groups, such as Mail, adopt every schema in the group
// Adopting only some gives a build warning for each missing schema

// Type reminders_ in Xcode and pick a schema from completion to expand a template with every required property
