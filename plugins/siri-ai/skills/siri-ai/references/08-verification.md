# 第8章: 検証する

所要時間の目安: 25分。公開版: https://akidon0000.github.io/siri-ai-tutorials/tutorials/appfeature/08-verification

## 検証する

App Intentsの不具合は、エラーにならずに静かに壊れることが多い。Siriが別の操作を選ぶ、ショートカットが失敗する、Spotlightに出てこない、といった形で現れる。Appleは検証を4段階に分けている。コードで書く統合テスト、Shortcutsアプリでの確認、Spotlightでの確認、Siriに実際に話しかける確認で、Siri AI Developer Previewでは最後の段階をSiri Evaluationsで自動化できる。

教材: [Verifying your App Intents implementation](https://developer.apple.com/documentation/appintents/verifying-your-app-intents-implementation)、[Testing your App Intents code](https://developer.apple.com/documentation/appintentstesting/testing-your-app-intents-code)、[Siri Evaluations](https://developer.apple.com/documentation/sirievaluations)

## App Intents Testingで統合テストを書く

App Intents Testingは、SiriやShortcutsと同じ経路でアプリのintentをプロセスの外から実行する。テストはアプリの型をimportせず、intentやEntityを名前の文字列で探して使う。そのため、ユニットテストではなくUIテストのターゲットに置く。

1. テストの前提を揃えるためのテスト専用intentを、アプリ側に作る。`#if DEBUG` で囲み、リリースビルドには入れない。 — コード: `ResetMemosIntent.swift`
2. `isDiscoverable` を `false` にしてShortcutsやSiriに出ないようにし、`perform()` で初期データに戻す。UIを操作して状態を作る必要が無くなり、画面の構成が変わってもテストが壊れない。 — コード: `ResetMemosIntent.swift`
3. UIテストのターゲットにテストクラスを作る。`XCUIApplication` と `IntentDefinitions` を持つ。テストターゲットはアプリと同じ署名チームにする。 — コード: `MemoIntentsTests.swift`
4. `setUp` でアプリを起動し、バンドルIDから `IntentDefinitions` を作る。アプリが登録した全てのintent・Entity・Enum・クエリを、ここから名前で引ける。 — コード: `MemoIntentsTests.swift`
5. `intents["CreateMemoIntent"]` でintentを引き、`makeIntent(title:)` でパラメータを渡して `run()` する。結果は動的メンバー参照で `result.value.title` のように読める。 — コード: `MemoIntentsTests.swift`
6. `entities["MemoEntity"].entities(matching:)` で、Siriが名前を聞き取ったときと同じ探し方を試す。第2章の `entities(matching:)` が正しく動いているかの確認になる。 — コード: `MemoIntentsTests.swift`
7. `spotlightQuery(_:)` で、第6章のSpotlight索引にメモが載っているかを確かめる。`nil` を渡すと、その型の索引済みEntityを全て取れる。 — コード: `MemoIntentsTests.swift`
8. `setUp` の最後で `ResetMemosIntent` を実行し、どのテストも同じ初期データから始める。ほかに、`viewAnnotations()` で画面上の注釈を、`exported(as:)` と `resolved(from:)` で `Transferable` の往復を確かめるAPIもある。 — コード: `MemoIntentsTests.swift`

### このセクションを終えた時点のコード

`ResetMemosIntent.swift`

```swift
// テスト専用のintent。リリースビルドには入れない
#if DEBUG
import AppIntents

struct ResetMemosIntent: AppIntent {
    static let title: LocalizedStringResource = "メモを初期データに戻す"
    static let isDiscoverable = false

    func perform() async throws -> some IntentResult {
        try await MemoStore.shared.resetToSeedData()
        return .result()
    }
}
#endif
```

`MemoIntentsTests.swift`

```swift
// アプリの型はimportしない。intentやEntityは名前の文字列で引く
import AppIntentsTesting
import XCTest

final class MemoIntentsTests: XCTestCase {
    let app = XCUIApplication()
    var definitions: IntentDefinitions!

    override func setUp() async throws {
        app.launch()
        // アプリが登録したintent・Entity・Enum・クエリを、バンドルIDから読み込む
        definitions = IntentDefinitions(bundleIdentifier: "com.akidon0000.SiriAIPrototype")
        // どのテストも同じ初期データから始める
        try await definitions.intents["ResetMemosIntent"].makeIntent().run()
    }

    // SiriやShortcutsと同じ経路で、アプリの外からintentを実行する
    func testCreateMemo() async throws {
        let result = try await definitions.intents["CreateMemoIntent"].makeIntent(title: "牛乳を買う").run()
        let title: String = try result.value.title
        XCTAssertEqual(title, "牛乳を買う")
    }

    // Siriが名前を聞き取ったときと同じ探し方で、メモが見つかるか
    func testFindMemoByName() async throws {
        let memos = try await definitions.entities["MemoEntity"].entities(matching: "牛乳")
        XCTAssertFalse(memos.isEmpty)
    }

    func testMemoIsIndexedInSpotlight() async throws {
        let indexed = try await definitions.entities["MemoEntity"].spotlightQuery("牛乳")
        XCTAssertFalse(indexed.isEmpty)
    }
}
```

## ShortcutsとSpotlightで手で確かめる

統合テストでは、表示の自然さや、システムがデータを見つけられるかまでは分からない。

1. Shortcutsアプリで新規ショートカットを作り、アクションの一覧にアプリのintentが並ぶかを見る。第2章の `parameterSummary` が自然な1文として読めるか、対応する全ての言語で確かめる。 — コード: `AddMemoIntent.swift`
2. intentの結果を次のアクションにつなぎ、`MemoEntity` が正しい型のまま流れるかを確かめる。`perform()` の先頭にブレークポイントを置いてShortcutsから実行すると、そこで止まる。 — コード: `AddMemoIntent.swift`
3. 実機のSpotlightでメモのタイトルを検索し、結果をタップしてアプリの該当画面が開くかを確かめる。App Shortcutのフレーズが、入力途中の候補として出るかも見る。索引をやり直したいときは、設定 > デベロッパのCoreSpotlight Testingから初期化できる。 — コード: `MemoSpotlightIndexer.swift`

### このセクションを終えた時点のコード

`AddMemoIntent.swift`

```swift
import AppIntents

// PredictableIntent: 提案として表示されるときの文言を決められる
struct AddMemoIntent: AppIntent, PredictableIntent {
    static let title: LocalizedStringResource = "メモを追加"
    // Shortcutsアプリでの説明。Siriもこれを読んでintentの役割を知る
    static let description = IntentDescription("新しいメモを1件追加する。")

    // 値が無いとき、Siriはこの文で聞き返す
    @Parameter(title: "タイトル", requestValueDialog: "どんなメモを追加しますか？")
    var title: String

    // AppEnumなので、Siriは「低・通常・高」の中から選ぶ。言われなければ通常
    @Parameter(title: "優先度", default: .normal)
    var priority: MemoPriority

    // Shortcutsアプリでは、パラメータを埋め込んだこの1文として表示される
    // 対応する全ての言語で、自然な1文として読めるかをShortcutsアプリで確かめる
    static var parameterSummary: some ParameterSummary {
        Summary("\(\.$title)を優先度\(\.$priority)で追加")
    }

    static var predictionConfiguration: some IntentPredictionConfiguration {
        IntentPrediction(parameters: (\Self.$title)) { title in
            DisplayRepresentation(title: "「\(title)」をメモに追加")
        }
    }

    // Shortcutsから実行すると、この行に置いたブレークポイントで止まる
    func perform() async throws -> some IntentResult & ReturnsValue<MemoEntity> & ProvidesDialog & ShowsSnippetIntent {
        // 同じ名前のメモがあれば、その場で別の名前を聞き返す
        if try await MemoStore.shared.contains(title: title) {
            title = try await $title.requestValue("同じ名前のメモがあります。別の名前にしますか？")
        }
        let memo = try await MemoStore.shared.add(title: title, priority: priority)
        // 作ったメモを返すと、ショートカットの次のアクションに渡せる
        return .result(
            value: memo,
            // full は画面が無いときに読み上げる文、supporting は画面と一緒に出す短い文
            dialog: IntentDialog(full: "「\(memo.title)」をメモに追加しました。", supporting: "追加しました"),
            // ボタンを押せるスニペットは、ビューではなく SnippetIntent で返す
            snippetIntent: MemoSnippetIntent(memo: memo)
        )
    }
}
```

`MemoSpotlightIndexer.swift`

```swift
import AppIntents
import CoreSpotlight

// 索引をやり直したいときは、端末の 設定 > デベロッパ > CoreSpotlight Testing で初期化できる
struct MemoSpotlightIndexer {
    private let searchIndex = CSSearchableIndex(name: "memos")

    func index(_ memos: [MemoEntity]) async throws {
        try await searchIndex.indexAppEntities(memos)
    }

    func remove(_ ids: [MemoEntity.ID]) async throws {
        try await searchIndex.deleteAppEntities(identifiedBy: ids, ofType: MemoEntity.self)
    }
}
```

## Siri Evaluationsで会話を自動テストする

Siri Evaluationsは、Siriへの依頼を台本（シナリオ）として書いて実行し、Siriがどのintentを呼んだか、どのEntityを見つけたかを期待と比べる。EvaluationsフレームワークとSwift Testingの上で動き、実行後にXcodeが各ターンのレポートを出す。

1. UIテストのターゲットに評価用のファイルを作り、`IntentDefinitions` を用意する。 — コード: `MemoSiriEvaluationTests.swift`
2. `Evaluation` に準拠する型を作る。`name` がXcodeのレポートの題名、`dataset` が実行するシナリオの集まり。 — コード: `MemoSiriEvaluationTests.swift`
3. `subject(from:)` で、渡されたシナリオを `SiriService.run(scenario:)` に流す。シナリオごとに1回呼ばれるので、実行前の状態作りや後片付けもここに書ける。 — コード: `MemoSiriEvaluationTests.swift`
4. 採点に `SiriExpectationEvaluator` を使い、`computeSiriMetrics(into:)` で標準の指標をレポートに出す。 — コード: `MemoSiriEvaluationTests.swift`
5. シナリオを書く。`UserTurn` が人の1回の発話で、その中の `Calls` で「`CreateMemoIntent` が、タイトルに牛乳を含めて呼ばれる」ことを期待する。 — コード: `MemoSiriEvaluationTests.swift`
6. `Calls(.disallowed)` で「削除は呼ばれない」ことも期待に加える。通常の `Calls` は挙げた呼び出しが起きたかしか見ないので、間違った操作をしていないかは `.disallowed` で明示しないと分からない。確認を求めた段階でも `.disallowed` は失敗になる。 — コード: `MemoSiriEvaluationTests.swift`
7. `@Test(.evaluates(...))` で評価をテストに付け、全てのintentの期待が満たされたかを `#expect` で確かめる。 — コード: `MemoSiriEvaluationTests.swift`
8. 複数ターンのシナリオを書く。1ターン目でタイトルを言わず、2ターン目で答える。ターンをまたぐ期待は、`SiriScenario` の `expectation:` 側に書く。Siriが聞き返している途中の呼び出しは、完了するまで `Calls` を満たさない。 — コード: `MemoSiriEvaluationTests.swift`
9. このシナリオ用のテストも足す。Siriの応答は実行ごとに揺れるので、シナリオは何度か実行し、遠回しな言い方や情報が足りない言い方も増やしていく。通るシナリオが増えるように、intentやパラメータの名前・説明、app skillを直していく。評価できるのはテストターゲットと同じ開発チームで署名したアプリだけで、実機では設定 > デベロッパでUI Automationを有効にする。 — コード: `MemoSiriEvaluationTests.swift`

### このセクションを終えた時点のコード

`MemoSiriEvaluationTests.swift`

```swift
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

@Test(.evaluates(MemoEvaluation(name: "聞き返し", dataset: SiriScenarioLoader { addMemoWithFollowUp })))
func addsMemoAfterFollowUp() async throws {
    #expect(EvaluationContext.current.result.aggregateValue(.mean(of: .intentsAllPass)) == 1)
}
```

## 実機でSiriに話しかける

最後は、人が実際に言いそうな言葉で試す。

1. 言い回しを変え、「えーと」のような言葉も混ぜる。メモを画面に出した状態と出していない状態で、「これを完了にして」が通じるかを比べる。通じた言い方は、Siri Evaluationsのシナリオにも足して毎回確かめる。 — コード: `MemoSiriEvaluationTests.swift`
2. 「牛乳のメモをメールで送って」のように、他のアプリにまたがる依頼も試す。AirPodsのように画面が無い状態で、音声の応答だけで結果が伝わるかを確かめる。アプリが対応する全ての言語で同じことをする。足したシナリオにもテストを付けておくと、intentの説明やapp skillを直したときに効果が分かる。 — コード: `MemoSiriEvaluationTests.swift`

### このセクションを終えた時点のコード

`MemoSiriEvaluationTests.swift`

```swift
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

// 実機で話しかけて通じた言い方も、シナリオにして毎回確かめる
let addMemoWithFiller = SiriScenario {
    UserTurn("えーと、SiriAIPrototypeに、牛乳を買うってメモしといて") {
        Calls { memoIntents.intents["CreateMemoIntent"].expect(title: .contains("牛乳")) }
    }
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

@Test(.evaluates(MemoEvaluation(name: "聞き返し", dataset: SiriScenarioLoader { addMemoWithFollowUp })))
func addsMemoAfterFollowUp() async throws {
    #expect(EvaluationContext.current.result.aggregateValue(.mean(of: .intentsAllPass)) == 1)
}

// 通じなかった言い方も残し、intentの説明やapp skillを直したら通るようになるかを見る
@Test(.evaluates(MemoEvaluation(name: "言いよどみ", dataset: SiriScenarioLoader { addMemoWithFiller })))
func addsMemoWithFiller() async throws {
    #expect(EvaluationContext.current.result.aggregateValue(.mean(of: .intentsAllPass)) == 1)
}
```

## 次のステップ

App Intents Testingの統合テストと、Siri Evaluationsのシナリオを用意してもらう。

1. 理解できたらこれをClaude Codeに貼る。実装から、ビルドと動作確認までを任せる。

### ワークショップ用プロンプト

チュートリアルのリポジトリ（akidon0000/siri-ai-tutorials）を clone した上で
Claude Code に渡すためのもの。自分のアプリで進めるときは、パスとターゲット名を読み替える。

```text
【ワークショップ】Siri AI Tutorials 第8章: 検証する

チュートリアル: https://akidon0000.github.io/siri-ai-tutorials/tutorials/appfeature/08-verification
リポジトリ: https://github.com/akidon0000/siri-ai-tutorials （clone済みのこのディレクトリで進める）

先に上のチュートリアルを読んで、コードの組み立て順と「なぜそう書くか」を把握する。
読めないときは ios/Library/Sources/AppFeature/AppFeature.docc/Tutorials/08-verification.tutorial を読む。
合わせて読む原文:
  - https://developer.apple.com/documentation/appintentstesting/testing-your-app-intents-code
  - https://developer.apple.com/documentation/sirievaluations
チュートリアルの MemoStore は、このリポジトリでは Clients の MemoClient と ClientsLive の LiveMemoClient に当たる。

## 作る
Memo の App Intents 実装を検証するテストを追加する。

- AppFeature に #if DEBUG の ResetMemosIntent (isDiscoverable = false) を追加する
- ios/App に UIテストのターゲットを追加し、App Intents Testing で
  CreateMemoIntent の実行 / MemoEntity の entities(matching:) / spotlightQuery を確かめるテストを書く
- 同じターゲットに Siri Evaluations の評価を書く
  （1ターンの追加、Calls(.disallowed) で削除が呼ばれないこと、2ターンで聞き返しに答えるシナリオ、言いよどみを含む言い方のシナリオ）
- Shortcuts アプリ・Spotlight・実機の Siri で手動確認する手順を ios/App の README にチェックリストとして残す

## 動かして確かめる
1. 単体テスト: `cd ios/Library && xcodebuild test -scheme Library -destination 'platform=iOS Simulator,name=iPhone 18 Pro'`
   （シミュレータ名は `xcrun simctl list devices available` で今あるiPhoneに合わせてよい）
2. アプリをビルドしてシミュレータで起動する:
   `cd ios/App && xcodebuild build -scheme SiriAIPrototype -destination 'platform=iOS Simulator,name=iPhone 18 Pro' -derivedDataPath build`
   `xcrun simctl boot 'iPhone 18 Pro' ; open -a Simulator ; xcrun simctl install booted ios/App/build/Build/Products/Debug-iphonesimulator/SiriAIPrototype.app ; xcrun simctl launch booted com.akidon0000.SiriAIPrototype`
   起動後に `xcrun simctl io booted screenshot` で画面を撮って確認する。
3. UIテストを流す: `cd ios/App && xcodebuild test -scheme SiriAIPrototype -destination 'platform=iOS Simulator,name=iPhone 18 Pro'`
   App Intents Testing のテストが緑になるまで直す。落ちたテストは、テストの側を疑う前にアプリ側の実装を疑う。
4. Siri Evaluations は Siri AI Developer Preview に対応した環境が要る。流せなかったら、流せない理由と必要な環境を報告に書く。
   評価を書いたこと自体は「作ったもの」、流して確かめたことは「確認できたこと」に分けて書く。
5. README のチェックリストをユーザーに渡し、実機でやってもらう。

終わったら、次の3つに分けて報告する。
- 作ったもの（追加・変更したファイル）
- 動かして確認できたこと（実行したコマンドと結果、スクリーンショット）
- 確認できなかったこと（理由つき）。確認していないことを「動いた」と書かない
```
