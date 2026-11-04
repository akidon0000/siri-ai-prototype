import AppIntentsTesting
import Evaluations
import SiriEvaluations
import Testing

let memoIntents = IntentDefinitions(bundleIdentifier: "com.akidon0000.SiriAIPrototype")

struct MemoEvaluation: Evaluation {
    let name: String
    let dataset: SiriScenarioLoader
}
