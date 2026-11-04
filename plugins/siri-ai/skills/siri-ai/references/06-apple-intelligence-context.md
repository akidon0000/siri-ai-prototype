# 第6章: Apple Intelligenceに文脈を渡す

所要時間の目安: 35分。公開版: https://akidon0000.github.io/siri-ai-tutorials/tutorials/appfeature/06-apple-intelligence-context

## Apple Intelligenceに文脈を渡す

スキーマはビルド時に「何ができるか」を伝えるが、実行時に「どのメモの話か」を知る手段にはならない。この章では、Spotlightの索引、画面に映っているもの、通知、UIで行った操作、他のアプリへの受け渡し、カメラ（ビジュアルインテリジェンス）という6つの経路で、Apple Intelligenceにアプリの文脈を渡す。

教材: `docs/apple-doc/apple-intelligence/apple-intelligence-and-siri-ai.md`、[Making app entities available in Spotlight](https://developer.apple.com/documentation/appintents/making-app-entities-available-in-spotlight)、[Providing contextual cues to Apple Intelligence and Siri](https://developer.apple.com/documentation/appintents/providing-contextual-cues-to-apple-intelligence-and-siri)、[Donating your app's data and actions to the system](https://developer.apple.com/documentation/appintents/donating-your-apps-data-and-actions-to-the-system)、[Integrating your app with visual intelligence](https://developer.apple.com/documentation/visualintelligence/integrating-your-app-with-visual-intelligence)、[WWDC26: Explore advanced App Intents features for Siri and Apple Intelligence](https://developer.apple.com/videos/play/wwdc2026/343/)

## Spotlightのセマンティック索引に載せる

Apple IntelligenceはSpotlightのセマンティック検索を使ってアプリのデータを探す。索引に載せたメモは、「牛乳のやつ」のようにあいまいに言われても、意味の近さで見つかる。

1. `MemoEntity` を `IndexedEntity` に準拠させる。索引に載せるための要件はこれだけで、`displayRepresentation` のタイトルやサブタイトルが索引の属性として自動で使われる。 — コード: `MemoEntity.swift`
2. 自動で使われる属性以外も索引に入れたいときのために、`MemoEntity` のextensionを作る。 — コード: `MemoEntity+Spotlight.swift`
3. `attributeSet` を実装する。ここで返した `CSSearchableItemAttributeSet` の内容が、自動で作られる属性に追加される。 — コード: `MemoEntity+Spotlight.swift`
4. メモのタグを `keywords` に入れる。タイトル・サブタイトル・画像を `attributeSet` にも入れた場合は、`displayRepresentation` 側の値が優先される。 — コード: `MemoEntity+Spotlight.swift`
5. 索引への登録を担う型を作る。既定の索引ではなく、名前を付けた `CSSearchableIndex` を使う。既定の索引は試作とテスト用。 — コード: `MemoSpotlightIndexer.swift`
6. `indexAppEntities(_:)` でメモを索引に入れる。同じ `id` のメモが既にあれば、新しく作らずに更新される。メモを追加したときと、タイトルなど表示に使う値が変わったときに呼ぶ。 — コード: `MemoSpotlightIndexer.swift`
7. メモを削除したら、`deleteAppEntities(identifiedBy:ofType:)` で索引からも消す。消し忘れると、Siriが存在しないメモを見つけてしまう。 — コード: `MemoSpotlightIndexer.swift`
8. 索引に問題が起きると、Spotlightはアプリに再登録を求めてくる。`MemoQuery` を `IndexedEntityQuery` に準拠させ、全件を再登録する `reindexAllEntities` を書く。 — コード: `MemoQuery.swift`
9. 指定された `id` だけを再登録する `reindexEntities(for:indexDescription:)` も書く。Spotlightの挙動はシミュレータと実機で違うことがあるので、索引の確認は実機で行う。 — コード: `MemoQuery.swift`

### このセクションを終えた時点のコード

`MemoEntity.swift`

```swift
import AppIntents

// Remindersドメインの reminder スキーマに合わせる。AppEntity への準拠はマクロが付ける
@AppEntity(schema: .reminders.reminder)
// IndexedEntity にすると、Spotlightの索引に入れられる
struct MemoEntity: IndexedEntity {
    // システムがこのメモを指すときに使う、変わらないID
    let id: UUID
    var title: String
    // スキーマでの完了状態の名前は isCompleted
    var isCompleted: Bool
    var sharedWith: [String]
    // ここからはスキーマが求めるプロパティ。対応していない機能は nil や空の値を返す
    var note: AttributedString?
    var tags: Set<String>
    var urls: [URL]
    var dueDate: DateComponents?
    var recurrence: Calendar.RecurrenceRule?
    var isFlagged: Bool?
    var creationDate: Date?
    var completionDate: Date?
    var list: MemoListEntity
    var locationTrigger: MemoLocationTriggerEntity?

    // Siriの応答・候補の一覧・Spotlightでメモ1件を表示するときの見た目
    var displayRepresentation: DisplayRepresentation {
        DisplayRepresentation(
            title: "\(title)",
            subtitle: isCompleted ? "完了" : "未完了",
            image: .init(systemName: isCompleted ? "checkmark.circle.fill" : "circle")
        )
    }

    // Siriが名前やIDからメモを探すときに使うクエリ
    static let defaultQuery = MemoQuery()
}
```

`MemoEntity+Spotlight.swift`

```swift
import AppIntents
import CoreSpotlight

extension MemoEntity {
    // 索引に入れる属性。タイトルなどの既定の属性に、足したい値を加える
    var attributeSet: CSSearchableItemAttributeSet {
        let attributes = CSSearchableItemAttributeSet()
        attributes.keywords = Array(tags)
        return attributes
    }
}
```

`MemoSpotlightIndexer.swift`

```swift
import AppIntents
import CoreSpotlight

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

`MemoQuery.swift`

```swift
import AppIntents
import CoreSpotlight

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

// Spotlightから索引のやり直しを頼まれたときに呼ばれる
extension MemoQuery: IndexedEntityQuery {
    func reindexAllEntities(indexDescription: CSSearchableIndexDescription) async throws {
        try await MemoSpotlightIndexer().index(MemoStore.shared.allMemos())
    }

    func reindexEntities(for identifiers: [MemoEntity.ID],
                         indexDescription: CSSearchableIndexDescription) async throws {
        try await MemoSpotlightIndexer().index(MemoStore.shared.memos(for: identifiers))
    }
}
```

## 画面に映っているものを伝える

Siriは画面上の文字は読めるが、それがアプリのどのデータなのかは分からない。ビューにEntityの注釈を付けると、「3番目を完了にして」「このメモ」が通じるようになる。注釈には、画面が表示しているデータだけを付ける。

1. メモ一覧の画面を作る。選択状態を `selection` で持っておく。 — コード: `MemoListView.swift`
2. `List` でメモを並べる。 — コード: `MemoListView.swift`
3. `List` に `appEntityIdentifier(forSelectionType:)` を付け、選択IDから `EntityIdentifier` を作って返す。行ごとに注釈を付けるのではなく、システムが必要になったときに IDから問い合わせる方式なので、行数が多くても負荷が小さい。選択したままスクロールして画面外に出た行もSiriが見つけられる。 — コード: `MemoListView.swift`
4. 画面全体で1件のメモを表示する詳細画面を作る。 — コード: `MemoDetailView.swift`
5. 本文としてタイトルを表示する。 — コード: `MemoDetailView.swift`
6. 1件だけを表示する画面では、`userActivity` で `NSUserActivity` を作り、`appEntityIdentifier` にそのメモを入れる。このactivityはHandoffで別のデバイスに引き継ぐときにも使われる。画面に複数のEntityが並んでいて、その一部にだけ付けたいときは、ビューに `appEntityIdentifier(_:)` を付ける方法もある。 — コード: `MemoDetailView.swift`
7. `MemoQuery` に `displayRepresentations(for:requestedComponents:)` を足す。画面上のEntityが多いとき、Siriは全データではなく表示用のテキストだけを問い合わせられるので、「3番目」がどれかを素早く判断できる。判断が遅いと、Siriが聞き返したり別のものを選んだりする。 — コード: `MemoQuery.swift`

### このセクションを終えた時点のコード

`MemoListView.swift`

```swift
import AppIntents
import SwiftUI

struct MemoListView: View {
    let memos: [MemoEntity]
    @State private var selection = Set<MemoEntity.ID>()

    var body: some View {
        List(memos, selection: $selection) { memo in
            Text(memo.title)
        }
        // 選択中のメモをSiriに伝える。「これを完了にして」の「これ」になる
        .appEntityIdentifier(forSelectionType: MemoEntity.ID.self) { id in
            EntityIdentifier(for: MemoEntity.self, identifier: id)
        }
    }
}
```

`MemoDetailView.swift`

```swift
import AppIntents
import SwiftUI

struct MemoDetailView: View {
    let memo: MemoEntity

    var body: some View {
        Text(memo.title)
            // 表示中のメモをNSUserActivityに載せ、「これ」がどのメモかをSiriに伝える
            .userActivity("com.akidon0000.SiriAIPrototype.memo") { activity in
                activity.title = memo.title
                activity.appEntityIdentifier = EntityIdentifier(for: MemoEntity.self, identifier: memo.id)
            }
    }
}
```

`MemoQuery.swift`

```swift
import AppIntents
import CoreSpotlight

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

    // 表示だけが要るときに、Entity全体を作らずに表示を返す
    func displayRepresentations(
        for identifiers: [MemoEntity.ID],
        requestedComponents: DisplayRepresentation.Components = .text
    ) async throws -> [MemoEntity.ID: DisplayRepresentation] {
        try await MemoStore.shared.titles(for: identifiers).mapValues { DisplayRepresentation(title: "\($0)") }
    }
}

// Spotlightから索引のやり直しを頼まれたときに呼ばれる
extension MemoQuery: IndexedEntityQuery {
    func reindexAllEntities(indexDescription: CSSearchableIndexDescription) async throws {
        try await MemoSpotlightIndexer().index(MemoStore.shared.allMemos())
    }

    func reindexEntities(for identifiers: [MemoEntity.ID],
                         indexDescription: CSSearchableIndexDescription) async throws {
        try await MemoSpotlightIndexer().index(MemoStore.shared.memos(for: identifiers))
    }
}
```

## 画面の外にある文脈を伝える

通知、Now Playing、アラームのように、アプリの画面以外にもアプリのデータは出てくる。これらにもEntityの注釈を付けられる。

1. 期限の通知を作る関数を用意する。 — コード: `MemoNotification.swift`
2. `UNMutableNotificationContent` の `appEntityIdentifiers` にメモのIDを入れる。AirPodsで通知が読み上げられたあとに「それ完了にして」と言えば、Siriはどのメモかが分かる。Now Playingでは `MusicContent` などの `appEntityIdentifiers` に、AlarmKitでは `AlarmConfiguration` に、同じようにEntityを渡す。一時的な `TransientAppEntity` は永続的なIDを持たないので、この注釈には使えない。 — コード: `MemoNotification.swift`

### このセクションを終えた時点のコード

`MemoNotification.swift`

```swift
import AppIntents
import UserNotifications

func makeDueNotification(for memo: MemoEntity) -> UNMutableNotificationContent {
    let content = UNMutableNotificationContent()
    content.title = memo.title
    // 通知にメモを結び付ける。通知を見ながら「これを完了にして」と言える
    content.appEntityIdentifiers = [
        EntityIdentifier(for: MemoEntity.self, identifier: memo.id)
    ]
    return content
}
```

## UIでの操作をdonateする

SiriやShortcutsから実行されたintentは、システムが自動で記録する。アプリの画面で行った操作は、アプリがdonateしない限りApple Intelligenceには伝わらない。

1. メモ一覧の画面のモデルを用意する。 — コード: `MemoListModel.swift`
2. 画面の「追加」ボタンから呼ばれる `addMemoFromUI` を書く。ここまではdonationとは関係のない、普通の追加処理。 — コード: `MemoListModel.swift`
3. 同じ操作に当たる `CreateMemoIntent`（第5章のスキーマ対応intent）を組み立て、結果と一緒に `IntentDonationManager.shared.donate(intent:result:)` に渡す。システムはこのintentを実行しない。記録しておき、「いつもこのアプリでメモを取る」という傾向の学習や、あいまいな依頼の解釈、ロック画面などでの提案に使う。 — コード: `MemoListModel.swift`
4. 提案として表示されるときの文言は、`PredictableIntent` で指定できる。`AddMemoIntent` に準拠を足し、`predictionConfiguration` で「「牛乳を買う」をメモに追加」のような短い説明を返す。 — コード: `AddMemoIntent.swift`
5. donationには、実際に人が行った操作だけを入れ、パラメータはなるべく埋める。ただしメッセージ本文のように予測に使ってほしくない値は入れない。実際の行動より多くdonateすると、システムはそのアプリのdonationを無視するようになる。 — コード: `MemoListModel.swift`

### このセクションを終えた時点のコード

`MemoListModel.swift`

```swift
import AppIntents

@MainActor
final class MemoListModel {
    func addMemoFromUI(title: String, list: MemoListEntity) async throws {
        let memo = try await MemoStore.shared.add(title: title, list: list, dueDate: nil)

        // 実際に人が行った操作だけをdonateする。実際より多いと、システムはこのアプリのdonationを無視する
        // パラメータはなるべく埋める。ただし予測に使ってほしくない値（本文など）は入れない
        // 同じ操作に当たるintentを組み立てる。システムはこれを実行せず、記録して学習に使う
        var intent = CreateMemoIntent()
        intent.title = title
        intent.list = list
        try await IntentDonationManager.shared.donate(intent: intent, result: .result(value: memo))
    }
}
```

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
    static var parameterSummary: some ParameterSummary {
        Summary("\(\.$title)を優先度\(\.$priority)で追加")
    }

    static var predictionConfiguration: some IntentPredictionConfiguration {
        IntentPrediction(parameters: (\Self.$title)) { title in
            DisplayRepresentation(title: "「\(title)」をメモに追加")
        }
    }

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

## 他のアプリへ渡す

Siri AIは「このメモをメールで送って」のように、あるアプリのEntityを別のアプリに渡して操作を続けられる。そのためにはEntityが `Transferable` に準拠している必要がある。

1. `MemoEntity` を `Transferable` に準拠させる。 — コード: `MemoEntity+Transferable.swift`
2. `transferRepresentation` で、メモをタイトルの文字列として書き出す。メールやメッセージのアプリは、この文字列を本文として受け取れる。連絡先や場所を表すEntityなら、`IntentValueRepresentation` で `IntentPerson` や `PlaceDescriptor` に変換できるようにしておくと、受け取ったアプリがそのまま使える形で渡せる。 — コード: `MemoEntity+Transferable.swift`

### このセクションを終えた時点のコード

`MemoEntity+Transferable.swift`

```swift
import AppIntents
import CoreTransferable

// Transferable にすると、Siriが他のアプリへメモを渡せる
extension MemoEntity: Transferable {
    static var transferRepresentation: some TransferRepresentation {
        // 文字列として渡す。受け取る側のアプリが読める形を選ぶ
        ProxyRepresentation(exporting: \.title)
    }
}
```

## カメラに映ったものからメモを探す

ビジュアルインテリジェンスは、カメラやスクリーンショットに写ったものを手がかりに、アプリの中の該当するデータを検索結果として並べる。

1. `IntentValueQuery` に準拠するクエリを作る。アプリに置ける、ビジュアルインテリジェンス用（`SemanticContentDescriptor` を受け取る）のクエリは1つだけ。 — コード: `MemoVisualSearchQuery.swift`
2. `values(for:)` で `SemanticContentDescriptor` を受け取る。`labels` には「milk」のような、写ったものを表す英語のラベルが入るので、それに合うメモを返す。牛乳パックにカメラを向けると「牛乳を買う」のメモが出る、という使い方になる。ラベルは `en_US` の一般的な語で、翻訳も類義語の展開もされない。画像そのもので探したいときは `pixelBuffer` を使う。 — コード: `MemoVisualSearchQuery.swift`
3. 検索結果をタップしたときは、第5章の `OpenMemoIntent` でメモが開く。結果が多いときは、Visual intelligenceドメインの `semanticContentSearch` スキーマに合わせたintentを作ると、「さらに表示」からアプリ内の一覧へ移れる。読み取った内容は `semanticContent` に入る。 — コード: `ShowMemoSearchResultsIntent.swift`
4. `perform()` で、受け取った内容に合うメモの一覧をアプリの画面に出す。 — コード: `ShowMemoSearchResultsIntent.swift`

### このセクションを終えた時点のコード

`MemoVisualSearchQuery.swift`

```swift
import AppIntents
import VisualIntelligence

// ビジュアルインテリジェンスの検索を受けるクエリ。アプリに1つだけ置ける
struct MemoVisualSearchQuery: IntentValueQuery {
    func values(for input: SemanticContentDescriptor) async throws -> [MemoEntity] {
        // labels には「milk」のような英語のラベルが入る。翻訳も類義語の展開もされない
        try await MemoStore.shared.memos(matchingAnyOf: input.labels)
    }
}
```

`ShowMemoSearchResultsIntent.swift`

```swift
import AppIntents
import VisualIntelligence

// ビジュアルインテリジェンスの「さらに表示」から呼ばれ、アプリ内の検索結果を開く
@AppIntent(schema: .visualIntelligence.semanticContentSearch)
struct ShowMemoSearchResultsIntent {
    // カメラやスクリーンショットから読み取った内容
    var semanticContent: VisualIntelligence.SceneDescriptor

    func perform() async throws -> some IntentResult {
        // MemoVisualSearchQuery と同じ条件で探した一覧を、アプリの画面に出す
        await MemoNavigator.shared.showVisualSearchResults(for: semanticContent)
        return .result()
    }
}
```

## 次のステップ

Memoのentityを、Spotlightから見つけられ、画面と通知の文脈が伝わり、UIの操作がdonationされる状態にしてもらう。

1. 理解できたらこれをClaude Codeに貼る。実装から、ビルドと動作確認までを任せる。

### ワークショップ用プロンプト

チュートリアルのリポジトリ（akidon0000/siri-ai-tutorials）を clone した上で
Claude Code に渡すためのもの。自分のアプリで進めるときは、パスとターゲット名を読み替える。

```text
【ワークショップ】Siri AI Tutorials 第6章: Apple Intelligenceに文脈を渡す

チュートリアル: https://akidon0000.github.io/siri-ai-tutorials/tutorials/appfeature/06-apple-intelligence-context
リポジトリ: https://github.com/akidon0000/siri-ai-tutorials （clone済みのこのディレクトリで進める）

先に上のチュートリアルを読んで、コードの組み立て順と「なぜそう書くか」を把握する。
読めないときは ios/Library/Sources/AppFeature/AppFeature.docc/Tutorials/06-apple-intelligence-context.tutorial を読む。
合わせて読む原文:
  - docs/apple-doc/apple-intelligence/apple-intelligence-and-siri-ai.md
  - docs/apple-doc/apple-intelligence/apple-intelligence.md
チュートリアルの MemoStore は、このリポジトリでは Clients の MemoClient と ClientsLive の LiveMemoClient に当たる。

## 作る
Memo の文脈を Apple Intelligence に渡す実装を追加する。

- MemoEntity を IndexedEntity に準拠させ、attributeSet で tags を keywords に入れる
- MemoSpotlightIndexer を作り、名前付きの CSSearchableIndex に indexAppEntities / deleteAppEntities する
  （メモの追加・更新・削除のたびに呼ぶ）
- MemoQuery を IndexedEntityQuery に準拠させ、再登録の2メソッドを実装する
- メモ一覧に appEntityIdentifier(forSelectionType:)、詳細画面（MemoDetailView）に NSUserActivity の appEntityIdentifier を付ける
- MemoQuery に displayRepresentations(for:requestedComponents:) を実装する
- 期限の通知を作るときに appEntityIdentifiers を設定する
- UIからメモを追加したときに CreateMemoIntent を IntentDonationManager.shared.donate で donation する
- AddMemoIntent を PredictableIntent に準拠させる
- MemoEntity を Transferable に準拠させる
- MemoVisualSearchQuery (IntentValueQuery, SemanticContentDescriptor) を追加する
- 「さらに表示」用に ShowMemoSearchResultsIntent (@AppIntent(schema: .visualIntelligence.semanticContentSearch)) を追加する

## 動かして確かめる
1. 単体テスト: `cd ios/Library && xcodebuild test -scheme Library -destination 'platform=iOS Simulator,name=iPhone 18 Pro'`
   （シミュレータ名は `xcrun simctl list devices available` で今あるiPhoneに合わせてよい）
2. アプリをビルドしてシミュレータで起動する:
   `cd ios/App && xcodebuild build -scheme SiriAIPrototype -destination 'platform=iOS Simulator,name=iPhone 18 Pro' -derivedDataPath build`
   `xcrun simctl boot 'iPhone 18 Pro' ; open -a Simulator ; xcrun simctl install booted ios/App/build/Build/Products/Debug-iphonesimulator/SiriAIPrototype.app ; xcrun simctl launch booted com.akidon0000.SiriAIPrototype`
   起動後に `xcrun simctl io booted screenshot` で画面を撮って確認する。
3. アプリでメモを数件追加したあと、シミュレータのホーム画面でSpotlight検索（下にスワイプ）にメモのタイトルを入れる。
   メモがこのアプリの結果として出ることを確かめる。メモを削除したら出なくなることも見る。
   UIを操作できるツールが無ければ、この手順をユーザーに案内して結果を聞く。
4. 単体テストで、indexAppEntities / deleteAppEntities が追加・更新・削除の各場面で呼ばれることを確かめる（インデックスは差し替え可能にしてよい）。
5. 画面・通知・ビジュアルインテリジェンスの文脈はシミュレータでは確かめきれない。確かめられなかった項目を報告に書く。

終わったら、次の3つに分けて報告する。
- 作ったもの（追加・変更したファイル）
- 動かして確認できたこと（実行したコマンドと結果、スクリーンショット）
- 確認できなかったこと（理由つき）。確認していないことを「動いた」と書かない
```
