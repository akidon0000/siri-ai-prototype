import AppIntents

// Siriで使えるPrimary domain（Swiftでの書き方）:
//   .audio  https://developer.apple.com/documentation/appintents/app-schema-domain-audio
//   .calendar  https://developer.apple.com/documentation/appintents/app-schema-domain-calendar
//   .camera  https://developer.apple.com/documentation/appintents/app-schema-domain-camera
//   .clock  https://developer.apple.com/documentation/appintents/app-schema-domain-clock
//   .mail  https://developer.apple.com/documentation/appintents/app-schema-domain-mail
//   .maps  https://developer.apple.com/documentation/appintents/app-schema-domain-maps
//   .messages  https://developer.apple.com/documentation/appintents/app-schema-domain-messages
//   .notes  https://developer.apple.com/documentation/appintents/app-schema-domain-notes
//   .phone  https://developer.apple.com/documentation/appintents/app-schema-domain-phone
//   .photos  https://developer.apple.com/documentation/appintents/app-schema-domain-photos
//   .reminders  https://developer.apple.com/documentation/appintents/app-schema-domain-reminders
//   .system  https://developer.apple.com/documentation/appintents/app-schema-domain-system-and-in-app-search
//   Video（SDK 27.1に無い）  https://developer.apple.com/documentation/appintents/app-schema-domain-video
// これらのスキーマに合わせると、Siriにも公開される
@AppIntent(schema: .reminders.createReminder)
struct CreateMemoIntent { /* … */ }

// Shortcutsアプリでだけ使えるドメイン:
//   .books  https://developer.apple.com/documentation/appintents/app-schema-domain-books
//   .browser  https://developer.apple.com/documentation/appintents/app-schema-domain-browser
//   .files  https://developer.apple.com/documentation/appintents/app-schema-domain-files
//   .journal  https://developer.apple.com/documentation/appintents/app-schema-domain-journaling
//   .presentation  https://developer.apple.com/documentation/appintents/app-schema-domain-presentation
//   .reader  https://developer.apple.com/documentation/appintents/app-schema-domain-reader
//   .spreadsheet  https://developer.apple.com/documentation/appintents/app-schema-domain-spreadsheet
//   .whiteboard  https://developer.apple.com/documentation/appintents/app-schema-domain-whiteboard
//   .wordProcessor  https://developer.apple.com/documentation/appintents/app-schema-domain-word-processor
// これらのスキーマは、Siriには公開されない
@AppIntent(schema: .journal.createEntry)
struct CreateJournalEntryIntent { /* … */ }
