import AppIntents
import UserNotifications

enum MemoNotification {
    static func makeDueNotification(for memo: MemoEntity) -> UNMutableNotificationContent {
        let content = UNMutableNotificationContent()
        content.title = memo.title
        // 通知にメモを結び付ける。通知を見ながら「これを完了にして」と言える
        content.appEntityIdentifiers = [
            EntityIdentifier(for: MemoEntity.self, identifier: memo.id)
        ]
        return content
    }

    /// 期限のあるメモに、期限の時刻の通知を予約する。通知を許可していなければ何もしない。
    static func scheduleDueNotification(for memo: MemoEntity) async {
        guard let dueDate = memo.dueDate else { return }
        let center = UNUserNotificationCenter.current()
        guard await center.notificationSettings().authorizationStatus == .authorized else { return }
        let trigger = UNCalendarNotificationTrigger(dateMatching: dueDate, repeats: false)
        let request = UNNotificationRequest(
            identifier: memo.id.uuidString,
            content: makeDueNotification(for: memo),
            trigger: trigger
        )
        try? await center.add(request)
    }
}
