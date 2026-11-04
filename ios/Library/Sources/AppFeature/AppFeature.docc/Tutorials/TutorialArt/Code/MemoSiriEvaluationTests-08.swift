import AppIntentsTesting
import Evaluations
import SiriEvaluations
import Testing

// アプリのintentとEntityを名前で引くための定義
let memoIntents = IntentDefinitions(bundleIdentifier: "com.akidon0000.SiriAIPrototype")

let addMemoScenario = SiriScenario {
    UserTurn("SiriAIPrototypeに牛乳を買うってメモして") {
        Calls { memoIntents.intents["CreateMemoIntent"].expect(title: .contains("牛乳")) }
        // 削除が呼ばれたら失敗にする。確認を求めた段階でも失敗になる
        Calls(.disallowed) { memoIntents.intents["DeleteMemoIntent"] }
    }
}

// 2ターンの会話。ターンをまたぐ期待は expectation 側に書く
let addMemoWithFollowUp = SiriScenario {
    UserTurn("SiriAIPrototypeにメモを追加して")
    UserTurn("牛乳を買う")
} expectation: {
    Calls { memoIntents.intents["CreateMemoIntent"].expect(title: .contains("牛乳")) }
}

struct MemoEvaluation: Evaluation {
    let name: String
    let dataset: SiriScenarioLoader

    // シナリオごとに1回呼ばれる。実行前の状態作りや後片付けもここに書ける
    func subject(from sample: SiriScenario) async throws -> SiriScenarioSubject {
        try await SiriService.run(scenario: sample)
    }

    // シナリオに書いた期待と、実際の呼び出しを比べて採点する
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
