import AppIntents

// 日本でサイドボタンを長押ししたときに呼ばれる。entitlementの申請が要る
@AppIntent(schema: .assistant.activate)
struct ActivateConversationIntent {
    // アプリを前面に出してから実行する
    static let supportedModes: IntentModes = .foreground

    func perform() async throws -> some IntentResult {
        // アプリ内の音声アシスタントで聞き取りを始める
        await ConversationController.shared.startListening()
        return .result()
    }
}
