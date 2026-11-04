import AppIntents

// Siriで使えるドメイン（Reminders・Mail・Photosなど）のスキーマに合わせると、Siriにも公開される
@AppIntent(schema: .reminders.createReminder)
struct CreateMemoIntent { /* … */ }

// Shortcutsアプリでだけ使えるドメイン（Journaling・Booksなど）のスキーマは、Siriには公開されない
@AppIntent(schema: .journal.createEntry)
struct CreateJournalEntryIntent { /* … */ }

// Memoは完了・未完了を持つので、NotesではなくRemindersのスキーマに合わせる
@AppEntity(schema: .reminders.reminder)
struct MemoEntity { /* … */ }
// 更新と削除も .reminders.updateReminder と .reminders.deleteReminders に合わせる
