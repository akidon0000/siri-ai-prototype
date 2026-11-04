import Intents

// SiriKitのカスタムintentのハンドラ。Xcodeが生成したプロトコルに準拠する
class CompleteMemoIntentHandler: NSObject, CompleteMemoIntentHandling {
    // resolve: パラメータが揃っているかを確かめる。無ければ needsValue で聞き返す
    func resolveMemo(for intent: CompleteMemoIntent,
                     with completion: @escaping (MemoResolutionResult) -> Void) {
        guard let memo = intent.memo else { return completion(.needsValue()) }
        completion(.success(with: memo))
    }

    // confirm: 実行できる状態かを確かめる
    func confirm(intent: CompleteMemoIntent,
                 completion: @escaping (CompleteMemoIntentResponse) -> Void) {
        completion(CompleteMemoIntentResponse(code: .ready, userActivity: nil))
    }

    // handle: 実際に処理して、結果をレスポンスのコードで返す
    func handle(intent: CompleteMemoIntent,
                completion: @escaping (CompleteMemoIntentResponse) -> Void) {
        if let id = intent.memo?.identifier { MemoStore.shared.complete(id) }
        completion(CompleteMemoIntentResponse(code: .success, userActivity: nil))
    }
}
