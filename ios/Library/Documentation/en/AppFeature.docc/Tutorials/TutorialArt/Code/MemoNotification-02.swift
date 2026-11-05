import AppIntents
import UserNotifications

func makeDueNotification(for memo: MemoEntity) -> UNMutableNotificationContent {
    let content = UNMutableNotificationContent()
    content.title = memo.title
    // Link the memo to the notification, so people can say "Mark this done" while looking at it
    content.appEntityIdentifiers = [
        EntityIdentifier(for: MemoEntity.self, identifier: memo.id)
    ]
    return content
}
