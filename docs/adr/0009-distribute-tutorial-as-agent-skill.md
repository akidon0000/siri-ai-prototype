---
title: "チュートリアルを skill にして、Claude Code プラグインと APM パッケージとして配る"
status: Accepted
proposed: 2026-11-04
accepted: 2026-11-04
supersedes:
issue:
---

# チュートリアルを skill にして、Claude Code プラグインと APM パッケージとして配る

## Decision（決定事項）

### 決定事項

1. **`plugins/siri-ai/` に skill `siri-ai` を置き、Claude Code プラグイン・APM パッケージ・skills CLI のどれからでも入れられるようにする。**
   リポジトリ直下の `.claude-plugin/marketplace.json` がこのプラグインを指す。
2. **章ごとの参照資料 `references/` は `.tutorial` と `.seq` から `tools/skill/generate.py` で生成する。** 手で書くのは `SKILL.md` だけ。
3. **Apple の原文（`docs/apple-doc/`）は skill に入れない。** DISCLAIMER.md の「再配布しない」方針に合わせる。

### 比較・検討内容の要約

チュートリアルの中身を手で要約し直すと、本文やコードを直すたびに skill がずれる。生成にすれば、`.tutorial` と `.seq` を正本にしたまま全8章の本文・ステップ・コードを漏れなく持てる。
プラグインをリポジトリ直下に置く案は、Claude Code がプラグインのディレクトリごとキャッシュにコピーするため、`ios/` や `docs/apple-doc/` まで配ってしまうので採らなかった。

## Context（経緯・背景情報）

### 背景

- チュートリアルは8章・49セクション・195ステップ、コードの元ファイルは45個ある。
- 読み手は DocC のサイトで読むが、自分のアプリで Siri 対応を進めるときにエージェントへ同じ知識を渡す手段が無かった。

### 課題

1. **エージェントがチュートリアルを参照できない**
   - 公開サイトは JavaScript で描画されるので、エージェントが読みにくい。リポジトリを clone しても `.tutorial` とスナップショットが別ファイルに分かれている。

## Consideration（比較・検討内容）

### 比較対象

| 案 | ソリューション | 概要 |
|----|----------------|------|
| 案1 | **手書きの skill** | 章ごとに要点を手で書く |
| 案2 | **生成した参照資料＋手書きの SKILL.md** | 本文とコードは生成、判断の分岐と注意点だけ手で書く |
| 案3 | **リポジトリ全体をプラグインにする** | 直下に `plugin.json` を置き、`skills/` も直下に置く |

### 総合評価

| 案 | 総合評価 | 判定 |
|----|----------|------|
| 案1: 手書き | 要約の分だけ情報が落ち、チュートリアルを直すたびに追従が要る | **不採用** |
| 案2: 生成＋手書き | 内容は漏れず、CI の `--check` でずれも検出できる | **採用** |
| 案3: 全体をプラグインに | 入れる側に `ios/` や Apple の原文まで届く | **不採用** |

## Consequences（結果）

### 期待される効果

1. `/plugin install siri-ai@siri-ai-tutorials`、`apm install akidon0000/siri-ai-tutorials/plugins/siri-ai`、`npx skills add` のどれでも同じ skill が入る。
2. チュートリアルを直したのに skill を作り直し忘れた PR は、`skill-check.yml` が落とす。

### 技術的リスクと対策

| リスク | 内容 | 対策 |
|--------|------|------|
| 参照資料が大きい | 8章で約12万字ある | SKILL.md の見取り図から必要な章だけを読ませる |
| 3つのマニフェストの version がずれる | `plugin.json`・`apm.yml`・`marketplace.json` | CONTRIBUTING.md と CLAUDE.md に、同じ値で上げる決まりを書いた |
| ADR の番号 | 0008 は未マージの `Example/` の ADR が使っている | この ADR は 0009 にした |

## References（参照）

- 関連 ADR: [0003](0003-generate-tutorial-code-snapshots-from-tagged-sources.md), [0005](0005-rename-to-tutorials-and-separate-apple-doc.md)
- 外部: [Claude Code plugin marketplaces](https://code.claude.com/docs/en/plugin-marketplaces)、[APM](https://github.com/microsoft/apm)
