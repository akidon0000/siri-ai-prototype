import AppIntents

// 日本でサイドボタンを長押ししたときに呼ばれる。entitlementの申請が要る
@AppIntent(schema: .assistant.activate)
struct ActivateConversationIntent {
    // アプリを前面に出してから実行する
    static let supportedModes: IntentModes = .foreground
}
