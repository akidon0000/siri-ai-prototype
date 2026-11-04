import AppIntentsTesting
import Evaluations
import SiriEvaluations
import Testing

// アプリのintentとEntityを名前で引くための定義
let memoIntents = IntentDefinitions(bundleIdentifier: "com.akidon0000.SiriAIPrototype")

struct MemoEvaluation: Evaluation {
    // Xcodeのレポートに出る題名
    let name: String
    // 実行するシナリオの集まり
    let dataset: SiriScenarioLoader
}
