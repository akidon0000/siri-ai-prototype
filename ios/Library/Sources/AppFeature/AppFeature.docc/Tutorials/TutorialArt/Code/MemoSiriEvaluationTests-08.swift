import AppIntentsTesting
import Evaluations
import SiriEvaluations
import Testing

let memoIntents = IntentDefinitions(bundleIdentifier: "com.akidon0000.SiriAIPrototype")

let addMemoScenario = SiriScenario {
    UserTurn("SiriAIPrototypeに牛乳を買うってメモして") {
        Calls { memoIntents.intents["CreateMemoIntent"].expect(title: .contains("牛乳")) }
        Calls(.disallowed) { memoIntents.intents["DeleteMemoIntent"] }
    }
}

let addMemoWithFollowUp = SiriScenario {
    UserTurn("SiriAIPrototypeにメモを追加して")
    UserTurn("牛乳を買う")
} expectation: {
    Calls { memoIntents.intents["CreateMemoIntent"].expect(title: .contains("牛乳")) }
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

@Test(.evaluates(MemoEvaluation(name: "メモの追加", dataset: SiriScenarioLoader { addMemoScenario })))
func addsMemo() async throws {
    #expect(EvaluationContext.current.result.aggregateValue(.mean(of: .intentsAllPass)) == 1)
}
