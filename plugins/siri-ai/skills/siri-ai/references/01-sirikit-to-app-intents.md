# 第1章: SiriKitからApp Intentsへ

所要時間の目安: 20分。公開版: https://akidon0000.github.io/siri-ai-tutorials/tutorials/appfeature/01-sirikit-to-app-intents

## SiriKitからApp Intentsへ

SiriKitで「メモを完了にする」を実装するとどれだけの手間がかかったかを実際に書いてみて、同じ操作をApp Intentsで書き直す。最後に、SiriKitのカスタムintentを使っていたアプリが既存ユーザーのショートカットを壊さずにApp Intentsへ移行する方法を押さえる。

教材: `docs/apple-doc/sirikit/sirikit.md`、[SiriKit](https://developer.apple.com/documentation/sirikit)、[CustomIntentMigratedAppIntent](https://developer.apple.com/documentation/appintents/customintentmigratedappintent)

## SiriKitのintentハンドラ

SiriKitでは、まずXcodeの `.intentdefinition` ファイルでカスタムintentのスキーマを定義する。Xcodeはそこから `CompleteMemoIntent` クラスと `CompleteMemoIntentHandling` プロトコルを生成し、開発者はIntents app extensionの中でそのプロトコルに準拠したハンドラを書く。

1. 生成された `CompleteMemoIntentHandling` に準拠するクラスを用意する。この型はアプリ本体ではなく、別ターゲットのIntents app extensionに置くのが基本だった。 — コード: `CompleteMemoIntentHandler.swift`
2. 1段階目の `resolveMemo` を書く。`intent.memo` が空なら `.needsValue()` を返し、Siriに「どのメモ？」と聞き返させる。パラメータが1つ増えるたびに、この `resolve〇〇` メソッドも1つずつ増えていく。 — コード: `CompleteMemoIntentHandler.swift`
3. 2段階目の `confirm` を書く。実行してよい状態かを確かめて `.ready` を返す。確認することが何も無くても、この段階は省略できなかった。 — コード: `CompleteMemoIntentHandler.swift`
4. 3段階目の `handle` で、ようやくメモを完了にする。結果は完了ハンドラに `CompleteMemoIntentResponse` を渡して返す。1つの操作を公開するのに、スキーマ定義・extensionターゲット・3つのメソッドが必要だった。 — コード: `CompleteMemoIntentHandler.swift`
5. さらにSiriKitでは、アプリにSiri capabilityを追加したうえで、`INPreferences.requestSiriAuthorization` でユーザーにSiriの利用許可を求める必要があった。App Intentsにはこの許可ダイアログが無い。 — コード: `SiriAuthorization.swift`

### このセクションを終えた時点のコード

`CompleteMemoIntentHandler.swift`

```swift
import Intents

// SiriKitのカスタムintentのハンドラ。Xcodeが生成したプロトコルに準拠する
class CompleteMemoIntentHandler: NSObject, CompleteMemoIntentHandling {
    // resolve: パラメータが揃っているかを確かめる。無ければ needsValue で聞き返す
    func resolveMemo(for intent: CompleteMemoIntent,
                     with completion: @escaping (MemoResolutionResult) -> Void) {
        guard let memo = intent.memo else { return completion(.needsValue()) }
        completion(.success(with: memo))
    }

    // confirm: 実行できる状態かを確かめる
    func confirm(intent: CompleteMemoIntent,
                 completion: @escaping (CompleteMemoIntentResponse) -> Void) {
        completion(CompleteMemoIntentResponse(code: .ready, userActivity: nil))
    }

    // handle: 実際に処理して、結果をレスポンスのコードで返す
    func handle(intent: CompleteMemoIntent,
                completion: @escaping (CompleteMemoIntentResponse) -> Void) {
        if let id = intent.memo?.identifier { MemoStore.shared.complete(id) }
        completion(CompleteMemoIntentResponse(code: .success, userActivity: nil))
    }
}
```

`SiriAuthorization.swift`

```swift
import Intents

// SiriKitで必要だった利用許可のダイアログ。App Intentsでは要らない
func requestSiriAccess() {
    INPreferences.requestSiriAuthorization { status in
        print("Siri:", status == .authorized ? "許可" : "未許可")
    }
}
```

## App Intentsで書き直す

同じ「メモを完了にする」をApp Intentsで書く。スキーマ定義のファイルもextensionも作らず、アプリ本体（このリポジトリなら `ios/Library` のパッケージ）に構造体を1つ置くだけでよい。

1. `AppIntent` に準拠した構造体を作り、`title` を付ける。この `title` がShortcutsアプリやSpotlightに表示される操作名になる。 — コード: `CompleteMemoIntent.swift`
2. `@Parameter` で入力を宣言する。型は第2章で作る `MemoEntity`。SiriKitの `resolveMemo` に相当する処理は書かなくてよい。値が無ければシステムが `MemoEntity` の候補を使って聞き返してくれる。 — コード: `CompleteMemoIntent.swift`
3. `perform()` に処理を書く。async/awaitで書けて、失敗は `throw` すればよい。SiriKitの `confirm` に当たる確認が必要なときは、第4章で扱う `requestConfirmation` を `perform()` の中で呼ぶ。 — コード: `CompleteMemoIntent.swift`
4. Siri・Shortcuts・Spotlightが必要とするメタデータは、ビルド時にコンパイラがこのコードから生成する。アプリをインストールした時点でShortcutsアプリに「メモを完了にする」が並び、事前の登録処理は要らない。 — コード: `CompleteMemoIntent.swift`

### このセクションを終えた時点のコード

`CompleteMemoIntent.swift`

```swift
import AppIntents

// ビルド時に、この型からSiri・Shortcuts・Spotlight用のメタデータが生成される
// インストールした時点でShortcutsアプリに「メモを完了にする」が並ぶ
struct CompleteMemoIntent: AppIntent {
    static let title: LocalizedStringResource = "メモを完了にする"

    // 値が無ければ、システムが MemoEntity の候補を出して聞き返す
    @Parameter(title: "メモ")
    var memo: MemoEntity

    func perform() async throws -> some IntentResult {
        try await MemoStore.shared.complete(memo.id)
        return .result()
    }
}
```

## 既存のSiriKitユーザーを引き継ぐ

SiriKit・Intents・IntentsUIは今もレガシーとしてサポートされているが、Apple IntelligenceやSiri AIとの統合はApp Intentsでしかできない。すでにSiriKitのカスタムintentを配布しているアプリは、ユーザーが作ったショートカットを壊さないように移行する必要がある。

1. `CustomIntentMigratedAppIntent` に準拠させ、`intentClassName` に置き換え元のSiriKitのintentクラス名を書く。これで旧intentを使った既存のショートカットと donationが、新しいApp Intentでそのまま動き続ける。 — コード: `CompleteMemoIntent.swift`
2. このリポジトリはSiriKitを一度も使っていないので、実装時にはこの移行は不要。新規アプリはApp Intentsだけで始めればよい。そのことをコメントに残しておく。 — コード: `CompleteMemoIntent.swift`

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

    func perform() async throws -> some IntentResult {
        try await MemoStore.shared.complete(memo.id)
        return .result()
    }
}
```

## 次のステップ

ここまでの内容に納得できたら、下のプロンプトをコピーしてClaude Codeに貼り付けてよい。機能は作らず、SiriKitを使わない方針の確認と、次章から実装を動かせる土台の確認だけを行う。

1. 理解できたらこれをClaude Codeに貼る。方針の確認と、ビルド・テスト・起動が通る土台づくりまでを任せる。

### ワークショップ用プロンプト

チュートリアルのリポジトリ（akidon0000/siri-ai-tutorials）を clone した上で
Claude Code に渡すためのもの。自分のアプリで進めるときは、パスとターゲット名を読み替える。

```text
【ワークショップ】Siri AI Tutorials 第1章: SiriKitからApp Intentsへ

チュートリアル: https://akidon0000.github.io/siri-ai-tutorials/tutorials/appfeature/01-sirikit-to-app-intents
リポジトリ: https://github.com/akidon0000/siri-ai-tutorials （clone済みのこのディレクトリで進める）

先に上のチュートリアルを読んで、コードの組み立て順と「なぜそう書くか」を把握する。
読めないときは ios/Library/Sources/AppFeature/AppFeature.docc/Tutorials/01-sirikit-to-app-intents.tutorial を読む。
合わせて読む原文:
チュートリアルの MemoStore は、このリポジトリでは Clients の MemoClient と ClientsLive の LiveMemoClient に当たる。

この章では機能は実装しない。SiriKitを使わない方針を確かめ、第2章からの実装を動かせる土台を作る。

## 確かめる方針
- Siri関連はApp Intentsフレームワークだけで実装する。SiriKit（Intents / IntentsUI / .intentdefinition）は使わない
- SiriKitからの移行（CustomIntentMigratedAppIntent）は、このリポジトリがSiriKitを一度も使っていないので不要
- 上の2点がチュートリアルの内容と合っているか、読んだ上で自分の言葉で説明する

## 動かして確かめる
1. `grep -rn "import Intents\|\.intentdefinition" ios/` で、SiriKit関連が1件も無いことを確かめる
2. 単体テスト: `cd ios/Library && xcodebuild test -scheme Library -destination 'platform=iOS Simulator,name=iPhone 18 Pro'`
3. アプリをビルドしてシミュレータで起動し、画面を撮る:
   `cd ios/App && xcodebuild build -scheme SiriAIPrototype -destination 'platform=iOS Simulator,name=iPhone 18 Pro' -derivedDataPath build`
   `xcrun simctl boot 'iPhone 18 Pro' ; open -a Simulator ; xcrun simctl install booted ios/App/build/Build/Products/Debug-iphonesimulator/SiriAIPrototype.app ; xcrun simctl launch booted com.akidon0000.SiriAIPrototype`
   （シミュレータ名は `xcrun simctl list devices available` で今あるiPhoneに合わせてよい）
4. ios/Library/Sources/Clients/MemoClient.swift の TODO を一覧にして、第2章で実装するものを整理する

ビルドかテストが通らないときは、原因を直してからもう一度流す。直せないなら、エラーをそのまま報告する。

終わったら、次の3つに分けて報告する。
- 作ったもの（追加・変更したファイル）
- 動かして確認できたこと（実行したコマンドと結果、スクリーンショット）
- 確認できなかったこと（理由つき）。確認していないことを「動いた」と書かない
```
