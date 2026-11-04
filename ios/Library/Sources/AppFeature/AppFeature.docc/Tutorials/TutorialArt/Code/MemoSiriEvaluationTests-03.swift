import AppIntentsTesting
import Evaluations
import SiriEvaluations
import Testing

let memoIntents = IntentDefinitions(bundleIdentifier: "com.akidon0000.SiriAIPrototype")

struct MemoEvaluation: Evaluation {
    let name: String
    let dataset: SiriScenarioLoader

    func subject(from sample: SiriScenario) async throws -> SiriScenarioSubject {
        try await SiriService.run(scenario: sample)
    }
}
