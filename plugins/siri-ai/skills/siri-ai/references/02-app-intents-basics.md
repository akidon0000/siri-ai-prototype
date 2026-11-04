# 第2章: App Intentsの基礎

所要時間の目安: 25分。公開版: https://akidon0000.github.io/siri-ai-tutorials/tutorials/appfeature/02-app-intents-basics

## App Intentsの基礎

App Entity（データ）・Entity Query（データの探し方）・App Enum（選択肢）・ App Intent（操作）の4つを、Memoアプリを題材に1行ずつ組み立てる。ここで作る `MemoEntity` と `AddMemoIntent` は、第4章以降でも同じファイルを育てていく。

教材: `docs/apple-doc/app-intents/app-intents.md`、[App Intents](https://developer.apple.com/documentation/appintents)、[Defining app entities for your custom data types](https://developer.apple.com/documentation/appintents/defining-app-entities-for-your-custom-data-types)

## App Entity: データをシステムに見せる

App Entityは、アプリのデータのうちSiriやShortcutsから参照されうる部分を表す型。Memoアプリなら、メモ1件が `MemoEntity` になる。データベースの行をそのまま公開するのではなく、人が口にしそうな情報（タイトル・完了状態）に絞って軽く作る。

1. `AppEntity` に準拠する構造体と、3つのプロパティを書く。`id` はEntityを一意に識別する値で、Siriやショートカットはこの `id` だけを保存しておき、後で本体を取りに来る。この時点ではプロトコルの要件が足りないのでビルドは通らない。 — コード: `MemoEntity.swift`
2. `typeDisplayRepresentation` を足す。「メモ」という型そのものの呼び名で、Shortcutsのパラメータ欄やSiriの聞き返し（「どのメモ？」）に使われる。 — コード: `MemoEntity.swift`
3. `displayRepresentation` を足す。こちらは1件ごとの見え方で、ここではタイトルだけを返す。サブタイトルや画像は第4章で足す。 — コード: `MemoEntity.swift`
4. 最後に `defaultQuery` を足す。システムが `id` から `MemoEntity` を取り直すときの窓口で、次のセクションで作る `MemoQuery` を指す。これでAppEntityの要件が揃う。 — コード: `MemoEntity.swift`

### このセクションを終えた時点のコード

`MemoEntity.swift`

```swift
import AppIntents

struct MemoEntity: AppEntity {
    // システムがこのメモを指すときに使う、変わらないID
    let id: UUID
    var title: String
    var isDone: Bool

    static let typeDisplayRepresentation: TypeDisplayRepresentation = "メモ"

    // Siriの応答・候補の一覧・Spotlightでメモ1件を表示するときの見た目
    var displayRepresentation: DisplayRepresentation {
        DisplayRepresentation(title: "\(title)")
    }

    // Siriが名前やIDからメモを探すときに使うクエリ
    static let defaultQuery = MemoQuery()
}
```

## Entity Query: データの探し方を教える

Siriが「牛乳のメモを完了にして」と言われたとき、「牛乳のメモ」が実際にどの `MemoEntity` なのかを知る方法は、アプリが提供するクエリしかない。

1. `EntityQuery` に準拠し、必須の `entities(for:)` を書く。保存しておいた `id` の配列から `MemoEntity` を返すメソッドで、ショートカットを実行するたびに呼ばれる。 — コード: `MemoQuery.swift`
2. `suggestedEntities()` を足す。Siriが「どのメモ？」と聞き返すときや、Shortcutsでパラメータを選ぶときに候補として並ぶ。最近のメモなど、選ばれやすいものに絞る。 — コード: `MemoQuery.swift`
3. 準拠先を `EntityStringQuery` に変え、`entities(matching:)` を足す。人が言った「牛乳」という文字列から該当するメモを返せるようになり、Siriが名前でメモを探せるようになる。 — コード: `MemoQuery.swift`

### このセクションを終えた時点のコード

`MemoQuery.swift`

```swift
import AppIntents

// SiriやショートカットがIDからメモを取り出すときのクエリ
// EntityStringQuery にすると、名前（文字列）からも探せる
struct MemoQuery: EntityStringQuery {
    func entities(for identifiers: [MemoEntity.ID]) async throws -> [MemoEntity] {
        try await MemoStore.shared.memos(for: identifiers)
    }

    // 候補の一覧に出すメモ。ここでは最近のメモを返す
    func suggestedEntities() async throws -> [MemoEntity] {
        try await MemoStore.shared.recentMemos()
    }

    // Siriが聞き取った名前で探す
    func entities(matching string: String) async throws -> [MemoEntity] {
        try await MemoStore.shared.memos(matching: string)
    }
}
```

## App Enum: 決まった選択肢を公開する

メモの優先度のように値が決まっている型はApp Enumにする。Siriは「優先度高で」という言い方を、どのcaseに当たるかとして理解できるようになる。

1. `String` のraw valueを持つenumを `AppEnum` に準拠させる。raw valueはショートカットに保存される値なので、後から変えないものを選ぶ。 — コード: `MemoPriority.swift`
2. 型の呼び名 `typeDisplayRepresentation` を足す。 — コード: `MemoPriority.swift`
3. `caseDisplayRepresentations` で各caseの表示名を決める。Siriが読み上げ、聞き取るのはこの「低・通常・高」の方で、`low` などのcase名ではない。 — コード: `MemoPriority.swift`

### このセクションを終えた時点のコード

`MemoPriority.swift`

```swift
import AppIntents

// AppEnum にすると、Siriは決まった選択肢の中から値を選ぶ。フレーズにも埋め込める
enum MemoPriority: String, AppEnum {
    case low, normal, high

    static let typeDisplayRepresentation: TypeDisplayRepresentation = "優先度"

    static let caseDisplayRepresentations: [MemoPriority: DisplayRepresentation] = [
        .low: "低",
        .normal: "通常",
        .high: "高",
    ]
}
```

## App Intent: 操作をカプセル化する

「メモを追加する」を `AddMemoIntent` として定義する。ここまでに作った `MemoEntity` と `MemoPriority` を、パラメータと戻り値に使う。

1. `AppIntent` に準拠し、`title` を付ける。関数名ではなくこの `title` を見て人が操作を探すので、短く具体的な言葉にする。 — コード: `AddMemoIntent.swift`
2. `description` を足す。Shortcutsアプリで操作の説明として表示されるほか、第7章のSiri AIでは、Siriがこのintentを使うかどうかを判断する材料にもなる。 — コード: `AddMemoIntent.swift`
3. 必須の入力 `title` を `@Parameter` で宣言する。値が無いまま実行されると、システムが自動で聞き返す。 — コード: `AddMemoIntent.swift`
4. `priority` は `default: .normal` を付けて宣言する。人が優先度を言わなくても、聞き返さずに「通常」で追加できる。 — コード: `AddMemoIntent.swift`
5. `perform()` を書く。戻り値の型に `ReturnsValue<MemoEntity>` を含めると、追加したメモをShortcutsの次のアクションへ渡したり、Siriの応答に使ったりできる。 — コード: `AddMemoIntent.swift`
6. `parameterSummary` を足す。Shortcutsアプリでこのアクションが「〈タイトル〉を優先度〈通常〉で追加」という1文で表示され、文中の値をタップして編集できる。 — コード: `AddMemoIntent.swift`

### このセクションを終えた時点のコード

`AddMemoIntent.swift`

```swift
import AppIntents

struct AddMemoIntent: AppIntent {
    static let title: LocalizedStringResource = "メモを追加"
    // Shortcutsアプリでの説明。Siriもこれを読んでintentの役割を知る
    static let description = IntentDescription("新しいメモを1件追加する。")

    @Parameter(title: "タイトル")
    var title: String

    // AppEnumなので、Siriは「低・通常・高」の中から選ぶ。言われなければ通常
    @Parameter(title: "優先度", default: .normal)
    var priority: MemoPriority

    // Shortcutsアプリでは、パラメータを埋め込んだこの1文として表示される
    static var parameterSummary: some ParameterSummary {
        Summary("\(\.$title)を優先度\(\.$priority)で追加")
    }

    func perform() async throws -> some IntentResult & ReturnsValue<MemoEntity> {
        let memo = try await MemoStore.shared.add(title: title, priority: priority)
        // 作ったメモを返すと、ショートカットの次のアクションに渡せる
        return .result(value: memo)
    }
}
```

## 次のステップ

Memo (id, title, isDone) を題材に、AppEntity・EntityQuery・AppEnum・AppIntentを `ios/Library` に実装してもらう。ここまでのコードは教材用で、まだパッケージには入っていない。

1. 理解できたらこれをClaude Codeに貼る。実装から、ビルドと動作確認までを任せる。

### ワークショップ用プロンプト

チュートリアルのリポジトリ（akidon0000/siri-ai-tutorials）を clone した上で
Claude Code に渡すためのもの。自分のアプリで進めるときは、パスとターゲット名を読み替える。

```text
【ワークショップ】Siri AI Tutorials 第2章: App Intentsの基礎

チュートリアル: https://akidon0000.github.io/siri-ai-tutorials/tutorials/appfeature/02-app-intents-basics
リポジトリ: https://github.com/akidon0000/siri-ai-tutorials （clone済みのこのディレクトリで進める）

先に上のチュートリアルを読んで、コードの組み立て順と「なぜそう書くか」を把握する。
読めないときは ios/Library/Sources/AppFeature/AppFeature.docc/Tutorials/02-app-intents-basics.tutorial を読む。
合わせて読む原文:
  - docs/apple-doc/app-intents/app-intents.md
チュートリアルの MemoStore は、このリポジトリでは Clients の MemoClient と ClientsLive の LiveMemoClient に当たる。

## 作る
ios/Library に Memo の App Intents実装を追加する。

- Clients/MemoClient.swift: MemoClient プロトコルに add / memos(for:) / recentMemos / memos(matching:) / complete を定義する
- ClientsLive/LiveMemoClient.swift: メモリ内配列で保持する実装
- AppFeature に MemoEntity (id, title, isDone) と MemoQuery (EntityStringQuery) を追加する
- AppFeature に MemoPriority (AppEnum: 低・通常・高) を追加する
- AppFeature に AddMemoIntent（parameterSummary 付き）と CompleteMemoIntent を追加する
- AppFeature に最小のメモ一覧画面（MemoListView）を作り、アプリ上でメモの追加と完了ができるようにする
  （第3章以降で結果を目で確かめるための画面。凝らなくてよい）
- TestSupport に固定データを返す TestMemoClient を用意する
- AppFeatureTests に2つのIntentと MemoQuery の単体テストを書く

## 動かして確かめる
1. 単体テスト: `cd ios/Library && xcodebuild test -scheme Library -destination 'platform=iOS Simulator,name=iPhone 18 Pro'`
   （シミュレータ名は `xcrun simctl list devices available` で今あるiPhoneに合わせてよい）
2. アプリをビルドしてシミュレータで起動する:
   `cd ios/App && xcodebuild build -scheme SiriAIPrototype -destination 'platform=iOS Simulator,name=iPhone 18 Pro' -derivedDataPath build`
   `xcrun simctl boot 'iPhone 18 Pro' ; open -a Simulator ; xcrun simctl install booted ios/App/build/Build/Products/Debug-iphonesimulator/SiriAIPrototype.app ; xcrun simctl launch booted com.akidon0000.SiriAIPrototype`
   起動後に `xcrun simctl io booted screenshot` で画面を撮って確認する。
3. ショートカットアプリ（シミュレータにある）を開き、新規ショートカットのアクション検索で「Siri AI Prototype」を探す。
   追加したAppIntent（メモを追加 / メモを完了にする）が出ること、「メモを追加」を実行するとダイアログが返ることを確かめる。
   UIを操作できるツール（iOS Simulator MCPなど）が無ければ、この手順をユーザーに案内して結果を聞く。

終わったら、次の3つに分けて報告する。
- 作ったもの（追加・変更したファイル）
- 動かして確認できたこと（実行したコマンドと結果、スクリーンショット）
- 確認できなかったこと（理由つき）。確認していないことを「動いた」と書かない
```
