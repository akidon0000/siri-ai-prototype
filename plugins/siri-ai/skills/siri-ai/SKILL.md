---
name: siri-ai
description: iOS アプリを Siri・Shortcuts・Spotlight・Apple Intelligence・Siri AI Developer Preview（iOS 27.3 beta）に対応させる実装ガイド。siri-ai-tutorials の全8章（SiriKit からの移行、App Entity・Entity Query・App Enum・App Intent、App Shortcuts、会話と確認とスニペット、App schema domains、Spotlight 索引・画面注釈・donation・Transferable・ビジュアルインテリジェンス、@AppIntent(.tool)・GenerableEntity・app skill、App Intents Testing・Siri Evaluations）の本文とコードを持つ。Siri、SiriKit、App Intents、AppIntent、AppEntity、EntityQuery、AppShortcutsProvider、SiriTipView、IntentDialog、requestConfirmation、SnippetIntent、スキーマ、@AppIntent(schema:)、IndexedEntity、IntentDonationManager、Siri AI、ToolIntent、@AppIntent(.tool)、app skill、Skills.skillsbundle、Siri Integration Advisor、Siri Evaluations のどれかに触れたら使う。
---

# Siri AI 実装ガイド

[siri-ai-tutorials](https://akidon0000.github.io/siri-ai-tutorials/tutorials/) の全8章を、エージェントが実装の判断に使える形にしたもの。
題材は Memo アプリ（タイトル・完了状態・優先度を持つメモ）で、`MemoStore` はアプリ側の保存層を指す仮の名前。
自分のアプリに当てはめるときは、型名と保存層を読み替える。

## 使い方

1. 依頼の内容から、下の「章の見取り図」で該当する章を選ぶ。複数の章にまたがるなら全部読む。
2. `references/<章>.md` を読む。章ごとに、導入・セクションの説明・ステップごとの「なぜそう書くか」・
   セクションを終えた時点のコード・章末のワークショップ用プロンプトが入っている。
3. 完成形のコードが欲しいときは `references/code/` を読む。全章を終えた時点の各ファイルが1つずつある。
   `MemoTriageSkill.txt` は app skill の `memo-triage/SKILL.md`、`SkillsBundle.txt` は `Skills.skillsbundle` の中身を表す。
4. 実装したら第8章の手順で確かめる。確かめていないことを「動いた」と報告しない。

本文中の `docs/apple-doc/...` はチュートリアルのリポジトリに保存した Apple の原文を指す。手元に無ければ、
同じ箇所に並んでいる developer.apple.com の URL を読む。iOS 27.3 beta の API は正式版までに名前や挙動が変わることがあるので、
第7章と第8章の Siri Evaluations を使う前に公式ドキュメントで現状を確かめる。

## 章の見取り図

| 章 | 読むとき | 主な API | ファイル |
|---|---|---|---|
| 1 | SiriKit のカスタム intent を使っている、または新規で何から始めるか決めたい | SiriKit の resolve・confirm・handle、`INPreferences`、`AppIntent`、`CustomIntentMigratedAppIntent` | `references/01-sirikit-to-app-intents.md` |
| 2 | データと操作をシステムに公開する | `AppEntity`、`EntityQuery`、`EntityStringQuery`、`AppEnum`、`@Parameter`、`parameterSummary` | `references/02-app-intents-basics.md` |
| 3 | 話しかけるフレーズを登録する、アプリ内でフレーズを案内する | `AppShortcutsProvider`、`AppShortcut`、`updateAppShortcutParameters()`、`SiriTipView`、`ShortcutsLink` | `references/03-app-shortcuts.md` |
| 4 | 応答文・聞き返し・実行前の確認・結果の表示を作る | `IntentDialog`、`requestValueDialog`、`requestConfirmation`、`OwnershipProvidingEntity`、`ShowsSnippetView`、`SnippetIntent`、`SnippetRepresentableEntity` | `references/04-siri-conversation.md` |
| 5 | Apple Intelligence に操作を載せる（スキーマに合わせる） | `@AppEntity(schema:)`、`@AppIntent(schema:)`、`.reminders.*`、`.system.searchInApp`、`.system.open`、`isAssistantOnly`、`.assistant.activate` | `references/05-app-schemas.md` |
| 6 | 「どのデータの話か」を Siri に伝える | `IndexedEntity`、`CSSearchableIndex`、`appEntityIdentifier`、`NSUserActivity`、`IntentDonationManager`、`PredictableIntent`、`Transferable`、`IntentValueQuery` | `references/06-apple-intelligence-context.md` |
| 7 | スキーマに無い操作を Siri AI に使わせる（iOS 27.3 beta） | `@AppIntent(.tool)`、`ToolIntent`、`@AppEntity(.generable)`、`authenticationPolicy`、`visibility`、`@ComputedProperty`、`@DeferredProperty`、`EnumerableEntityQuery`、`DynamicOptionsProvider`、app skill、Siri Integration Advisor | `references/07-siri-ai-tools.md` |
| 8 | 実装を確かめる | App Intents Testing（`IntentDefinitions`）、Shortcuts と Spotlight での手動確認、Siri Evaluations（iOS 27.3 beta） | `references/08-verification.md` |

## どの仕組みで公開するか

```text
新しく作る操作
├─ SiriKit のカスタム intent を配布済み → CustomIntentMigratedAppIntent で移行（第1章）
├─ App schema domains に合うドメインがある → スキーマに合わせる（第5章）
│    └─ 配布済みの intent がスキーマと合わない → 書き換えず、スキーマ対応の intent を別に作り isAssistantOnly = true
├─ 合うドメインが無い／スキーマに無い操作
│    ├─ 1文で頼めて、その文からパラメータが埋まる → @AppIntent(.tool)（第7章、iOS 27.3 beta）
│    └─ 設定用・ショートカットの途中の1手順・人が明示的に始めるべき副作用 → ツールにしない
└─ どの場合も: フレーズは App Shortcuts（第3章）、文脈は Spotlight 索引・注釈・donation（第6章）
```

## 間違えやすい点

チュートリアル全体から、ビルドエラーや「静かに壊れる」原因になるものを抜き出した。詳しい理由は各章にある。

- フレーズには必ず `\(.applicationName)` を入れる。フレーズに埋め込めるのは `AppEnum` か `AppEntity` のパラメータだけで、`String` は入らない（第3章）。
- Entity を埋め込んだフレーズは、Entity が増減したら `updateAppShortcutParameters()` を呼ばないと聞き取れない（第3章）。
- `full` のダイアログは画面が無くても伝わる文にする。応答にアプリ名・冗談・広告を入れない。エラーは状況に即した文にする（第4章、HIG）。
- `SnippetIntent` の `perform()` はボタンのたびに呼び直される。毎回最新を読み直し、副作用を持たせない（第4章）。
- Siri AI 経由ではダイアログやスニペットが出ないことがある。データを見せたいなら Entity を `SnippetRepresentableEntity` にする（第4章）。
- スキーマの必須プロパティは名前も型もスキーマ通りにする（例: `isDone` ではなく `isCompleted`）。対応しない機能も、プロパティは用意して `nil` や空を返す（第5章）。
- 配布済みの intent をスキーマに合わせて書き換えると、利用者のショートカットが壊れる（第5章）。
- Siri で使えるドメインのスキーマに合わせた intent に `.tool` を付けるとビルドエラー。Shortcuts 専用ドメインだけ `@AppIntent(.tool, schema:)` にできる（第7章）。
- Spotlight 索引からメモを消し忘れると、Siri が存在しないデータを見つける。索引は名前付きの `CSSearchableIndex` を使い、確認は実機で行う（第6章）。
- donation は人が実際に行った操作だけ。実際より多く donate すると、システムがそのアプリの donation を無視する（第6章）。
- `TransientAppEntity` は永続 ID を持たないので、通知や画面の注釈に使えない（第6章）。
- `@AppEntity(.generable)` のプロパティにできるのは値型・App Enum・別の Generable な Entity・それらの配列だけ（第7章）。
- `visibility: .internal` と `indexingKey`／`customIndexingKey` を併用すると Spotlight から見えてしまう（第7章）。
- `indexingKey` を付けない `@DeferredProperty` は索引に入らない（第7章）。
- app skill はアプリのターゲットに `.skillsbundle` を1つだけ置き、1スキル1フォルダに `SKILL.md` だけを入れる。`name` はフォルダ名と一致させた小文字・数字・ハイフンの1〜64文字、`description` は1行1024文字以内、本文は10,000文字まで。ツールは型名ではなく役割で呼ぶ（第7章）。
- Siri AI Developer Preview は Apple Intelligence 対応の実機（開発用署名）と TestFlight の内部テスターでしか動かない。配布中のアプリでは型に `@available(iOS 27.3, *)` を付ける（第7章）。
- `CardSnippet` は `AppIntents` と `SwiftUI` の両方を import しないと見つからない（第4章）。
- `.skillsbundle` は27.3 beta以降のXcodeだけが `Skills.skillsc` にコンパイルする。27.1のXcodeは `SKILL.md` を平らにコピーし、スキルが2つあるとビルドが落ちる（第7章）。
- 27.3 beta にしか無いAPIを `#if SIRI_AI_PREVIEW` で囲むとき、このフラグはパッケージの設定で決まり、端末のOSやXcodeの版では変わらない。有効にするなら、パッケージとアプリの配布対象も27.3にする（第7章）。
- App Intents Testing のテストはアプリの型を import せず名前で引くので、UI テストのターゲットに置く。テスト用 intent は `#if DEBUG` と `isDiscoverable = false` で隠す（第8章）。
- Siri Evaluations の `Calls` は起きた呼び出ししか見ない。呼ばれてはいけない操作は `Calls(.disallowed)` で明示する（第8章）。

## 実装を頼まれたとき

章末の「ワークショップ用プロンプト」は、チュートリアルのリポジトリで Claude Code に実装させるための指示で、
「作る」の箇条書きがその章の完了条件、「動かして確かめる」がその確認手順になっている。自分のアプリで進めるときも、
この2つを完了条件と確認手順として使い、パス・スキーム名・シミュレータ名だけを読み替える。
実機でしか確かめられないこと（Siri への発話、Siri AI Developer Preview、Siri Integration Advisor の指摘）は、
確かめてほしい発話と見てほしい画面を一覧にしてユーザーに頼む。
