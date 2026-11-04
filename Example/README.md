# Example

チュートリアルの第1章から第8章までを、章末のワークショップの指示どおりに実装し終えた Memo アプリ。
自分で `ios/` に実装したものと見比べたり、詰まったときに答え合わせをしたりするために置いている。

`ios/` は実装前の土台のまま残してあり、ワークショップはそちらで進める。ここは触らなくてよい。

## 構成

`ios/` と同じ App + Library 構成にしてある。違いは DocC カタログ（`AppFeature.docc`）を持たないことと、
チュートリアルで使う API に合わせて deployment target を iOS 27.0 にしたこと（`ios/` は 18.0）。

| パス | 中身 |
|---|---|
| `App/` | SwiftUI の殻。起動時に `LiveMemoClient` を `MemoStore` に渡す |
| `Library/Sources/Clients/` | `Memo` と `MemoClient` プロトコル（App Intents に依存しない） |
| `Library/Sources/ClientsLive/` | メモリ内配列で保持する `LiveMemoClient` |
| `Library/Sources/AppFeature/` | App Intents の実装と画面。チュートリアルの `MemoStore.shared` はここにある |
| `Library/Sources/TestSupport/` | 固定データを返す `TestMemoClient` |

チュートリアルのコードは `MemoStore.shared` を直接呼ぶ。Example では `AppFeature` の `MemoStore` が
`MemoClient` を包み、`Memo` と `MemoEntity` の変換、App Shortcuts のパラメータ更新、Spotlight の索引更新をまとめて受け持つ。
intent の中身がチュートリアルのコードとほぼ同じ形になるようにするため。

## 章ごとの差分

各章は1つのPRにしてあり、前の章のPRの上に積んでいる。章の差分だけを見たいときはPRの差分を見る。

| 章 | 主な追加 |
|---|---|
| 1 | SiriKit を使わない方針の確認と、第2章で作るものの整理（機能の追加は無い） |
| 2 | `MemoClient`、`MemoEntity`、`MemoQuery`、`MemoPriority`、`AddMemoIntent`、`CompleteMemoIntent`、一覧画面 |
| 3 | `MemoShortcuts`、`SiriTipView`、`ShortcutsLink` |
| 4 | 応答ダイアログ、聞き返し、削除の確認、スニペット、`MemoIntentError` |
| 5 | Reminders ドメインのスキーマ、`CreateMemoIntent`、`UpdateMemoIntent`、`SearchMemosIntent`、`OpenMemoIntent` |
| 6 | Spotlight の索引、画面と通知の文脈、donation、ビジュアルインテリジェンス |
| 7 | ツール（`SetMemoPriorityIntent`、`FindMemosIntent`）と app skill |
| 8 | `ResetMemosIntent`、App Intents Testing の UI テスト、Siri Evaluations の評価 |

## 第1章で決めたこと

Siri 連携は App Intents だけで書き、SiriKit（Intents / IntentsUI / `.intentdefinition`）は使わない。
チュートリアルの `CompleteMemoIntent` は `CustomIntentMigratedAppIntent` に準拠しているが、
これは SiriKit のカスタムintentから移行するアプリのためのもので、SiriKit を使ったことのないこのアプリには付けない。

```bash
grep -rn --include="*.swift" "import Intents" Example/   # 1件も出ないこと
find Example -name "*.intentdefinition"                   # 1件も出ないこと
```

## iOS 27.3 beta の API

第4章の `CardSnippet`、第7章のツールと app skill、第8章の Siri Evaluations は iOS 27.3 beta の SDK にしか無い。
Xcode 27.1（iOS 27.1 SDK）でもビルドが通るように、これらのコードは `#if SIRI_AI_PREVIEW` で囲んである。

27.3 beta の SDK でビルドするときは、`Library/Package.swift` の `siriAIPreview` を `true` にする。
このフラグを有効にした状態のビルドはまだ確かめていない（手元に 27.3 beta の SDK が無いため）。

## 動かす

```bash
cd Example/Library && xcodebuild test -scheme Library -destination 'platform=iOS Simulator,name=iPhone 18 Pro'
```

```bash
cd Example/App && xcodebuild build -scheme SiriAIPrototype -destination 'platform=iOS Simulator,name=iPhone 18 Pro' -derivedDataPath build
```

バンドルIDとスキーム名は `ios/` と同じにしてある（第8章のテストがバンドルIDで intent を引くため）。
同じシミュレータに入れると、`ios/` のアプリと上書きし合う。
