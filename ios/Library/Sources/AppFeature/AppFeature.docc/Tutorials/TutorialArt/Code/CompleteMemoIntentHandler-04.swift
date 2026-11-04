import Intents

class CompleteMemoIntentHandler: NSObject, CompleteMemoIntentHandling {
    func resolveMemo(for intent: CompleteMemoIntent,
                     with completion: @escaping (MemoResolutionResult) -> Void) {
        guard let memo = intent.memo else { return completion(.needsValue()) }
        completion(.success(with: memo))
    }

    func confirm(intent: CompleteMemoIntent,
                 completion: @escaping (CompleteMemoIntentResponse) -> Void) {
        completion(CompleteMemoIntentResponse(code: .ready, userActivity: nil))
    }

    func handle(intent: CompleteMemoIntent,
                completion: @escaping (CompleteMemoIntentResponse) -> Void) {
        if let id = intent.memo?.identifier { MemoStore.shared.complete(id) }
        completion(CompleteMemoIntentResponse(code: .success, userActivity: nil))
    }
}
