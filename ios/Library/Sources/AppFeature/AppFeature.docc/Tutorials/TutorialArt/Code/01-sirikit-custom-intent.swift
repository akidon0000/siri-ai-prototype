import Intents

// SiriKit時代、アプリ独自の操作を公開するには
// まず .intentdefinition でカスタムintentのスキーマを作り、
// そこから生成された CompleteMemoIntent に対してこのハンドラを書く必要があった。
class CompleteMemoIntentHandler: NSObject, CompleteMemoIntentHandling {

    // 1. resolve: パラメータが曖昧なときに候補を提示する
    func resolveMemo(
        for intent: CompleteMemoIntent,
        with completion: @escaping (MemoResolutionResult) -> Void
    ) {
        guard let memo = intent.memo else {
            completion(.needsValue())
            return
        }
        completion(.success(with: memo))
    }

    // 2. confirm: 実行前に「本当にこの内容で合っているか」を確認する
    func confirm(
        intent: CompleteMemoIntent,
        completion: @escaping (CompleteMemoIntentResponse) -> Void
    ) {
        completion(CompleteMemoIntentResponse(code: .ready, userActivity: nil))
    }

    // 3. handle: ここでやっと実際の処理を行う
    func handle(
        intent: CompleteMemoIntent,
        completion: @escaping (CompleteMemoIntentResponse) -> Void
    ) {
        // MemoStoreなど実データへの更新処理
        let response = CompleteMemoIntentResponse(code: .success, userActivity: nil)
        completion(response)
    }
}
