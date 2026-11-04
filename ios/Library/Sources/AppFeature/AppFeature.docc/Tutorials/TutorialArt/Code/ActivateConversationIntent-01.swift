import AppIntents

// 日本でサイドボタンを長押ししたときに呼ばれる。entitlementの申請が要る
@AppIntent(schema: .assistant.activate)
struct ActivateConversationIntent {
    static let supportedModes: IntentModes = .foreground
}
