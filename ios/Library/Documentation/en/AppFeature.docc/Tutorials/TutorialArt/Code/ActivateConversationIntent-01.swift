import AppIntents

// Called when the side button is pressed and held in Japan. You need to request the entitlement
@AppIntent(schema: .assistant.activate)
struct ActivateConversationIntent {
    static let supportedModes: IntentModes = .foreground
}
