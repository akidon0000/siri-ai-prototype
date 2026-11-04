import Intents

class CompleteMemoIntentHandler: NSObject, CompleteMemoIntentHandling {
    func resolveMemo(for intent: CompleteMemoIntent,
                     with completion: @escaping (MemoResolutionResult) -> Void) {
        guard let memo = intent.memo else { return completion(.needsValue()) }
        completion(.success(with: memo))
    }
}
