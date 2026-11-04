import AppIntents

// Siriで使えるドメイン（Reminders・Mail・Photosなど）のスキーマに合わせると、Siriにも公開される
@AppIntent(schema: .reminders.createReminder)
struct CreateMemoIntent { /* … */ }

// Shortcutsアプリでだけ使えるドメイン（Journaling・Booksなど）のスキーマは、Siriには公開されない
@AppIntent(schema: .journal.createEntry)
struct CreateJournalEntryIntent { /* … */ }
