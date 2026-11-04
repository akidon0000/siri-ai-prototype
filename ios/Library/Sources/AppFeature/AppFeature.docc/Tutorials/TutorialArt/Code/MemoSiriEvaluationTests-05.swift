import AppIntentsTesting
import Evaluations
import SiriEvaluations
import Testing

let memoIntents = IntentDefinitions(bundleIdentifier: "com.akidon0000.SiriAIPrototype")

let addMemoScenario = SiriScenario {
    UserTurn("SiriAIPrototypeに牛乳を買うってメモして") {
        Calls { memoIntents.intents["CreateMemoIntent"].expect(title: .contains("牛乳")) }
    }
}

struct MemoEvaluation: Evaluation {
    let name: String
    let dataset: SiriScenarioLoader

    func subject(from sample: SiriScenario) async throws -> SiriScenarioSubject {
        try await SiriService.run(scenario: sample)
    }

    var evaluators: Evaluators {
        SiriExpectationEvaluator()
    }

    func aggregateMetrics(using aggregator: inout MetricsAggregator) {
        Self.computeSiriMetrics(into: &aggregator)
    }
}
