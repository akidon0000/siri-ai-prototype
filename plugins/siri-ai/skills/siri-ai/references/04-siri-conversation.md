# 第4章: Siriとの会話を設計する

所要時間の目安: 35分。公開版: https://akidon0000.github.io/siri-ai-tutorials/tutorials/appfeature/04-siri-conversation

## Siriとの会話を設計する

intentが動いても、Siriの返事が素っ気なかったり、確認なしにメモを消したりしては使ってもらえない。この章では、応答の言葉、聞き返し、実行前の確認、結果の見せ方（スニペット）を順に足し、最後にHuman Interface Guidelinesの応答文の指針を確認する。

教材: `docs/apple-doc/apple-intelligence/siri-human-interface-guidelines.md`、[Human Interface Guidelines: Siri](https://developer.apple.com/design/human-interface-guidelines/siri)、[WWDC26: Explore advanced App Intents features for Siri and Apple Intelligence](https://developer.apple.com/videos/play/wwdc2026/343/)、[Displaying static and interactive snippets](https://developer.apple.com/documentation/appintents/displaying-static-and-interactive-snippets)

## 応答を言葉で返す

何も指定しなければ、Siriはintentの結果から応答を自分で組み立てる。アプリ独自の言い回しにしたいときだけ、ダイアログを返す。

1. `perform()` の戻り値に `ProvidesDialog` を加え、`.result` に `IntentDialog` を渡す。`full` はAirPodsのように画面が無い環境で読み上げる文、`supporting` は画面と一緒に出す短い文。画面が無くても伝わるように、`full` だけで何が起きたか分かる文にする。 — コード: `AddMemoIntent.swift`

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

    func perform() async throws -> some IntentResult & ReturnsValue<MemoEntity> & ProvidesDialog {
        let memo = try await MemoStore.shared.add(title: title, priority: priority)
        // 作ったメモを返すと、ショートカットの次のアクションに渡せる
        return .result(
            value: memo,
            // full は画面が無いときに読み上げる文、supporting は画面と一緒に出す短い文
            dialog: IntentDialog(full: "「\(memo.title)」をメモに追加しました。", supporting: "追加しました")
        )
    }
}
```

## 足りない情報を聞き返す

聞き返しには2種類ある。値が無いときの決まった聞き返しと、実行中の状況に応じた聞き返し。

1. `@Parameter` に `requestValueDialog` を足す。`title` が無いまま呼ばれたとき、Siriは既定の「タイトルは？」の代わりにこの文で聞き返す。HIGにある通り「どれ？」より「どんなメモを追加しますか？」の方が答えやすい。 — コード: `AddMemoIntent.swift`
2. `perform()` の中で `$title.requestValue(_:)` を呼ぶと、実行の途中で聞き返せる。ここでは同じ名前のメモが既にあるときだけ、別の名前を聞いている。聞き返すたびに会話が1往復増えるので、本当に必要な場面に絞る。 — コード: `AddMemoIntent.swift`

### このセクションを終えた時点のコード

`AddMemoIntent.swift`

```swift
import AppIntents

struct AddMemoIntent: AppIntent {
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

    func perform() async throws -> some IntentResult & ReturnsValue<MemoEntity> & ProvidesDialog {
        // 同じ名前のメモがあれば、その場で別の名前を聞き返す
        if try await MemoStore.shared.contains(title: title) {
            title = try await $title.requestValue("同じ名前のメモがあります。別の名前にしますか？")
        }
        let memo = try await MemoStore.shared.add(title: title, priority: priority)
        // 作ったメモを返すと、ショートカットの次のアクションに渡せる
        return .result(
            value: memo,
            // full は画面が無いときに読み上げる文、supporting は画面と一緒に出す短い文
            dialog: IntentDialog(full: "「\(memo.title)」をメモに追加しました。", supporting: "追加しました")
        )
    }
}
```

## 実行前に確認する

LLMを介した操作には、意図しない副作用のリスクがある。Siriは副作用の大きいintentを自動で確認することがあるが、アプリ側からも確認を求められるし、「このデータは他人と共有されている」という判断材料を渡すこともできる。

1. メモを削除する `DeleteMemoIntent` を作る。 — コード: `DeleteMemoIntent.swift`
2. `perform()` の最初で `requestConfirmation(dialog:)` を呼ぶ。人が「はい」と答えれば次の行へ進み、取り消せば例外が投げられて、削除の処理は実行されない。 — コード: `DeleteMemoIntent.swift`
3. メモに `sharedWith`（共有相手）を足す。 — コード: `MemoEntity.swift`
4. `MemoEntity` を `OwnershipProvidingEntity` に準拠させ、共有相手がいれば `.shared` を返す。Siriは既定ではEntityを「その人だけのもの」とみなし、確認を省くことがある。共有メモを更新するときには確認を挟んでもらえるようになる。共有・公開ができないEntityには、この準拠を付けない。 — コード: `MemoEntity+Ownership.swift`

### このセクションを終えた時点のコード

`DeleteMemoIntent.swift`

```swift
import AppIntents

struct DeleteMemoIntent: AppIntent {
    static let title: LocalizedStringResource = "メモを削除"

    @Parameter(title: "メモ")
    var memo: MemoEntity

    func perform() async throws -> some IntentResult {
        // 消す前に確認する。取り消されると例外が投げられ、次の行は実行されない
        try await requestConfirmation(dialog: "「\(memo.title)」を削除しますか？")
        try await MemoStore.shared.delete(memo.id)
        return .result()
    }
}
```

`MemoEntity.swift`

```swift
import AppIntents

struct MemoEntity: AppEntity {
    // システムがこのメモを指すときに使う、変わらないID
    let id: UUID
    var title: String
    var isDone: Bool
    var sharedWith: [String]

    static let typeDisplayRepresentation: TypeDisplayRepresentation = "メモ"

    // Siriの応答・候補の一覧・Spotlightでメモ1件を表示するときの見た目
    var displayRepresentation: DisplayRepresentation {
        DisplayRepresentation(title: "\(title)")
    }

    // Siriが名前やIDからメモを探すときに使うクエリ
    static let defaultQuery = MemoQuery()
}
```

`MemoEntity+Ownership.swift`

```swift
import AppIntents

// メモが共有されているかをSiriに伝える。共有メモの更新では確認が挟まる
extension MemoEntity: OwnershipProvidingEntity {
    var ownership: EntityOwnership {
        sharedWith.isEmpty ? .unknown : .shared
    }
}
```

## 結果を見せる

Siriの画面にどう表示されるかは、Entityの `DisplayRepresentation` とスニペットで決まる。

1. 第2章ではタイトルだけだった `displayRepresentation` に、完了状態の `subtitle` と SF Symbolsの `image` を足す。この表示は応答だけでなく、候補から選ぶとき・確認のとき・ Spotlightの検索結果でも使われる。 — コード: `MemoEntity.swift`
2. スニペット用のSwiftUIビューを作り、表示するメモを受け取る。 — コード: `MemoSnippetView.swift`
3. `body` で完了状態のアイコンとタイトルを表示する。スニペットはSiriの画面の一部として出るので、アプリ本体の画面より情報を絞る。 — コード: `MemoSnippetView.swift`
4. `AddMemoIntent` の戻り値に `ShowsSnippetView` を加え、`.result` に `view:` を渡す。Siriはダイアログと一緒に、このビューをカードとして表示する。 — コード: `AddMemoIntent.swift`

### このセクションを終えた時点のコード

`MemoEntity.swift`

```swift
import AppIntents

struct MemoEntity: AppEntity {
    // システムがこのメモを指すときに使う、変わらないID
    let id: UUID
    var title: String
    var isDone: Bool
    var sharedWith: [String]

    static let typeDisplayRepresentation: TypeDisplayRepresentation = "メモ"

    // Siriの応答・候補の一覧・Spotlightでメモ1件を表示するときの見た目
    var displayRepresentation: DisplayRepresentation {
        DisplayRepresentation(
            title: "\(title)",
            subtitle: isDone ? "完了" : "未完了",
            image: .init(systemName: isDone ? "checkmark.circle.fill" : "circle")
        )
    }

    // Siriが名前やIDからメモを探すときに使うクエリ
    static let defaultQuery = MemoQuery()
}
```

`MemoSnippetView.swift`

```swift
import SwiftUI

// Siriの結果に出すビュー。アプリの画面より小さく、要点だけを見せる
struct MemoSnippetView: View {
    let memo: MemoEntity

    var body: some View {
        Label(memo.title, systemImage: memo.isDone ? "checkmark.circle.fill" : "circle")
    }
}
```

`AddMemoIntent.swift`

```swift
import AppIntents

struct AddMemoIntent: AppIntent {
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

    func perform() async throws -> some IntentResult & ReturnsValue<MemoEntity> & ProvidesDialog & ShowsSnippetView {
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
            view: MemoSnippetView(memo: memo)
        )
    }
}
```

## 押せるスニペットにする

追加したメモをその場で完了にできれば、アプリを開く必要が無くなる。ボタンを持つスニペットは `SnippetIntent` で作る。

1. スニペットのボタンから呼ぶために、第1章の `CompleteMemoIntent` にメモを受け取るイニシャライザを足す。 — コード: `CompleteMemoIntent.swift`
2. `MemoSnippetView` に `Button(_:intent:)` を足す。ウィジェットと同じく、スニペットのボタンはApp Intentを実行する。 — コード: `MemoSnippetView.swift`
3. `SnippetIntent` に準拠する `MemoSnippetIntent` を作る。 — コード: `MemoSnippetIntent.swift`
4. 表示するメモを `@Parameter` で受け取る。 — コード: `MemoSnippetIntent.swift`
5. `AddMemoIntent` から渡せるように、メモを受け取るイニシャライザを足す。 — コード: `MemoSnippetIntent.swift`
6. `perform()` でビューを返す。ボタンが押されて `CompleteMemoIntent` が終わると、システムはこの `perform()` をもう一度呼んでスニペットを描き直す。何度呼ばれてもよいように、毎回 `MemoStore` から最新のメモを読み直し、副作用は持たせない。 — コード: `MemoSnippetIntent.swift`
7. `AddMemoIntent` の戻り値を `ShowsSnippetIntent` に変え、`view:` の代わりに `snippetIntent:` を返す。`ReturnsValue<MemoEntity>` は残しているので、このintentを使った既存のショートカットは壊れない。 — コード: `AddMemoIntent.swift`

### このセクションを終えた時点のコード

`CompleteMemoIntent.swift`

```swift
import AppIntents

// ビルド時に、この型からSiri・Shortcuts・Spotlight用のメタデータが生成される
// インストールした時点でShortcutsアプリに「メモを完了にする」が並ぶ
// SiriKitの CompleteMemoIntent を置き換える。旧intentのショートカットとdonationが引き継がれる
// 新規アプリでは要らない。SiriKitから移行するときだけ準拠させる
struct CompleteMemoIntent: AppIntent, CustomIntentMigratedAppIntent {
    static let intentClassName = "CompleteMemoIntent"
    static let title: LocalizedStringResource = "メモを完了にする"

    // 値が無ければ、システムが MemoEntity の候補を出して聞き返す
    @Parameter(title: "メモ")
    var memo: MemoEntity

    // システムがintentを作るときに使う
    init() {}

    // スニペットのボタンから、対象のメモを渡して作るときに使う
    init(memo: MemoEntity) {
        self.memo = memo
    }

    func perform() async throws -> some IntentResult {
        try await MemoStore.shared.complete(memo.id)
        return .result()
    }
}
```

`MemoSnippetView.swift`

```swift
import SwiftUI

// Siriの結果に出すビュー。アプリの画面より小さく、要点だけを見せる
struct MemoSnippetView: View {
    let memo: MemoEntity

    var body: some View {
        HStack {
            Label(memo.title, systemImage: memo.isDone ? "checkmark.circle.fill" : "circle")
            // ボタンにintentを渡すと、押したときにアプリを開かずにそのintentが実行される
            Button("完了", intent: CompleteMemoIntent(memo: memo))
        }
    }
}
```

`MemoSnippetIntent.swift`

```swift
import AppIntents
import SwiftUI

// スニペットの表示を作るintent。ボタンで操作したあと、システムがもう一度 perform() を呼ぶ
struct MemoSnippetIntent: SnippetIntent {
    static let title: LocalizedStringResource = "メモのスニペット"

    @Parameter var memo: MemoEntity

    init() {}

    init(memo: MemoEntity) {
        self.memo = memo
    }

    func perform() async throws -> some IntentResult & ShowsSnippetView {
        // 呼ばれるたびに最新の状態を読み直して表示する
        let latest = try await MemoStore.shared.memo(for: memo.id)
        return .result(view: MemoSnippetView(memo: latest))
    }
}
```

`AddMemoIntent.swift`

```swift
import AppIntents

struct AddMemoIntent: AppIntent {
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

## Siri AIのカードに出す

Siri AI経由でintentが実行されたとき、システムは `IntentDialog` や `ShowsSnippetView` を表示しないことがある。Siri AIがアプリのデータを見せるときに使うのは、Entity側に用意したカード。

1. `MemoEntity` を `SnippetRepresentableEntity` に準拠させる。 — コード: `MemoEntity+Snippet.swift`
2. `snippet` で `CardSnippet` を返し、その中でこの章の `MemoSnippetView` を使い回す。カードは事前に描画されて保存され、アプリが動いていないときにも表示される。あとから内容を変えられないので、必要なデータはビューを返す前に揃えておく。ボタンは使えて、押されるとintentが実行され、カードが描き直される。 — コード: `MemoEntity+Snippet.swift`

### このセクションを終えた時点のコード

`MemoEntity+Snippet.swift`

```swift
import AppIntents

// Siri AIがメモを見せるときのカードを決める
extension MemoEntity: SnippetRepresentableEntity {
    static var snippet: some EntitySnippetContent<MemoEntity> {
        // 中身には第4章の MemoSnippetView をそのまま使う
        CardSnippet(supportedFamilies: [.standard]) { memo, _ in
            MemoSnippetView(memo: memo)
        }
    }
}
```

## 応答文の指針（HIG）

SiriのHIGは、アプリが独自の応答を返すときの書き方を定めている。ここまでのダイアログを次の観点で見直しながら、まだ応答を返していない第1章の `CompleteMemoIntent` に応答を足す。

1. 独自の応答は、Siriの組み込みの応答で足りないときだけ用意する。Siriは追加の設定なしでも多くの依頼に応答できる。`CompleteMemoIntent` は今のところ何も返していないので、Siriが結果から応答を組み立てている。 — コード: `CompleteMemoIntent.swift`
2. 短く、何が起きたかが分かる文にする。同じ応答を何度も聞くことになるので、冗談や余計な言葉は入れない。応答にアプリ名も入れない。どのアプリの応答かはシステムが表示・読み上げる。`ProvidesDialog` を足し、完了にしたメモの名前だけを伝える。 — コード: `CompleteMemoIntent.swift`
3. 音声だけでも画面だけでも伝わるようにする。特定のデバイスに依存した言い方（「この画面で」など）は避ける。依頼したデバイスと実行されるデバイスが違うことがある。`full` を音声だけで伝わる文にし、画面と一緒に出す短い文を `supporting` に分ける。 — コード: `CompleteMemoIntent.swift`
4. エラーは状況に即して伝える。「完了できませんでした」より「そのメモはもう削除されています」の方が分かる。まず、intentが投げるエラーの型を作る。`CustomLocalizedStringResourceConvertible` に準拠させると、Siriはその文を読み上げる。 — コード: `MemoIntentError.swift`
5. `localizedStringResource` で、それぞれの場合の文を返す。広告や課金の勧誘は応答に入れない。 — コード: `MemoIntentError.swift`
6. `perform()` の先頭で、メモがもう無ければこのエラーを投げる。 — コード: `CompleteMemoIntent.swift`

### このセクションを終えた時点のコード

`CompleteMemoIntent.swift`

```swift
import AppIntents

// ビルド時に、この型からSiri・Shortcuts・Spotlight用のメタデータが生成される
// インストールした時点でShortcutsアプリに「メモを完了にする」が並ぶ
// SiriKitの CompleteMemoIntent を置き換える。旧intentのショートカットとdonationが引き継がれる
// 新規アプリでは要らない。SiriKitから移行するときだけ準拠させる
struct CompleteMemoIntent: AppIntent, CustomIntentMigratedAppIntent {
    static let intentClassName = "CompleteMemoIntent"
    static let title: LocalizedStringResource = "メモを完了にする"

    // 値が無ければ、システムが MemoEntity の候補を出して聞き返す
    @Parameter(title: "メモ")
    var memo: MemoEntity

    // システムがintentを作るときに使う
    init() {}

    // スニペットのボタンから、対象のメモを渡して作るときに使う
    init(memo: MemoEntity) {
        self.memo = memo
    }

    // 独自の応答は、Siriが結果から組み立てる応答で足りないときだけ返す
    func perform() async throws -> some IntentResult & ProvidesDialog {
        // 状況が分かるエラーを投げる。「完了できませんでした」では何が起きたか分からない
        guard try await MemoStore.shared.exists(memo.id) else {
            throw MemoIntentError.memoDeleted
        }
        try await MemoStore.shared.complete(memo.id)
        // 短く、何が起きたかだけを書く。アプリ名はシステムが伝えるので入れない
        // 「この画面で」のような端末に依存する言い方はしない。full は音声だけで伝わる文にする
        return .result(dialog: IntentDialog(full: "「\(memo.title)」を完了にしました", supporting: "完了にしました"))
    }
}
```

`MemoIntentError.swift`

```swift
import AppIntents

// intentが投げるエラー。Siriはこの型の文をそのまま読み上げる
enum MemoIntentError: Error, CustomLocalizedStringResourceConvertible {
    case memoDeleted

    var localizedStringResource: LocalizedStringResource {
        switch self {
        // 何が起きたかを、その状況の言葉で伝える。広告や課金の勧誘は入れない
        case .memoDeleted: "そのメモはもう削除されています"
        }
    }
}
```

## 次のステップ

Memoのintentに、応答・聞き返し・削除の確認・スニペットを実装してもらう。

1. 理解できたらこれをClaude Codeに貼る。実装から、ビルドと動作確認までを任せる。

### ワークショップ用プロンプト

チュートリアルのリポジトリ（akidon0000/siri-ai-tutorials）を clone した上で
Claude Code に渡すためのもの。自分のアプリで進めるときは、パスとターゲット名を読み替える。

```text
【ワークショップ】Siri AI Tutorials 第4章: Siriとの会話を設計する

チュートリアル: https://akidon0000.github.io/siri-ai-tutorials/tutorials/appfeature/04-siri-conversation
リポジトリ: https://github.com/akidon0000/siri-ai-tutorials （clone済みのこのディレクトリで進める）

先に上のチュートリアルを読んで、コードの組み立て順と「なぜそう書くか」を把握する。
読めないときは ios/Library/Sources/AppFeature/AppFeature.docc/Tutorials/04-siri-conversation.tutorial を読む。
合わせて読む原文:
  - docs/apple-doc/apple-intelligence/siri-human-interface-guidelines.md
チュートリアルの MemoStore は、このリポジトリでは Clients の MemoClient と ClientsLive の LiveMemoClient に当たる。

## 作る
Memo の Intent に、Siriとの会話まわりを実装する。

- AddMemoIntent: ProvidesDialog で full / supporting の応答を返し、title に requestValueDialog を付ける
- AddMemoIntent: 同じタイトルのメモがあるときだけ $title.requestValue で別の名前を聞く
- DeleteMemoIntent を追加し、perform() の最初で requestConfirmation(dialog:) を呼ぶ
- MemoEntity に sharedWith を足し、OwnershipProvidingEntity で共有中なら .shared を返す
- MemoEntity の displayRepresentation に subtitle（完了/未完了）と image を足す
- MemoSnippetView と MemoSnippetIntent (SnippetIntent) を作り、完了ボタンで CompleteMemoIntent を実行する
- AddMemoIntent の結果に ShowsSnippetIntent を加える（ReturnsValue<MemoEntity> は残す）
- MemoEntity を SnippetRepresentableEntity に準拠させ、CardSnippet を返す（iOS 27.3 beta のAPIなので @available を付ける）
- CompleteMemoIntent に ProvidesDialog の応答を足し、メモが無いときは MemoIntentError (CustomLocalizedStringResourceConvertible) を投げる
- 応答文は上のHIGの指針に沿わせる（アプリ名を入れない、音声だけで伝わる）

## 動かして確かめる
1. 単体テスト: `cd ios/Library && xcodebuild test -scheme Library -destination 'platform=iOS Simulator,name=iPhone 18 Pro'`
   （シミュレータ名は `xcrun simctl list devices available` で今あるiPhoneに合わせてよい）
2. アプリをビルドしてシミュレータで起動する:
   `cd ios/App && xcodebuild build -scheme SiriAIPrototype -destination 'platform=iOS Simulator,name=iPhone 18 Pro' -derivedDataPath build`
   `xcrun simctl boot 'iPhone 18 Pro' ; open -a Simulator ; xcrun simctl install booted ios/App/build/Build/Products/Debug-iphonesimulator/SiriAIPrototype.app ; xcrun simctl launch booted com.akidon0000.SiriAIPrototype`
   起動後に `xcrun simctl io booted screenshot` で画面を撮って確認する。
3. ショートカットアプリで「メモを追加」を実行し、応答ダイアログとスニペットが出ることを確かめる。
   同じタイトルで2回実行して、2回目に別の名前を聞かれることも確かめる。
4. 「メモを削除」を実行して、実行前に確認が出ることを確かめる。キャンセルしたらメモが残ることもアプリ画面で見る。
   UIを操作できるツールが無ければ、この手順をユーザーに案内して結果を聞く。
5. CardSnippet は Siri AI Developer Preview の実機でしか見えない。実機が無いなら、コンパイルが通ることまでを確認として報告する。

終わったら、次の3つに分けて報告する。
- 作ったもの（追加・変更したファイル）
- 動かして確認できたこと（実行したコマンドと結果、スクリーンショット）
- 確認できなかったこと（理由つき）。確認していないことを「動いた」と書かない
```
