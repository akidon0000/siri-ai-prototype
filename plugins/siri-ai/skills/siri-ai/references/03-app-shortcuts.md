# 第3章: App Shortcutsでフレーズを固定する

所要時間の目安: 20分。公開版: https://akidon0000.github.io/siri-ai-tutorials/tutorials/appfeature/03-app-shortcuts

## App Shortcutsでフレーズを固定する

App Intentを作っただけでは、Siriに話しかけて呼び出せるとは限らない。`AppShortcutsProvider` で「この言い方ならこのintent」というフレーズを登録すると、アプリをインストールした直後からSiri・Spotlight・Shortcutsアプリで使えるようになる。

教材: `docs/apple-doc/shortcuts/app-shortcuts.md`、[App Shortcuts](https://developer.apple.com/documentation/appintents/app-shortcuts)、[Human Interface Guidelines: App Shortcuts](https://developer.apple.com/design/human-interface-guidelines/app-shortcuts)

## AppShortcutsProviderを書く

App Shortcutは、App Intentにタイトル・アイコン・話しかけるフレーズを組み合わせたもの。アプリ全体で `AppShortcutsProvider` に準拠した型を1つだけ用意し、そこに並べる。

1. `AppShortcutsProvider` に準拠する構造体を作る。登録処理を呼ぶ必要は無く、コンパイラがこの型を見つけてメタデータを生成する。 — コード: `MemoShortcuts.swift`
2. `appShortcuts` に最初の `AppShortcut` を書く。`intent` に呼び出すApp Intentを、`phrases` に話しかける言い方を渡す。フレーズには必ず `\(.applicationName)` を含める。アプリ名が入っていないフレーズは登録できない。 — コード: `MemoShortcuts.swift`
3. `shortTitle` と `systemImageName` を足す。ShortcutsアプリやSpotlightのタイルに、この短い名前とSF Symbolsのアイコンが表示される。 — コード: `MemoShortcuts.swift`
4. フレーズを2つに増やし、2つ目に `\(\.$priority)` を入れる。この部分には `AddMemoIntent` の `priority` パラメータの値（低・通常・高）が当てはまる。フレーズに埋め込めるのは `AppEnum` か `AppEntity` 型のパラメータだけで、`title` のような `String` は入れられない。タイトルは実行後にSiriが聞き返す。 — コード: `MemoShortcuts.swift`
5. 第1章の `CompleteMemoIntent` 用のショートカットを足す。`\(\.$memo)` は `MemoEntity` 型なので、「牛乳を買うを完了にして」のように、メモのタイトルそのものをフレーズの一部として言える。 — コード: `MemoShortcuts.swift`
6. `shortcutTileColor` でShortcutsアプリ上のタイルの色を決める。 — コード: `MemoShortcuts.swift`
7. `\(\.$memo)` のようにEntityを埋め込んだフレーズは、システムがメモのタイトル一覧をあらかじめ知っていないと聞き取れない。メモが増減したら `updateAppShortcutParameters()` を呼び、`suggestedEntities()` の結果を読み直してもらう。 — コード: `MemoStore+Shortcuts.swift`
8. 逆に「この言い方ではこのアプリを起動しないでほしい」フレーズは、`AppShortcutsProvider` の `negativePhrases` に登録できる。Appleは、ローカライズされたフレーズや表示名を匿名化してモデルの学習に使う場合があると明記しているので、実際に人が口にする自然な言い方を選ぶ。 — コード: `MemoShortcuts.swift`

### このセクションを終えた時点のコード

`MemoShortcuts.swift`

```swift
import AppIntents

// コンパイラがこの型を見つけて登録する。登録処理を呼ぶ必要は無い
struct MemoShortcuts: AppShortcutsProvider {
    static var appShortcuts: [AppShortcut] {
        AppShortcut(
            intent: AddMemoIntent(),
            // フレーズには必ず \(.applicationName) を入れる
            // \(\.$priority) には優先度（低・通常・高）が入る。String型のパラメータは埋め込めない
            phrases: [
                "\(.applicationName)にメモを追加して",
                "\(.applicationName)に優先度\(\.$priority)のメモを追加",
            ],
            shortTitle: "メモを追加",
            systemImageName: "note.text.badge.plus"
        )

        AppShortcut(
            intent: CompleteMemoIntent(),
            // MemoEntity を埋め込むと、メモのタイトルそのものをフレーズの一部として言える
            phrases: ["\(.applicationName)で\(\.$memo)を完了にして"],
            shortTitle: "メモを完了",
            systemImageName: "checkmark.circle"
        )
    }

    static let shortcutTileColor: ShortcutTileColor = .orange

    // この言い方ではアプリを起動しない、というフレーズ
    static var negativePhrases: NegativeAppShortcutPhrases {
        NegativeAppShortcutPhrases(phrases: [
            "\(.applicationName)の使い方を教えて",
        ])
    }
}
```

`MemoStore+Shortcuts.swift`

```swift
import AppIntents

extension MemoStore {
    func memosDidChange() {
        // フレーズの \(\.$memo) に入るタイトルの一覧を、suggestedEntities() から読み直してもらう
        MemoShortcuts.updateAppShortcutParameters()
    }
}
```

## アプリの中でフレーズを教える

Shortcutsアプリはフレーズを自動で見つけるが、アプリを使っている人がそれを知る機会は少ない。アプリの画面にヒントを出しておく。

1. メモ一覧の下に置くビューを作る。 — コード: `MemoListFooter.swift`
2. `SiriTipView` に対象のintentを渡すと、そのintentに登録したフレーズが「Siriに〜と話しかけてみてください」というヒントとして表示される。 — コード: `MemoListFooter.swift`
3. `VStack` で並べて `ShortcutsLink` を足す。タップすると、Shortcutsアプリでこのアプリのショートカット一覧が開く。 — コード: `MemoListFooter.swift`
4. App ShortcutはiPhoneやApple Watchのアクションボタンにも割り当てられる。アクションボタンから押されたときは画面を見ていないこともあるので、第4章で作る音声の応答だけで結果が伝わるようにしておく。 — コード: `MemoShortcuts.swift`

### このセクションを終えた時点のコード

`MemoListFooter.swift`

```swift
import AppIntents
import SwiftUI

struct MemoListFooter: View {
    var body: some View {
        VStack {
            // AddMemoIntent に登録したフレーズを「Siriに〜と話しかけてみてください」と表示する
            SiriTipView(intent: AddMemoIntent())
            // タップすると、Shortcutsアプリでこのアプリのショートカット一覧が開く
            ShortcutsLink()
        }
    }
}
```

`MemoShortcuts.swift`

```swift
import AppIntents

// コンパイラがこの型を見つけて登録する。登録処理を呼ぶ必要は無い
struct MemoShortcuts: AppShortcutsProvider {
    static var appShortcuts: [AppShortcut] {
        // アクションボタンにも割り当てられる。画面を見ずに押されても伝わる応答にしておく（第4章）
        AppShortcut(
            intent: AddMemoIntent(),
            // フレーズには必ず \(.applicationName) を入れる
            // \(\.$priority) には優先度（低・通常・高）が入る。String型のパラメータは埋め込めない
            phrases: [
                "\(.applicationName)にメモを追加して",
                "\(.applicationName)に優先度\(\.$priority)のメモを追加",
            ],
            shortTitle: "メモを追加",
            systemImageName: "note.text.badge.plus"
        )

        AppShortcut(
            intent: CompleteMemoIntent(),
            // MemoEntity を埋め込むと、メモのタイトルそのものをフレーズの一部として言える
            phrases: ["\(.applicationName)で\(\.$memo)を完了にして"],
            shortTitle: "メモを完了",
            systemImageName: "checkmark.circle"
        )
    }

    static let shortcutTileColor: ShortcutTileColor = .orange

    // この言い方ではアプリを起動しない、というフレーズ
    static var negativePhrases: NegativeAppShortcutPhrases {
        NegativeAppShortcutPhrases(phrases: [
            "\(.applicationName)の使い方を教えて",
        ])
    }
}
```

## 次のステップ

第2章で作ったIntentに、フレーズ・アイコン・タイルの色を設定してもらう。

1. 理解できたらこれをClaude Codeに貼る。実装から、ビルドと動作確認までを任せる。

### ワークショップ用プロンプト

チュートリアルのリポジトリ（akidon0000/siri-ai-tutorials）を clone した上で
Claude Code に渡すためのもの。自分のアプリで進めるときは、パスとターゲット名を読み替える。

```text
【ワークショップ】Siri AI Tutorials 第3章: App Shortcutsでフレーズを固定する

チュートリアル: https://akidon0000.github.io/siri-ai-tutorials/tutorials/appfeature/03-app-shortcuts
リポジトリ: https://github.com/akidon0000/siri-ai-tutorials （clone済みのこのディレクトリで進める）

先に上のチュートリアルを読んで、コードの組み立て順と「なぜそう書くか」を把握する。
読めないときは ios/Library/Sources/AppFeature/AppFeature.docc/Tutorials/03-app-shortcuts.tutorial を読む。
合わせて読む原文:
  - docs/apple-doc/shortcuts/app-shortcuts.md
チュートリアルの MemoStore は、このリポジトリでは Clients の MemoClient と ClientsLive の LiveMemoClient に当たる。

## 作る
第2章で作った AddMemoIntent / CompleteMemoIntent に App Shortcuts を追加する。

- AppFeature に MemoShortcuts: AppShortcutsProvider を追加する
- フレーズには必ず \(.applicationName) を入れ、埋め込むパラメータは AppEnum / AppEntity 型だけにする
  （AddMemoIntent は \(\.$priority)、CompleteMemoIntent は \(\.$memo)）
- shortTitle / systemImageName / shortcutTileColor を設定する
- メモが増減したときに MemoShortcuts.updateAppShortcutParameters() を呼ぶ
- メモ一覧の下に SiriTipView と ShortcutsLink を置く

## 動かして確かめる
1. 単体テスト: `cd ios/Library && xcodebuild test -scheme Library -destination 'platform=iOS Simulator,name=iPhone 18 Pro'`
   （シミュレータ名は `xcrun simctl list devices available` で今あるiPhoneに合わせてよい）
2. アプリをビルドしてシミュレータで起動する:
   `cd ios/App && xcodebuild build -scheme SiriAIPrototype -destination 'platform=iOS Simulator,name=iPhone 18 Pro' -derivedDataPath build`
   `xcrun simctl boot 'iPhone 18 Pro' ; open -a Simulator ; xcrun simctl install booted ios/App/build/Build/Products/Debug-iphonesimulator/SiriAIPrototype.app ; xcrun simctl launch booted com.akidon0000.SiriAIPrototype`
   起動後に `xcrun simctl io booted screenshot` で画面を撮って確認する。
3. アプリ画面に SiriTipView と ShortcutsLink が出ていることをスクリーンショットで確かめる。
4. ショートカットアプリを開き、「アプリのショートカット」にこのアプリのタイルが色とアイコンつきで出ることを確かめる。
   タイルを実行して、メモが追加されることをアプリ画面で確かめる。
   UIを操作できるツールが無ければ、この手順をユーザーに案内して結果を聞く。
5. シミュレータのSiriは音声認識が当てにならないので、フレーズの実機確認はユーザーに頼む（確認できたかを報告に書く）。

終わったら、次の3つに分けて報告する。
- 作ったもの（追加・変更したファイル）
- 動かして確認できたこと（実行したコマンドと結果、スクリーンショット）
- 確認できなかったこと（理由つき）。確認していないことを「動いた」と書かない
```
