import AppIntentsTesting
import Evaluations
import SiriEvaluations
import Testing

// Definitions for looking up the app's intents and entities by name
let memoIntents = IntentDefinitions(bundleIdentifier: "com.akidon0000.SiriAIPrototype")

struct MemoEvaluation: Evaluation {
    let name: String
    let dataset: SiriScenarioLoader

    // Called once per scenario. You can also set up state and clean up here
    func subject(from sample: SiriScenario) async throws -> SiriScenarioSubject {
        try await SiriService.run(scenario: sample)
    }
}
