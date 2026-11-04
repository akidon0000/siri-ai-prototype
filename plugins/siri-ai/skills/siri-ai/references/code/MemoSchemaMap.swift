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

// Mailのように use-case group を持つドメインでは、組のスキーマを全て採用する
// 一部だけを採用すると、欠けているスキーマごとにビルド警告が出る

// Xcodeで reminders_ と入力して補完からスキーマを選ぶと、必要なプロパティが全て入ったテンプレートが展開される
