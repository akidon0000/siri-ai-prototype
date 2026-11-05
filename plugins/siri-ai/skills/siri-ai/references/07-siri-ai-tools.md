# 第7章: Siri AI Developer Preview【iOS 27.3 beta】

所要時間の目安: 50分。公開版: https://akidon0000.github.io/siri-ai-tutorials/tutorials/appfeature/07-siri-ai-tools

## Siri AI Developer Preview: ツールとapp skill

Siri AI Developer Previewでは、スキーマに当てはまらないアプリ独自の操作とデータも、Siriが見つけて実行できるようになる。その入口が、App Intentを「ツール」にする `@AppIntent(.tool)` と、複数のツールの使い方を教える「app skill」。

この章のAPIと機能は、全てSiri AI Developer Preview（iOS 27.3 beta）で入ったもの。正式版までに名前や挙動が変わることがある。

教材: `docs/apple-doc/apple-intelligence/siri-ai-developer-preview.md`、[Siri AI Developer Preview](https://developer.apple.com/documentation/appintents/siri-ai-developer-preview)、[Bringing custom actions and content to Siri](https://developer.apple.com/documentation/appintents/bringing-custom-actions-and-content-to-siri)、[Orchestrating complex actions with app skills](https://developer.apple.com/documentation/appintents/orchestrating-complex-actions-with-app-skills)

## ツールにするintentを選ぶ

どのintentをツールにするかはアプリが決める。全てをツールにすればよいわけではない。判断の基準は [ToolIntent](https://developer.apple.com/documentation/appintents/toolintent) にまとまっている。ここでは、この章で扱うintentを「ツールにする（○）」「しない（×）」に分けて並べる。中身は後のセクションで書く。

1. 向いているのは、1文で頼めて、その文からパラメータを埋められる操作。「牛乳のメモを優先度高にして」なら、メモと優先度の両方が1文に入っている。この「優先度を変える」をツールにする。 — コード: `ToolCandidates.swift`
2. 第5章でSiriが使えるスキーマ（`createReminder` など）に合わせたintentには、ツールの指定を付けない。スキーマに合わせた時点でSiriに公開されていて、付けるとビルドエラーになる。例外はShortcuts専用ドメインのスキーマで、これは後の参考セクションで扱う。 — コード: `ToolCandidates.swift`
3. ウィジェットの設定用intentのように実行する操作を持たないもの、ショートカットの途中の1手順としてしか意味を持たないもの、注文と支払いのように人が明示的に始めるべき副作用を持つものも、ツールにしない。`WidgetConfigurationIntent` でも、`perform()` で独自の操作をしているならツールにできる。 — コード: `ToolCandidates.swift`
4. Memoアプリでは、作成・更新・削除は第5章のスキーマで公開済み。スキーマに無い「優先度を変える」に加えて、「条件でメモを探す」もツールにする。 — コード: `ToolCandidates.swift`

### このセクションを終えた時点のコード

`ToolCandidates.swift`

```swift
import AppIntents

// ○ ツールにする: 1文で頼めて、その文からパラメータを埋められる
// 「牛乳のメモを優先度高にして」なら、memo と priority が1文に入っている
@AppIntent(.tool)
struct SetMemoPriorityIntent: AppIntent { /* 次のセクションで作る */ }

// × 付けない: Siriで使えるスキーマに合わせたintentは、それだけでSiriに公開されている
// @AppIntent(.tool, schema: .reminders.createReminder) と書くとビルドエラーになる
@AppIntent(schema: .reminders.createReminder)
struct CreateMemoIntent { /* 第5章 */ }

// × 付けない: 実行する操作を持たない、ウィジェットの設定用intent
// （perform() で独自の操作をしているなら、WidgetConfigurationIntent でもツールにできる）
struct SelectMemoListIntent: WidgetConfigurationIntent { /* … */ }
// × 付けない: ショートカットの途中の1手順としてしか意味を持たないintent
// × 付けない: 注文や支払いのように、人が明示的に始めるべき副作用を持つintent

// ○ ツールにする: スキーマに無い「条件でメモを探す」
@AppIntent(.tool)
struct FindMemosIntent: AppIntent { /* 後のセクションで作る */ }
```

## ツールを作る

優先度を変える `SetMemoPriorityIntent` を、普通のApp Intentとして作ってからツールにする。

1. `AppIntent` に準拠した構造体と `title` を書く。 — コード: `SetMemoPriorityIntent.swift`
2. 対象のメモと新しい優先度を `@Parameter` で受け取る。 — コード: `SetMemoPriorityIntent.swift`
3. `perform()` を書く。ここまでは第2章と同じ普通のApp Intent。 — コード: `SetMemoPriorityIntent.swift`
4. 型の上に `@AppIntent(.tool)` を付ける。変更はこの1行だけ。[AppIntent(_:)](https://developer.apple.com/documentation/appintents/appintent(_:)) マクロは、型に `ToolIntent` への準拠を足す。型に `@available` があればそれを、無ければ `ToolIntent` 側の availabilityを引き継ぐ。 — コード: `SetMemoPriorityIntent.swift`
5. マクロに渡している `.tool` は [AppIntentTraits](https://developer.apple.com/documentation/appintents/appintenttraits) の値で、intentが担う役割を表す。`.tool` のように1つでも、`[.tool]` のように配列でも書ける。マクロは書かれたままの値を読むので、変数や計算した値は渡せない。 — コード: `SetMemoPriorityIntent.swift`
6. `description` と、各 `@Parameter` の `description` を足す。Siriのモデルは、これらを読んでツールが何をするか・何を渡せばよいかを判断する。アプリを知らない人に向けて書き、文字列の形式・数値の範囲・単位があれば書いておく（[ToolIntent](https://developer.apple.com/documentation/appintents/toolintent)、[Bringing custom actions and content to Siri](https://developer.apple.com/documentation/appintents/bringing-custom-actions-and-content-to-siri)）。 — コード: `SetMemoPriorityIntent.swift`

### このセクションを終えた時点のコード

`SetMemoPriorityIntent.swift`

```swift
import AppIntents

// .tool は AppIntentTraits の値。[.tool] と配列でも書ける。変数や計算した値は渡せない
@AppIntent(.tool)
struct SetMemoPriorityIntent: AppIntent {
    static let title: LocalizedStringResource = "メモの優先度を変える"
    // Siriのモデルはこの説明を読んで、いつこのツールを使うかを決める。アプリを知らない人に向けて書く
    static let description = IntentDescription("メモ1件の優先度を、低・通常・高のいずれかに変更する。")

    // 何を渡せばよいかを書く
    @Parameter(title: "メモ", description: "優先度を変えたいメモ")
    var memo: MemoEntity

    // 取りうる値があれば書いておく
    @Parameter(title: "優先度", description: "変更後の優先度。低・通常・高のいずれか")
    var priority: MemoPriority

    func perform() async throws -> some IntentResult {
        try await MemoStore.shared.setPriority(priority, for: memo.id)
        return .result()
    }
}
```

## Siriがツールを呼べる場面

作ったツールがいつでも呼ばれるわけではない。Siriがアプリのツールを使うのは、そのアプリが会話に関係していると判断できるときに限られる。

1. アプリが前面にあるとき、Live Activityが動いているとき、Siriアプリでの会話にアプリが出てきたときは、アプリ名を言わなくてもツールが使われる。例: 配車アプリのLive Activityを見ながら「迎えの場所を変えて」と言う（[Siri AI Developer Preview](https://developer.apple.com/documentation/appintents/siri-ai-developer-preview)）。 — コード: `SetMemoPriorityIntent.swift`
2. アプリが後ろにあるときは、依頼にアプリ名が入っていればツールが使われる。また、そのアプリのEntityが検索結果に出てきたときにも使われる（[ToolIntent](https://developer.apple.com/documentation/appintents/toolintent)）。`MemoEntity` を第6章でSpotlight索引に入れておいたことが、ここで効く。 — コード: `SetMemoPriorityIntent.swift`
3. Developer Previewは、Apple Intelligence対応デバイスのiOS・iPadOS・macOS・visionOSで動く。試せるのは、開発用プロファイルで署名して実機で動かす場合と、TestFlightの内部テスターだけ。外部テスターやApp Store版では動かない。新しいentitlementの追加や別プログラムへの参加は要らない。配布中のアプリに足すときは、型に `@available(iOS 27.3, *)` を付けて、古いOSでは使わないようにする。 — コード: `SetMemoPriorityIntent.swift`

### このセクションを終えた時点のコード

`SetMemoPriorityIntent.swift`

```swift
import AppIntents

// Developer Preview（iOS 27.3 beta）のAPIを使うので、型にavailabilityを付ける。マクロもこれを引き継ぐ
@available(iOS 27.3, *)
// .tool は AppIntentTraits の値。[.tool] と配列でも書ける。変数や計算した値は渡せない
@AppIntent(.tool)
// アプリが前面にある・Live Activityを表示中・Siriアプリの会話に出てきた、のどれかならアプリ名なしで呼ばれる
// アプリが後ろにあるときは、依頼にアプリ名があるか、MemoEntityが検索結果に出たときに呼ばれる
struct SetMemoPriorityIntent: AppIntent {
    static let title: LocalizedStringResource = "メモの優先度を変える"
    // Siriのモデルはこの説明を読んで、いつこのツールを使うかを決める。アプリを知らない人に向けて書く
    static let description = IntentDescription("メモ1件の優先度を、低・通常・高のいずれかに変更する。")

    // 何を渡せばよいかを書く
    @Parameter(title: "メモ", description: "優先度を変えたいメモ")
    var memo: MemoEntity

    // 取りうる値があれば書いておく
    @Parameter(title: "優先度", description: "変更後の優先度。低・通常・高のいずれか")
    var priority: MemoPriority

    func perform() async throws -> some IntentResult {
        try await MemoStore.shared.setPriority(priority, for: memo.id)
        return .result()
    }
}
```

## 参考: Shortcuts専用スキーマをツールにする

Shortcutsアプリでだけ使えるドメイン（Journaling・Booksなど）のスキーマは、Siriには公開されない。これらのスキーマに合わせたintentは、[AppIntent(_:schema:)](https://developer.apple.com/documentation/appintents/appintent(_:schema:)) でツールにもできる。Memoアプリには当てはまるドメインが無いので、日記アプリを例にする。

1. Journalingドメインの `createEntry` スキーマに合わせたintentを作る。`message` と `title` から書き始める。 — コード: `CreateJournalEntryIntent.swift`
2. スキーマが定める残りのプロパティ `location`・`mediaItems`・`entryDate` を足す。 — コード: `CreateJournalEntryIntent.swift`
3. `perform()` で日記を作り、作った日記のEntityを返す。この時点では Shortcutsアプリでしか使えない。 — コード: `CreateJournalEntryIntent.swift`
4. `@AppIntent(schema:)` を `@AppIntent(.tool, schema:)` に置き換える。`@AppIntent(schema:)` が付けるものは全てそのまま付き、それに加えて `ToolIntent` への準拠が付く。Siriで使えるドメイン（`.messages.sendMessage` など）のスキーマにこの書き方をするとビルドエラーになる。 — コード: `CreateJournalEntryIntent.swift`

### このセクションを終えた時点のコード

`CreateJournalEntryIntent.swift`

```swift
import AppIntents

// Journalingドメインのスキーマ。このままではShortcutsアプリでしか使えない
// .tool を足すとSiriのツールにもなる。この書き方ができるのはShortcuts専用ドメインのスキーマだけ
@AppIntent(.tool, schema: .journal.createEntry)
struct CreateJournalEntryIntent {
    // スキーマのプロパティは @Parameter を書かずに宣言する
    var message: AttributedString
    var title: String?
    var location: GeoToolbox.PlaceDescriptor?
    var mediaItems: [IntentFile]
    var entryDate: Date?

    func perform() async throws -> some ReturnsValue<JournalEntryEntity> {
        .result(value: try await JournalStore.shared.add(message: message, title: title))
    }
}
```

## Siriに値を組み立ててもらう

「優先度が高い買い物のメモを探して」のような依頼では、検索条件そのものはアプリのデータベースに存在しない。こうした値は、Siriが依頼の文から直接組み立てられるようにする（[GenerableEntity](https://developer.apple.com/documentation/appintents/generableentity)）。

1. 検索条件を表す `MemoSearch` を `TransientAppEntity` として作り、`@AppEntity(.generable)` を付ける。[AppEntity(_:)](https://developer.apple.com/documentation/appintents/appentity(_:)) マクロが `GenerableEntity` への準拠を足し、Siriはクエリを呼ばずにこの値を作れるようになる。マクロを付けられるのは `TransientAppEntity` に準拠した型だけ。 — コード: `MemoSearch.swift`
2. `.generable` は [AppEntityTraits](https://developer.apple.com/documentation/appintents/appentitytraits) の値。`AppIntentTraits` と同じく、`.generable` でも `[.generable]` でも書けて、計算した値は渡せない。スキーマに合わせた一時的なEntityをGenerableにしたいときは、`@AppEntity(schema:)` の代わりに [AppEntity(_:schema:)](https://developer.apple.com/documentation/appintents/appentity(_:schema:)) を使い、`@AppEntity(.generable, schema: ...)` と書く。 — コード: `MemoSearch.swift`
3. プロパティを `@Property` で宣言し、それぞれに `description` を付ける。Siriはこの説明を見て、依頼のどの部分をどのプロパティに入れるかを決める。Generableなエンティティのプロパティにできるのは、`String` などの値型・App Enum・別のGenerableなエンティティ・それらの配列だけで、それ以外の型はコンパイルエラーになる。優先度を配列にしているのはこのため。 — コード: `MemoSearch.swift`
4. `displayRepresentation` と、システムが値を作るための `init()` を足す。 — コード: `MemoSearch.swift`
5. `MemoSearch` を受け取るツール `FindMemosIntent` を作る。 — コード: `FindMemosIntent.swift`
6. `description` と、`MemoSearch` 型のパラメータを足す。 — コード: `FindMemosIntent.swift`
7. `perform()` で検索結果の `MemoEntity` の配列を返す。返したメモは、次に呼ぶ `SetMemoPriorityIntent` や `UpdateMemoIntent` にそのまま渡される。パラメータの型が `MemoEntity` のようにアプリが持つEntityなら、Siriは組み立てずに `MemoQuery` で探す。 — コード: `FindMemosIntent.swift`

### このセクションを終えた時点のコード

`MemoSearch.swift`

```swift
import AppIntents

// Siriが依頼の文から直接組み立てる検索条件。クエリで探さずに値を作れる
// .generable は AppEntityTraits の値。[.generable] と配列でも書ける。変数や計算した値は渡せない
// スキーマに合わせた一時的なEntityなら @AppEntity(.generable, schema: ...) と書く
@AppEntity(.generable)
struct MemoSearch: TransientAppEntity {
    static let typeDisplayRepresentation: TypeDisplayRepresentation = "メモ検索"

    // Siriはこの description を見て、依頼のどの部分をどのプロパティに入れるかを決める
    @Property(title: "キーワード", description: "メモのタイトルに含まれる語")
    var keyword: String

    // 使える型は値型・AppEnum・GenerableなEntityと、それらの配列だけ
    @Property(title: "優先度", description: "絞り込む優先度。空なら全ての優先度")
    var priorities: [MemoPriority]

    var displayRepresentation: DisplayRepresentation {
        "「\(keyword)」の検索"
    }

    // システムが値を作るときに使う
    init() {}
}
```

`FindMemosIntent.swift`

```swift
import AppIntents

// 条件でメモを探すツール。スキーマに無い操作なので .tool でSiriに公開する
@AppIntent(.tool)
struct FindMemosIntent: AppIntent {
    static let title: LocalizedStringResource = "メモを探す"
    // Siriのモデルはこの説明を読んで、このツールをいつ使うかを決める
    static let description = IntentDescription("キーワードと優先度に合う未完了のメモを探す。")

    // MemoSearch はGenerableなので、Siriが依頼の文から値を組み立てて渡す
    @Parameter(title: "検索条件", description: "探したいメモの条件")
    var search: MemoSearch

    // 返したメモは、次に呼ぶツールのパラメータにそのまま渡される
    func perform() async throws -> some ReturnsValue<[MemoEntity]> {
        .result(value: try await MemoStore.shared.memos(matching: search))
    }
}
```

## 見せてよい範囲を決める

Entityの情報は、既定では認証なしでSiriやShortcutsに表示される。見られたくない値はプロパティごとに制限する（[Bringing custom actions and content to Siri](https://developer.apple.com/documentation/appintents/bringing-custom-actions-and-content-to-siri)）。

1. 鍵付きメモの本文を `@Property` で足し、`authenticationPolicy` に `.requiresLocalDeviceAuthentication` を指定する。Siriは本文を含む応答の前に端末の認証を求める。Entity全体の既定は `static let authenticationPolicy` で決め、プロパティ側で上書きする。プロパティの指定が効くのはSiriの応答だけなので、intentの結果そのものが機微な情報なら、intentの側で認証を要求する。 — コード: `MemoEntity.swift`
2. 同期用のリビジョン番号のように、アプリの外では意味が無い値には `visibility: .internal` を付ける。[IntentVisibility](https://developer.apple.com/documentation/appintents/intentvisibility) には Siri・Shortcutsにも見せる `.default` と、アプリとそのextension（ウィジェットなど）だけに見せる `.internal` がある。`.internal` を `indexingKey` や `customIndexingKey` と一緒に使うと Spotlightから見えてしまうので、併用しない。 — コード: `MemoEntity.swift`

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

    // 本文を含む応答の前に、端末の認証（Face IDなど）を求める
    @Property(title: "鍵付きメモの本文", description: "ロックしたメモの本文",
              authenticationPolicy: .requiresLocalDeviceAuthentication)
    var lockedBody: String?

    // アプリとそのextensionの中だけで使う値。Siri・Shortcutsには見せない
    @Property(title: "同期リビジョン", visibility: .internal)
    var revision: Int

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

## Siriに見せるプロパティを増やす: ComputedPropertyとDeferredProperty

保存しているプロパティだけでは、Siriが答えられる質問は限られる。「期限切れのメモは？」に答えるには、保存していない値も見せる必要がある。計算で出せる値は `@ComputedProperty`、取得に時間がかかる値は `@DeferredProperty` で公開する。

1. `@ComputedProperty` で、期限切れかどうかを返す `isOverdue` を足す。getアクセサ（必要ならsetも）を持つ計算プロパティを、Siriやショートカットが読めるEntityのプロパティにする（[ComputedProperty(title:description:authenticationPolicy:visibility:)](https://developer.apple.com/documentation/appintents/computedproperty(title:description:authenticationpolicy:visibility:))）。`@Property` と同じく `title`・`description`・`authenticationPolicy`・`visibility` を指定できる。 — コード: `MemoEntity.swift`
2. メモ本文のテキストを返す `noteText` を足し、`indexingKey: \.contentDescription` を指定する。値がSpotlightの既存の属性 `contentDescription` として索引に入り、第6章のセマンティック検索で本文が引っかかる（[ComputedProperty(…, indexingKey:)](https://developer.apple.com/documentation/appintents/computedproperty(title:description:authenticationpolicy:visibility:indexingkey:))）。キーの型 `CSSearchableItemAttributeSet` を使うので `CoreSpotlight` をimportする。 — コード: `MemoEntity.swift`
3. Spotlightに該当する属性が無い値は、`customIndexingKey` にアプリ独自のキーを渡す。ここではリスト名を `CSCustomAttributeKey` で索引に入れる（[ComputedProperty(…, customIndexingKey:)](https://developer.apple.com/documentation/appintents/computedproperty(title:description:authenticationpolicy:visibility:customindexingkey:))）。キー名は他のアプリと衝突しないよう、アプリと型の名前を含める。 — コード: `MemoEntity.swift`
4. 共有相手の名前のように、サーバーへの問い合わせが要る値は `@DeferredProperty` にし、`get async` で返す。値はSiriが必要としたときだけ取りに来る（[DeferredProperty(title:description:authenticationPolicy:visibility:)](https://developer.apple.com/documentation/appintents/deferredproperty(title:description:authenticationpolicy:visibility:))）。ここでは `authenticationPolicy` で認証も求めている。 — コード: `MemoEntity.swift`
5. `indexingKey` を付けない `@DeferredProperty` は、`IndexedEntity` を索引に入れるときに含まれない。さっきの `collaboratorNames` も索引には入らない。索引に入れたいときは [DeferredProperty(…, indexingKey:)](https://developer.apple.com/documentation/appintents/deferredproperty(title:description:authenticationpolicy:visibility:indexingkey:)) を使う。ここでは添付画像から読み取った文字を `textContent` として索引に入れる。Spotlightは索引を作るたびに値を取りに来るので、取得が重いと索引作成も遅くなる（[Making app entities available in Spotlight](https://developer.apple.com/documentation/appintents/making-app-entities-available-in-spotlight)）。 — コード: `MemoEntity.swift`

### このセクションを終えた時点のコード

`MemoEntity.swift`

```swift
import AppIntents
import CoreSpotlight

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

    // 本文を含む応答の前に、端末の認証（Face IDなど）を求める
    @Property(title: "鍵付きメモの本文", description: "ロックしたメモの本文",
              authenticationPolicy: .requiresLocalDeviceAuthentication)
    var lockedBody: String?

    // アプリとそのextensionの中だけで使う値。Siri・Shortcutsには見せない
    @Property(title: "同期リビジョン", visibility: .internal)
    var revision: Int

    // 保存していない値を、計算してSiriに見せる
    @ComputedProperty(title: "期限切れ", description: "期限を過ぎていて、まだ完了していなければtrue")
    var isOverdue: Bool {
        !isCompleted && (dueDate?.date.map { $0 < .now } ?? false)
    }

    // 本文をSpotlightの contentDescription として索引に入れる
    @ComputedProperty(title: "本文", description: "メモの本文のテキスト", indexingKey: \.contentDescription)
    var noteText: String {
        note.map { String($0.characters) } ?? ""
    }

    // Spotlightに当てはまる属性が無いので、アプリ独自のキーで索引に入れる
    @ComputedProperty(title: "リスト名", description: "メモが入っているリストの名前",
                      customIndexingKey: CSCustomAttributeKey(keyName: "com_akidon0000_SiriAIPrototype_MemoEntity_listName")!)
    var listName: String {
        list.name
    }

    // サーバーへの問い合わせが要る値。Siriが必要としたときだけ取りに来る
    // indexingKey が無いので、Spotlightの索引には入らない
    @DeferredProperty(title: "共有相手", description: "このメモを共有している人の名前", authenticationPolicy: .requiresAuthentication)
    var collaboratorNames: [String] {
        get async {
            await MemoStore.shared.displayNames(for: sharedWith)
        }
    }

    // indexingKey を付けると索引に入る。索引を作るたびに取りに来るので、すぐ返せる値にする
    @DeferredProperty(title: "添付の文字", description: "添付した画像から読み取った文字", indexingKey: \.textContent)
    var attachmentText: String {
        get async {
            await MemoStore.shared.recognizedText(for: id)
        }
    }

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

## Siriにカスタムの内容を見つけてもらう

ツールを作っても、Siriがパラメータに入れるEntityを見つけられなければ使われない。[Bringing custom actions and content to Siri](https://developer.apple.com/documentation/appintents/bringing-custom-actions-and-content-to-siri) は、カスタムの操作とデータをSiriに届けるための準備として、次の点を挙げている。使うAPIはどれも以前からあるもので、Developer Previewのツールからもそのまま効く。

1. Entityを見つけられるようにする。第6章のSpotlight索引に入れるのが基本になる。索引に入れないEntityは、件数が少なければ `EnumerableEntityQuery` で全件を返せばよい。第5章で用意した `MemoListQuery` を、`allEntities()` で全てのリストを返すクエリにする。 — コード: `MemoListQuery.swift`
2. `EnumerableEntityQuery` も `EntityQuery` の一種なので、IDからリストを返す `entities(for:)` も書く。 — コード: `MemoListQuery.swift`
3. もう1つの方法は、パラメータに `DynamicOptionsProvider` で選択肢を出すこと。`results()` が返したメモの中から、Siriはパラメータの値を選べる。使う側の `@Parameter` には `optionsProvider:` でこの型を渡す。 — コード: `PinnedMemosOptionsProvider.swift`
4. 第6章の画面の注釈とdonationは、スキーマに合わせていないカスタムのEntityやintentにもそのまま使える。「このメモ」のような指示語や、あいまいな依頼の解釈に効く。まず `MemoListModel` に、画面の優先度メニューから呼ぶ処理を足す。 — コード: `MemoListModel.swift`
5. 第6章の `CreateMemoIntent` と同じように、ツールの `SetMemoPriorityIntent` を組み立ててdonateする。渡す結果が無いので、`result:` を省いた `donate(intent:)` を使う。 — コード: `MemoListModel.swift`
6. あるアプリのEntityを別のアプリへ渡すには、Entityを `Transferable` に準拠させておく（第6章）。「このメモをメールで送って」は、Memoアプリの `MemoEntity` がメールアプリで読める形に変換できて初めて成り立つ。 — コード: `MemoEntity+Transferable.swift`

### このセクションを終えた時点のコード

`MemoListQuery.swift`

```swift
import AppIntents

// リストは数が少ないので、Spotlightの索引に入れずに全件を返す
// EnumerableEntityQuery にすると、Siriはこの全件の中からリストを見つけられる
struct MemoListQuery: EnumerableEntityQuery {
    func allEntities() async throws -> [MemoListEntity] {
        try await MemoStore.shared.allLists()
    }

    // EntityQuery としての、IDからリストを返す処理も要る
    func entities(for identifiers: [MemoListEntity.ID]) async throws -> [MemoListEntity] {
        try await MemoStore.shared.lists(for: identifiers)
    }
}
```

`PinnedMemosOptionsProvider.swift`

```swift
import AppIntents

// パラメータに選択肢を出す。索引に入れていないEntityも、Siriはこの選択肢から見つけられる
// 使う側: @Parameter(title: "メモ", optionsProvider: PinnedMemosOptionsProvider()) var memo: MemoEntity
struct PinnedMemosOptionsProvider: DynamicOptionsProvider {
    func results() async throws -> [MemoEntity] {
        try await MemoStore.shared.pinnedMemos()
    }
}
```

`MemoListModel.swift`

```swift
import AppIntents

@MainActor
final class MemoListModel {
    func addMemoFromUI(title: String, list: MemoListEntity) async throws {
        let memo = try await MemoStore.shared.add(title: title, list: list, dueDate: nil)

        // 実際に人が行った操作だけをdonateする。実際より多いと、システムはこのアプリのdonationを無視する
        // パラメータはなるべく埋める。ただし予測に使ってほしくない値（本文など）は入れない
        // Siri経由の操作はiOSが記録するが、画面を直接触った操作は見えない。保存が成功したあとに、アプリから報告する
        // 同じ操作に当たるintentを組み立てる。システムはこれを実行せず、記録して学習に使う
        // 毎朝メモを追加する人なら、その時間帯にロック画面やショートカットの候補に出ることがある
        var intent = CreateMemoIntent()
        intent.title = title
        intent.list = list
        try await IntentDonationManager.shared.donate(intent: intent, result: .result(value: memo))
    }

    func setPriorityFromUI(_ memo: MemoEntity, to priority: MemoPriority) async throws {
        try await MemoStore.shared.setPriority(priority, for: memo.id)

        // スキーマに合わせていないツールのintentも、同じようにdonateできる
        var intent = SetMemoPriorityIntent()
        intent.memo = memo
        intent.priority = priority
        try await IntentDonationManager.shared.donate(intent: intent)
    }
}
```

`MemoEntity+Transferable.swift`

```swift
import AppIntents
import CoreTransferable

// Transferable にすると、Siriが他のアプリへメモを渡せる
// 「このメモをメールで送って」は、この変換でメモがメールアプリに渡って初めて成り立つ
extension MemoEntity: Transferable {
    static var transferRepresentation: some TransferRepresentation {
        // 文字列として渡す。受け取る側のアプリが読める形を選ぶ
        ProxyRepresentation(exporting: \.title)
    }
}
```

## 複数のツールを使う手順を教える: app skill

1つのツールは1つの操作しかしない。「溜まったメモを整理して」のような依頼では、探す・完了にする・優先度を変えるを組み合わせる必要があるが、個々のツールの説明だけでは Siriが組み合わせ方を判断できないことがある。そこで、追加の指示をapp skillとして渡す（[Orchestrating complex actions with app skills](https://developer.apple.com/documentation/appintents/orchestrating-complex-actions-with-app-skills)）。形式は `name` と `description` のfrontmatterとMarkdownの本文で、Claude Codeの `.claude/skills/*/SKILL.md` と同じ形をしている。

1. Xcodeの File > New > File from Template で Skills Bundle を選び、名前は `Skills` のまま、アプリのターゲットに追加する。1つのスキルにつきフォルダを1つ作り、中に `SKILL.md` だけを置く。アプリのターゲットに置ける `.skillsbundle` は1つだけで、Copy Bundle Resourcesに入っていないとSiriに渡らない。`.skillsbundle` を知っているのは27.3 beta以降のXcodeだけ。ビルドすると `Metadata.appintents/Skills.skillsc` ができ、これがSiriに渡るスキルになる。27.1のXcodeは `SKILL.md` をアプリ直下に平らにコピーするだけで、スキルを2つ置くと `Multiple commands produce '…/SKILL.md'` でビルドが落ちる。 — コード: `Skills.skillsbundle`
2. frontmatterに `name` と `description` を書く。`name` は小文字・数字・ハイフンの1〜64文字で、フォルダ名と一致させる。`description` は1行・1024文字以内。Siriはまず `description` だけを読んで、このスキルを使うかどうかを決める。 — コード: `memo-triage/SKILL.md`
3. 本文に手順を書く（10,000文字まで）。intentは `SetMemoPriorityIntent` のような型名ではなく、「優先度を変えるツール」のように役割で呼ぶ。titleやdescriptionなど、コードに既に書いてあることは繰り返さない。 — コード: `memo-triage/SKILL.md`
4. やってはいけないことも書ける。ただしapp skillは決まった順で実行させる仕組みではない。Siriが判断に使う追加情報で、書いた通りの順に必ずツールが呼ばれるわけではない。動作の確認は、シミュレータではなく実機かTestFlightの内部テストで行う。 — コード: `memo-triage/SKILL.md`

### このセクションを終えた時点のコード

`Skills.skillsbundle`

```
Skills.skillsbundle/
└── Skills/
    └── memo-triage/
        └── SKILL.md
```

`memo-triage/SKILL.md`

```markdown
---
name: memo-triage
description: 溜まった未完了のメモを整理したいと頼まれたときに使う。優先度の見直しと完了処理を順に進める。
---
まずメモを探すツールで未完了のメモを集める。件数が多いときは、
優先度が高いものから3件ずつ読み上げ、それぞれ完了にするか、優先度を変えるかを聞く。
完了にすると言われたらメモの更新で完了状態にし、優先度を変えると言われたら
優先度を変えるツールを使う。

この整理の流れの中では、メモの削除を提案しない。
削除してほしいと明示されたときだけ削除する。
```

## Siri Integration Advisor

Developer PreviewのXcodeには、App Intentsの実装を読んでSiri向けの改善点を示す Siri Integration Advisorが入っている（[Bringing custom actions and content to Siri](https://developer.apple.com/documentation/appintents/bringing-custom-actions-and-content-to-siri)）。

1. Siriがアプリ独自の操作とデータを扱えるようにするための指摘と提案が出る（具体的に何を指摘するかは公式ドキュメントに一覧が無いので、実装後にXcodeで確認する）。コードを書いたら、第8章の自動テストに進む前にAdvisorの指摘を片付けておく。

## 次のステップ

スキーマに無い操作をツールにし、app skillを1つ用意してもらう。

1. 理解できたらこれをClaude Codeに貼る。実装から、ビルドと動作確認までを任せる。

### ワークショップ用プロンプト

チュートリアルのリポジトリ（akidon0000/siri-ai-tutorials）を clone した上で
Claude Code に渡すためのもの。自分のアプリで進めるときは、パスとターゲット名を読み替える。

```text
【ワークショップ】Siri AI Tutorials 第7章: Siri AI Developer Preview: ツールとapp skill

チュートリアル: https://akidon0000.github.io/siri-ai-tutorials/tutorials/appfeature/07-siri-ai-tools
リポジトリ: https://github.com/akidon0000/siri-ai-tutorials （clone済みのこのディレクトリで進める）

先に上のチュートリアルを読んで、コードの組み立て順と「なぜそう書くか」を把握する。
読めないときは ios/Library/Sources/AppFeature/AppFeature.docc/Tutorials/07-siri-ai-tools.tutorial を読む。
合わせて読む原文:
  - docs/apple-doc/apple-intelligence/siri-ai-developer-preview.md
  - docs/apple-doc/apple-intelligence/bringing-custom-actions-and-content-to-siri.md
  - docs/apple-doc/apple-intelligence/orchestrating-complex-actions-with-app-skills.md
  - docs/apple-doc/apple-intelligence/toolintent.md, intentvisibility.md, generableentity.md ほか（kind: tool のAPIページ）
チュートリアルの MemoStore は、このリポジトリでは Clients の MemoClient と ClientsLive の LiveMemoClient に当たる。

## 作る
Siri AI Developer Preview 向けに、スキーマに無い Memo の操作をツールとして公開する。

- スキーマ対応済みの CreateMemoIntent / UpdateMemoIntent / DeleteMemoIntent には @AppIntent(.tool) を付けない
- SetMemoPriorityIntent を追加して @AppIntent(.tool) を付け、title / description / 各@Parameterの description を埋める
- MemoSearch (@AppEntity(.generable), TransientAppEntity) と、それを受け取る FindMemosIntent (@AppIntent(.tool)) を追加する
- MemoEntity に鍵付き本文 (authenticationPolicy: .requiresLocalDeviceAuthentication) と
  内部用リビジョン (visibility: .internal) を足す
- MemoEntity に @ComputedProperty の isOverdue / noteText (indexingKey: \.contentDescription) /
  listName (customIndexingKey) と、@DeferredProperty の collaboratorNames を足す
- MemoEntity に indexingKey 付きの @DeferredProperty (attachmentText, \.textContent) を足す
- MemoListQuery を EnumerableEntityQuery にし、UIで優先度を変えたときに SetMemoPriorityIntent を donate する
- ツールの型には @available(iOS 27.3, *) を付ける
- アプリのターゲットに Skills.skillsbundle を追加し、Skills/memo-triage/SKILL.md を書く
- internal の property に indexingKey / customIndexingKey を組み合わせない（IntentVisibility のページにある注意）

## 動かして確かめる
1. 単体テスト: `cd ios/Library && xcodebuild test -scheme Library -destination 'platform=iOS Simulator,name=iPhone 18 Pro'`
   （シミュレータ名は `xcrun simctl list devices available` で今あるiPhoneに合わせてよい）
2. アプリをビルドしてシミュレータで起動する:
   `cd ios/App && xcodebuild build -scheme SiriAIPrototype -destination 'platform=iOS Simulator,name=iPhone 18 Pro' -derivedDataPath build`
   `xcrun simctl boot 'iPhone 18 Pro' ; open -a Simulator ; xcrun simctl install booted ios/App/build/Build/Products/Debug-iphonesimulator/SiriAIPrototype.app ; xcrun simctl launch booted com.akidon0000.SiriAIPrototype`
   起動後に `xcrun simctl io booted screenshot` で画面を撮って確認する。
3. 実機向けにもコンパイルが通ることを確かめる:
   `cd ios/App && xcodebuild build -scheme SiriAIPrototype -destination 'generic/platform=iOS' -derivedDataPath build-device CODE_SIGNING_ALLOWED=NO`
   Skills.skillsbundle の検証はビルド時に走るので、エラーが出たら SKILL.md の frontmatter（name がディレクトリ名と一致、description が1行）を直す。
4. Siri AI Developer Preview は Apple Intelligence 対応の実機（開発用署名）か TestFlight の内部テストでしか動かない。
   実機での確認（「Hey Siri、メモの優先度を高にして」など）と、XcodeのSiri Integration Advisorの指摘の確認はユーザーに頼む。
   頼む前に、確認してほしい発話と見てほしい画面を一覧にして渡す。

終わったら、次の3つに分けて報告する。
- 作ったもの（追加・変更したファイル）
- 動かして確認できたこと（実行したコマンドと結果、スクリーンショット）
- 確認できなかったこと（理由つき）。確認していないことを「動いた」と書かない
```
