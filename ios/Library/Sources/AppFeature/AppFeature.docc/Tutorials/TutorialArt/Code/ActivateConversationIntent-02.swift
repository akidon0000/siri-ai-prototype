import AppIntents

@AppIntent(schema: .assistant.activate)
struct ActivateConversationIntent {
    static let supportedModes: IntentModes = .foreground

    func perform() async throws -> some IntentResult {
        await ConversationController.shared.startListening()
        return .result()
    }
}
