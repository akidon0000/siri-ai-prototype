import Intents

// A handler for a SiriKit custom intent. It conforms to the protocol Xcode generated
class CompleteMemoIntentHandler: NSObject, CompleteMemoIntentHandling {
    // resolve: check that the parameters are present. If not, ask back with needsValue
    func resolveMemo(for intent: CompleteMemoIntent,
                     with completion: @escaping (MemoResolutionResult) -> Void) {
        guard let memo = intent.memo else { return completion(.needsValue()) }
        completion(.success(with: memo))
    }

    // confirm: check that the intent is ready to run
    func confirm(intent: CompleteMemoIntent,
                 completion: @escaping (CompleteMemoIntentResponse) -> Void) {
        completion(CompleteMemoIntentResponse(code: .ready, userActivity: nil))
    }
}
