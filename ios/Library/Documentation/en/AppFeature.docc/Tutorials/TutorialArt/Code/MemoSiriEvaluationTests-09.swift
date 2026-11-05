import AppIntentsTesting
import Evaluations
import SiriEvaluations
import Testing

// Definitions for looking up the app's intents and entities by name
let memoIntents = IntentDefinitions(bundleIdentifier: "com.akidon0000.SiriAIPrototype")

let addMemoScenario = SiriScenario {
    UserTurn("Make a memo in SiriAIPrototype to buy milk") {
        Calls { memoIntents.intents["CreateMemoIntent"].expect(title: .contains("milk")) }
        // Fail if delete is called. Even asking for confirmation counts as a failure
        Calls(.disallowed) { memoIntents.intents["DeleteMemoIntent"] }
    }
}

// A two-turn conversation. Write expectations that span turns in expectation
let addMemoWithFollowUp = SiriScenario {
    UserTurn("Add a memo in SiriAIPrototype")
    UserTurn("Buy milk")
} expectation: {
    Calls { memoIntents.intents["CreateMemoIntent"].expect(title: .contains("milk")) }
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

@Test(.evaluates(MemoEvaluation(name: "Add a memo", dataset: SiriScenarioLoader { addMemoScenario })))
func addsMemo() async throws {
    #expect(EvaluationContext.current.result.aggregateValue(.mean(of: .intentsAllPass)) == 1)
}

@Test(.evaluates(MemoEvaluation(name: "Follow-up question", dataset: SiriScenarioLoader { addMemoWithFollowUp })))
func addsMemoAfterFollowUp() async throws {
    #expect(EvaluationContext.current.result.aggregateValue(.mean(of: .intentsAllPass)) == 1)
}
