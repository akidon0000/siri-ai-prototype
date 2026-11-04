import AppIntents

@AppIntent(schema: .assistant.activate)
struct ActivateConversationIntent {
    static let supportedModes: IntentModes = .foreground
}
