import AppIntentsTesting
import Evaluations
import SiriEvaluations
import Testing

// Definitions for looking up the app's intents and entities by name
let memoIntents = IntentDefinitions(bundleIdentifier: "com.akidon0000.SiriAIPrototype")

let addMemoScenario = SiriScenario {
    UserTurn("Make a memo in SiriAIPrototype to buy milk") {
        Calls { memoIntents.intents["CreateMemoIntent"].expect(title: .contains("milk")) }
    }
}

struct MemoEvaluation: Evaluation {
    let name: String
    let dataset: SiriScenarioLoader

    // Called once per scenario. You can also set up state and clean up here
    func subject(from sample: SiriScenario) async throws -> SiriScenarioSubject {
        try await SiriService.run(scenario: sample)
    }

    // Score by comparing the expectations in the scenario with the actual calls
    var evaluators: Evaluators {
        SiriExpectationEvaluator()
    }

    func aggregateMetrics(using aggregator: inout MetricsAggregator) {
        Self.computeSiriMetrics(into: &aggregator)
    }
}
