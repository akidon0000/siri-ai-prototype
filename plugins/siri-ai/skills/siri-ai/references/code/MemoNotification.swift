import AppIntents
import UserNotifications

func makeDueNotification(for memo: MemoEntity) -> UNMutableNotificationContent {
    let content = UNMutableNotificationContent()
    content.title = memo.title
    // 通知にメモを結び付ける。通知を見ながら「これを完了にして」と言える
    content.appEntityIdentifiers = [
        EntityIdentifier(for: MemoEntity.self, identifier: memo.id)
    ]
    return content
}
