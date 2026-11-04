---
title: "DocCチュートリアルで理解を先行させ、Siri実装はコピペプロンプトで後から着手する"
status: Accepted
proposed: 2026-11-04
accepted: 2026-11-04
supersedes:
issue:
---

# DocCチュートリアルで理解を先行させ、Siri実装はコピペプロンプトで後から着手する

## Decision（決定事項）

### 決定事項

`ios/Library/Sources/AppFeature/AppFeature.docc` にDocC Tutorial形式で5章の
チュートリアルを作り、`docs/` に保存済みのApple公式ドキュメントを教材として使う。
各章末に「理解できたらコピペする」実装プロンプトを置き、Siri/App Intentsの実装
コードは今回は書かない。ユーザーが章を読んで理解し、プロンプトをコピペして
指示した範囲だけ実装を進める。

### 比較・検討内容の要約

PoCとして実際に動くSiri機能を先に実装する案も検討したが、「ドキュメントを読んで
理解してから実装したい」という意向に沿い、チュートリアルを先に作り実装は後回しにする
案を採用した。

## Context（経緯・背景情報）

### 背景

このリポジトリにはSiriKit / App Intents / Apple Intelligence (Siri AI) / App Shortcuts
の4カテゴリのApple公式ドキュメント原文が `docs/` 配下にある。これを読まずにいきなり
実装すると、何を・なぜ実装しているかの理解が追いつかない。

### 課題

1. **学習と実装を同時に進めると理解が追いつかない**
   - SiriKit→App Intents→App Shortcuts→Apple Intelligence→Siri AI Developer Preview
     という5段階の概念は、それぞれ前提知識が積み上がる構造になっている。
2. **後で実装するときに毎回文脈を説明し直すのは非効率**
   - 理解した内容をもとに実装を依頼する際、どのファイルに何を実装すべきかを
     毎回ゼロから指示するのは手間が大きい。

## Consideration（比較・検討内容）

### 比較対象

| 案 | ソリューション | 概要 |
|----|----------------|------|
| 案1 | 先に実装する | Memoの App Intents / ToolIntent を今回のうちに実装してしまう |
| 案2 | **DocC Tutorialで理解を先行させ、実装はプロンプトで後から** | チュートリアルと空のスケルトンだけ今回用意し、実装は章ごとのコピペプロンプトに任せる |
| 案3 | Markdownでチュートリアルを書く | `.docc` ではなく `docs/` 配下に普通のMarkdownで手順書を書く |

### 比較表

| 評価項目 | 案1 先に実装 | 案2 DocC Tutorial + プロンプト | 案3 Markdown手順書 |
|----------|--------------|-------------------------------|----------------------|
| 理解してから実装するという要望への適合 | 悪い。実装が先に出来上がってしまう | 良い | 良い |
| コピペ体験 | 該当しない | 良い。DocCのコードブロックに標準でコピーボタンが付く | 普通。Markdownのコードブロックにも大抵コピーボタンはあるが、Xcode上で読めない |
| Xcode上で読める・Quick Help/Build Documentationと統合できる | 該当しない | 良い | 悪い。Xcode外で読む必要がある |
| 作り込みコスト | 中 | 高い（Tutorial DSLの学習・画像素材が必要） | 低い |

### 総合評価

| 案 | 総合評価 | 判定 |
|----|----------|------|
| 案1: 先に実装 | 要望（理解してから実装したい）に反する | **不採用** |
| 案2: DocC Tutorial + プロンプト | コスト増だが要望に最も合致し、Xcode統合のメリットも大きい | **採用** |
| 案3: Markdown手順書 | 低コストだがXcode統合・コピペ体験で劣る | **不採用** |

## Consequences（結果）

### 期待される効果

1. 実装前に必ずドキュメントを読む導線ができる。
2. 各章末のプロンプトをそのままClaude Codeに貼れば、章の範囲だけ実装が進む
   （例: Tutorial 2のプロンプトは `ios/Library` にMemoのApp Intents実装を指示する）。
3. `AppFeature.docc` はXcodeの「Build Documentation」でそのままプレビューできる。

### 技術的リスクと対策

| リスク | 内容 | 対策 |
|--------|------|------|
| DocC Tutorial内の例（Memo）と実際の実装がずれる | プロンプト通りに実装されなかった場合、チュートリアルの説明と実装が食い違う | プロンプト自体に実装すべきファイル・型名を明記してあるので、レビュー時に突き合わせる |
| `.tutorial` ファイルの構文エラーに気づきにくい | DocCのTutorial DSLは専用の構文チェックがないと壊れていても気づきにくい | `xcrun docc convert` をwarning 0件で通すことを作成時に確認済み |

## References（参照）

- 関連ADR: 0001-app-library-skeleton-without-shared-package.md
- Design doc: `docs/superpowers/specs/2026-11-04-siri-poc-docc-skeleton-design.md`
- 教材: `docs/sirikit/`, `docs/app-intents/`, `docs/apple-intelligence/`, `docs/shortcuts/`
