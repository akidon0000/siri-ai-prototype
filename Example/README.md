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

## チュートリアルと違うところ

- **`MemoShortcuts` はアプリのターゲット（`App/App/MemoShortcuts.swift`）に置く。**
  `AppShortcutsProvider` をパッケージに置くと、パッケージ側のメタデータには入るが、アプリの `Metadata.appintents` に
  統合されるときに落ちて、App Shortcuts が1件も登録されない（Xcode 27.1 で確認）。
  そのため、フレーズから参照する `AddMemoIntent`・`CompleteMemoIntent`・`MemoEntity`・`MemoPriority` は `public` にしてある。
  `updateAppShortcutParameters()` は、アプリが `MemoStore.configure(client:onChange:)` に渡すクロージャから呼ぶ。

- **第5章のスキーマは、チュートリアルのコードだけではビルドが通らない。** Xcode 27.1 で次を指摘され、直した。
  | 指摘 | 直したこと |
  |---|---|
  | `reminders.locationTrigger` に `event` と `place` が無い | `MemoLocationTriggerEvent`（`.reminders.locationTriggerEvent`、ケースは `arrive`/`depart`）と `PlaceDescriptor` を足した |
  | `reminders.section` に `name` と `list` が無い | `MemoSectionEntity` に足した |
  | スキーマの intent に渡す Entity にクエリの準拠が足りない | `MemoListQuery`・`MemoSectionQuery` を `EntityStringQuery` にし、`MemoLocationTriggerEntity` を `TransientAppEntity` にした |
  | マクロが付いた Entity の `init` で `used before being initialized` | スキーマ外の保存プロパティ（`id`・`sharedWith`）を先に代入する |
- **`ActivateConversationIntent`（`.assistant.activate`）は入れていない。** entitlement の申請が要り、ワークショップの作るものにも入っていないため。

- **第6章のビジュアルインテリジェンス（`MemoVisualSearchQuery`・`ShowMemoSearchResultsIntent`）は `#if canImport(VisualIntelligence)` で囲む。**
  VisualIntelligence は実機の SDK にだけあり、シミュレータの SDK には無い。実機向けビルド（`-destination 'generic/platform=iOS'`）でだけ入る。
  `semanticContent` の型は、27.1 の SDK にある `SemanticContentDescriptor` にした。
- **`MemoQuery.displayRepresentations(for:)` は `requestedComponents` を取らない。** 27.1 の SDK にはこの形しか無い。
- **Spotlight の索引は `MemoStore` が追加・更新・削除のたびに更新する。** テストでは `MemoStore.configure(indexer:)` で記録用の実装に差し替える。

- **第7章は、27.1 にある API と 27.3 beta にしか無い API を分けた。**
  `@ComputedProperty(title:)`・`@DeferredProperty(title:indexingKey:)`・`EnumerableEntityQuery` は 27.1 にあるのでそのまま使う。
  `description:`・`authenticationPolicy:`・`visibility:` を取る形と `@AppIntent(.tool)`・`@AppEntity(.generable)` は 27.3 beta にしか無いので、
  属性だけを `#if SIRI_AI_PREVIEW` で切り替える。27.1 では `SetMemoPriorityIntent` は普通の AppIntent として Shortcuts に出る。
  認証を求められない 27.1 では、`lockedBody` と `collaboratorNames` を Siri に見せない。
- **`attachmentText` に `\.textContent` を付けると、スキーマの `note` と索引のキーが重なるという警告が出る。**
  チュートリアルの指示どおりに書いた結果なので、警告は残している。チュートリアル側で別のキーにするか検討が要る。
- **Xcode 27.1 は `.skillsbundle` を知らないので、中の `SKILL.md` がアプリ直下に平らにコピーされる。**
  スキルを2つ置くと `Multiple commands produce '…/SKILL.md'` でビルドが落ちるので、27.1 では1つだけにする。
  Xcode 27.3 beta でビルドすると `Metadata.appintents/Skills.skillsc` ができる（確認済み）。
  現在のスキルは動作確認用の `memo-don`（返事の語尾を「ドン」にする）。実機で語尾が変わるかは未確認。
- **`#if SIRI_AI_PREVIEW` は `Library/Package.swift` の `siriAIPreview` で決まる。** 端末のOSやXcodeの版では変わらない。
  `true` にすると、パッケージとアプリの配布対象が 27.3 になる。Xcode 27.3 beta でビルドする必要がある。
  `CardSnippet` は `AppIntents` と `SwiftUI` の両方を import しないと見つからない。

- **第8章の `testCreateMemo` は、`images`・`tags`・`urls` に空の値を渡す。**
  `createReminder` スキーマはこの3つを必須かつ非オプショナルにしていて（オプショナルにするとビルドが落ちる）、
  渡さないと App Intents Testing が値を聞き返されて `Code=206` で失敗する。チュートリアルのテストのコードにも足す必要がある。
- **Siri Evaluations の評価は `#if canImport(SiriEvaluations)` で囲む。** 27.1 の SDK には無いので、コンパイルされない。
- **UI テストのターゲット `SiriAIPrototypeUITests` は `App/AppUITests/` にある。** 手で確かめることは [App/README.md](App/README.md) のチェックリストにまとめた。

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

```bash
cd Example/App && xcodebuild build -scheme SiriAIPrototype -destination "generic/platform=iOS" -derivedDataPath build-device CODE_SIGNING_ALLOWED=NO
```

UI テスト（App Intents Testing）まで流すときは、アプリのスキームでテストする。

```bash
cd Example/App && xcodebuild test -scheme SiriAIPrototype -destination 'platform=iOS Simulator,name=iPhone 18 Pro'
```

バンドルIDとスキーム名は `ios/` と同じにしてある（第8章のテストがバンドルIDで intent を引くため）。
同じシミュレータに入れると、`ios/` のアプリと上書きし合う。
