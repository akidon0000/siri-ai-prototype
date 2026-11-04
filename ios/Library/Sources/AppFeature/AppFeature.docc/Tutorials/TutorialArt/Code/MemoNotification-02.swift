import AppIntents
import UserNotifications

func makeDueNotification(for memo: MemoEntity) -> UNMutableNotificationContent {
    let content = UNMutableNotificationContent()
    content.title = memo.title
    content.appEntityIdentifiers = [
        EntityIdentifier(for: MemoEntity.self, identifier: memo.id)
    ]
    return content
}
