---
title: "リポジトリを siri-ai-tutorials に改名し、Appleの原文を docs/apple-doc/ に分けて種類で分類する"
status: Accepted
proposed: 2026-11-04
accepted: 2026-11-04
supersedes:
issue:
---

# リポジトリを siri-ai-tutorials に改名し、Appleの原文を docs/apple-doc/ に分けて種類で分類する

## Decision（決定事項）

### 決定事項

1. リポジトリ名を `siri-ai-prototype` から **`siri-ai-tutorials`** に改める。公開物の名称も「Siri AI Tutorials」にそろえ、
   入口のURLは `https://akidon0000.github.io/siri-ai-tutorials/tutorials/` にする。
2. Apple Developer Documentation の原文は **`docs/apple-doc/<category>/`** に置く。
   ADR（`docs/adr/`）や設計メモ（`docs/superpowers/`）と、自分が書いた文書を混ぜない。
3. 原文のページには **`kind: article | tool`** を付ける。`article` は記事・概要・HIG・APIコレクション、
   `tool` は Siri AI のツール関連のAPIリファレンス（`IntentVisibility`、`ToolIntent`、`GenerableEntity`、
   `@AppIntent`、`@ComputedProperty` など、シンボル単位のページ）。更新スキルは両方を取得する。
4. 各章末の `prompt.txt` は、章のURLを含み、実装・ビルド・テスト・シミュレータでの確認・報告までを
   Claude Codeに任せるワークショップ形式にする（0002の「プロンプトで段階的に実装を依頼する」の中身を具体化する）。

### 比較・検討内容の要約

`docs/` 直下に原文のカテゴリを並べたままだと、ADR や設計メモと同じ階層に並び、どれが自分の文書でどれがAppleの原文か分からない。
種類の分類は、ディレクトリを増やす案より frontmatter と `sources.yaml` の1項目にする案の方が、既存のパスを動かさずに済む。

## Context（経緯・背景情報）

### 背景

- `docs/` 直下に `sirikit/` `app-intents/` `apple-intelligence/` `shortcuts/` が並び、その隣に `adr/` と `superpowers/` があった。
- 追跡していたのは記事と概要の7ページだけで、第7章が頼りにする `IntentVisibility` などのAPIページは、チュートリアルからリンクするだけで原文を持っていなかった。
- 学習用チュートリアルが主になり、リポジトリ名の `prototype` が実態と合わなくなった。

### 課題

1. **原文と自分の文書が同じ階層にある**: 更新スキルの対象範囲と、手で書く文書の置き場所が見分けにくい。
2. **APIの原文が追跡されていない**: 改訂の差分を `git diff` で追えるのは記事だけだった。
3. **プロンプトが確認止まり**: 実装を頼んだあと、動かして確かめる手順がプロンプトに無かった。

## Consideration（比較・検討内容）

### 比較対象

| 案 | ソリューション | 概要 |
|----|----------------|------|
| 案1 | **現状維持** | `docs/` 直下にカテゴリを並べる |
| 案2 | **`docs/apple-doc/` にまとめ、種類は frontmatter で持つ** | パスは1階層深くなるだけ。種類は `kind` の1項目 |
| 案3 | **`docs/apple-doc/article/` `docs/apple-doc/tool/` に分ける** | 種類がパスで見える。カテゴリとの二重の分類になる |

### 総合評価

| 案 | 総合評価 | 判定 |
|----|----------|------|
| 案1: 現状維持 | 原文と自分の文書の区別がつかない | **不採用** |
| 案2: apple-doc + kind | 区別がつき、分類は1項目で足りる | **採用** |
| 案3: パスで分ける | カテゴリと種類で2軸になり、置き場所の判断が増える | **不採用** |

## Consequences（結果）

### 期待される効果

1. 更新スキルの対象が `docs/apple-doc/` に閉じ、手書きの文書を巻き込まない。
2. ツール関連のAPIの改訂も `git diff` で追える。
3. 章のプロンプトを貼るだけで、実装から動作確認までを進められる。

### 技術的リスクと対策

| リスク | 内容 | 対策 |
|--------|------|------|
| 旧URLが404になる | GitHub Pages は、リポジトリを改名すると `…/siri-ai-prototype/` のURLを転送しない | 旧URLの転送はできない。READMEと入口のURLを新しいものに更新した |
| 古いパスの記述が残る | 既存のADR・設計メモに `docs/sirikit/` などの旧パスがある | 記録の書き換えはしない。旧パスは `docs/apple-doc/` 配下に読み替える |
| 内部名が旧称のまま | Xcodeのスキーム `SiriAIPrototype`、バンドルID `com.akidon0000.SiriAIPrototype`、表示名「Siri AI Prototype」 | 今回は変えない。プロンプトはこれらの名前で書いてある |

## References（参照）

- 関連 ADR: [0002](0002-docc-tutorial-defers-siri-implementation.md)、[0003](0003-generate-tutorial-code-snapshots-from-tagged-sources.md)
- 外部: [Siri AI Developer Preview](https://developer.apple.com/documentation/appintents/siri-ai-developer-preview)、
  [Bringing custom actions and content to Siri](https://developer.apple.com/documentation/appintents/bringing-custom-actions-and-content-to-siri)
