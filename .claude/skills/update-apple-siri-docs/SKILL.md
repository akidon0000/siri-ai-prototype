---
name: update-apple-siri-docs
description: siri-ai-tutorials リポジトリで、Apple Developer Documentation の Siri / SiriKit / App Intents / Apple Intelligence (Siri AI) / Shortcuts 関連ページを固定した手順で検索・取得し、本文をそのまま保存してgit管理し、変更をPRにする。「Siriのドキュメントを更新して」「Appleのドキュメント差分を取って」「siri-ai-tutorialsを更新して」等で使用する。
---

# Apple Siri/Siri AI ドキュメント更新スキル

このスキルは `siri-ai-tutorials` リポジトリ専用。目的は Apple Developer Documentation の
Siri 関連ページを**毎回同じ手順**で見つけて本文をそのまま保存し、変更があった分だけ
ブランチ→コミット→PRにすること。手順を固定することで、実行者やタイミングが違っても
同じ対象・同じ形式で追跡できるようにする。

実行前に必ず [`../../../DISCLAIMER.md`](../../../DISCLAIMER.md) の方針（個人の調査・差分追跡目的、
再配布しない）を守る。

## 0. 前提

- 対象リポジトリ: `~/ghq/github.com/akidon0000/siri-ai-tutorials`（違う場所にいたら `change_directory` で移動する）
- マニフェスト: `sources.yaml`（追跡中ページの一覧）
- 保存先: `docs/apple-doc/<category>/<slug>.md`（category は `sirikit` / `app-intents` / `apple-intelligence` / `shortcuts`）。
  `docs/adr/`（意思決定の記録）や `docs/superpowers/`（設計メモ）と区別するため、Appleの原文は `docs/apple-doc/` に閉じる
- 分類（`kind`）: 各ページに `article` か `tool` を付ける。
  - `article`: 記事・概要・HIG・APIコレクションのページ（例: Bringing custom actions and content to Siri）
  - `tool`: Siri AI のツール関連のAPIリファレンス。シンボル（struct / protocol / macro）単位のページ（例: IntentVisibility, ToolIntent）

## 1. 対象ページを固定した方法で洗い出す

**毎回同じ2段階の手順**で対象ページのURL一覧を作る。思いつきでAppleのサイトを自由に
ブラウズしない。

### 1-A. ルートページからのクロール（既知カテゴリの更新チェック）

`sources.yaml` に登録済みの各カテゴリについて、次の「ルートページ」を起点に、
そのページの `Topics` セクションに載っている同一カテゴリ配下のリンク（URLが
`developer.apple.com/documentation/` または `developer.apple.com/design/human-interface-guidelines/`
配下で、かつ Siri / SiriKit / App Intents / Apple Intelligence / Shortcuts に明確に関連するもの）を
候補として列挙する。

| category | ルートページ |
|---|---|
| sirikit | `https://developer.apple.com/documentation/sirikit` |
| app-intents | `https://developer.apple.com/documentation/appintents` |
| apple-intelligence | `https://developer.apple.com/documentation/appintents/apple-intelligence-and-siri-ai`, `https://developer.apple.com/documentation/appintents/siri-ai-developer-preview`, `https://developer.apple.com/documentation/sirievaluations`, `https://developer.apple.com/design/human-interface-guidelines/siri` |
| shortcuts | `https://developer.apple.com/documentation/appintents/app-shortcuts` |

ルートページ自体は既に `sources.yaml` にあるので、新規に見つかるのは主にそこから
リンクされているサブページ（例: "Bringing custom actions and content to Siri" など）。
サブページを追加登録するかどうかは、タイトル・概要が Siri / Siri AI / Apple Intelligence /
SiriKit / Shortcuts と直接関係するかで判断する。

**APIリファレンスも対象にする（`kind: tool`）。** `siri-ai-developer-preview` の Topics にある
「Tool support」「Entity support」の各リンク（`@AppIntent`、`AppIntentTraits`、`IntentVisibility`、
`ToolIntent`、`GenerableEntity`、`@AppEntity`、`@ComputedProperty`、`@DeferredProperty`、`AppEntityTraits` など）を
候補に入れ、`kind: tool` で保存する。Topics に新しい項目が増えたら、それも同じ扱いで追加する。
Siri AI 用のフレームワーク **Siri Evaluations**（`/documentation/sirievaluations`）は、Developer Preview の Topics ではなく本文からしか
リンクされていないので、独立したルートページとして扱う。トップページは `kind: article`、その Topics にある各シンボル
（`SiriService`、`SiriScenario`、`UserTurn`、`Calls` など）は `kind: tool` で `apple-intelligence/` に保存する。
上記以外のAPIリファレンス（SiriKit の個々のクラス、`AppEntity` や `AppIntent` 本体など、Siri AI のツールと直接関係しないシンボル）は
対象外。
- 同名でオーバーロードがあるマクロ（`ComputedProperty` など）は、オーバーロードごとに別ページとして保存する。
  スラッグは「シンボル名（小文字）」を基本にし、2つ目以降は追加の引数ラベルを `-` でつなぐ
  （例: `computedproperty`、`computedproperty-customindexingkey`、`appintent-schema`）。

### 1-B. 固定クエリでの新規カテゴリ検出

ルートページのクロールだけでは見つからない新しいページ（Appleが新設したページ等）を
見つけるために、次の固定クエリで Apple Developer の検索を使う。クエリ文言は変えない。

```
https://developer.apple.com/search/?q=<query>&type=Documentation&tab=search
```

固定クエリ一覧:

- `Siri`
- `SiriKit`
- `App Intents`
- `Apple Intelligence`
- `Siri AI`
- `Shortcuts`

各クエリの結果から `developer.apple.com/documentation/` または
`developer.apple.com/design/human-interface-guidelines/` 配下の URL だけを候補にする
（Videos・Sample Code・WWDCセッション等は対象外）。すでに `sources.yaml` にある URL は除外する。

### 1-C. 候補の確定

1-A と 1-B で出た候補URLのうち、ページを開いて本文が実質的にSiri/Siri AI/SiriKit/
App Intents/Shortcuts の説明であることを確認したものだけを「今回追跡するページ」として
確定する。単なる相互参照・関連リンクだけのページは除外する。

## 2. ページを取得して保存する

確定した各URLについて:

1. ブラウザツールでページを開き、`get_page_text` で本文を取得する（`<main>` 相当の本文のみ。
   ナビゲーションやフッターの定型文は含めない）。
2. 本文中に長大な定型データ（例: 多言語の対訳表、巨大なコード生成物の一覧）があり、
   ページの主旨の理解に必須でない場合は、要約や「出典ページ参照」の注記に置き換えてよい
   （[DISCLAIMER.md](../../../DISCLAIMER.md) 参照）。中心的な解説文はそのまま保存する。
3. `docs/apple-doc/<category>/<slug>.md` に以下の形式で保存する（`<slug>` はURL末尾のパス要素。APIリファレンスは上記のスラッグ規則）。

   ```markdown
   ---
   source_url: <元のURL>
   title: <ページタイトル>
   category: <sirikit|app-intents|apple-intelligence|shortcuts>
   kind: <article|tool>
   fetched_at: <ISO8601、取得時点のUTC>
   ---

   <本文>
   ```

4. 既存ページを再取得した場合は、保存前に今の本文（frontmatter抜き）と取得した本文を比較する。
   同一なら変更なしとしてスキップ。異なる場合だけファイルを書き換える。

## 3. マニフェスト (`sources.yaml`) を更新する

- 新規ページ: エントリを追加（`url`, `category`, `kind`, `path`, `title`, `first_fetched`, `last_fetched` を今回の日付で）。
- 既存ページで内容に変更があった: `last_fetched` を更新。
- 既存ページで内容が同一だった: 何もしない（`last_fetched` も更新しない。更新履歴は git log 側に残るため）。

## 4. ブランチ・コミット・PR

変更対象ファイル（`docs/apple-doc/**` と `sources.yaml`）が1件もなければ、ここで終了してよい
（「今回は差分なし」と報告する）。差分がある場合のみ以下を行う。

1. ブランチを切る: `docs/update-YYYY-MM-DD`（今日の日付）。同名ブランチが既にあれば
   `docs/update-YYYY-MM-DD-2` のように連番を振る。
2. 変更した `docs/apple-doc/**` と `sources.yaml` だけをステージしてコミットする。コミットメッセージは
   「追加したページ数・更新したページ数」が分かるように書く（例:
   `Update Siri/Siri AI docs: 2 new, 1 updated`）。
3. `git push -u origin <branch>`。
4. `gh pr create` で PR を作る。本文には今回追加/更新したページをカテゴリ別に列挙し、
   それぞれの出典URLを明記する。`kind` が `article` か `tool` かも分けて書く。
5. PRのURLをユーザーに伝える。マージはユーザーの判断に任せ、こちらでは行わない。

## 補足: なぜこの手順を固定するか

- 検索方法を都度変えると、実行者やモデルが違うたびに対象範囲がぶれる。ルートページの
  Topics クロール＋固定クエリの2段構えにすることで、「同じ入力なら同じ出力」に近づける。
- 本文をそのまま保存するのは個人の差分追跡目的であり、再配布を目的としない
  （[DISCLAIMER.md](../../../DISCLAIMER.md)）。収録するかどうか迷うページ・データは
  保存を見送って出典リンクのみ残す方を優先する。
