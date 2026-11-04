# siri-ai-tutorials

SiriKit から Siri AI までを、Memoアプリのコードを組み立てながら学ぶチュートリアル（DocC）。
あわせて、教材にした Apple Developer Documentation の Siri / Siri AI (Apple Intelligence) 関連ページを
そのまま git 管理し、改訂の差分を `git log` / `git diff` で追えるようにしている。

Created by Dan Akiyama ([@akidon0000](https://github.com/akidon0000))。
Claude Opus 5.5で作ったため、誤りを含むことがある。見つけたらPRを送ってほしい。

チュートリアルはブラウザで読める: [akidon0000.github.io/siri-ai-tutorials/tutorials/](https://akidon0000.github.io/siri-ai-tutorials/tutorials/)

## Apple公式ドキュメントのアーカイブ（docs/apple-doc/）

`docs/adr/`（意思決定の記録）や `docs/superpowers/`（設計メモ）と区別するため、Appleの原文は `docs/apple-doc/` に置く。
対象カテゴリは以下の4つ（それぞれ `docs/apple-doc/<category>/` に対応）。

| カテゴリ | ディレクトリ | 内容 |
|---|---|---|
| SiriKit | `docs/apple-doc/sirikit/` | 旧世代の Intents / IntentsUI フレームワーク |
| App Intents | `docs/apple-doc/app-intents/` | App Intents フレームワーク本体 |
| Apple Intelligence / Siri | `docs/apple-doc/apple-intelligence/` | Apple Intelligence と Siri AI への統合、Siri AI Developer Preview、Siri の HIG |
| Shortcuts | `docs/apple-doc/shortcuts/` | App Shortcuts（Shortcuts アプリ・Siri からの呼び出し） |

## ファイル形式

各ページは1ファイル1ページで、frontmatter に出典情報を付けて本文をそのまま保存する。

```markdown
---
source_url: https://developer.apple.com/documentation/...
title: ページタイトル
category: sirikit | app-intents | apple-intelligence | shortcuts
kind: article | tool
fetched_at: 2026-11-04T00:00:00Z
---

(本文)
```

`kind` はページの種類。`article` は記事・概要・HIG・APIコレクション、`tool` は Siri AI のツール関連のAPIリファレンス
（`IntentVisibility`、`ToolIntent`、`GenerableEntity`、`@AppIntent` など、シンボル単位のページ）。

`sources.yaml` が追跡中ページの一覧（マニフェスト）。カテゴリ・種類・ローカルパス・初回取得日・最終取得日を持つ。

著作権に関する注記は [DISCLAIMER.md](./DISCLAIMER.md) を参照。

## 更新の手順（再現可能にするためのスキル）

ページの再取得・新規追加・コミット・PR作成は、このリポジトリ同梱の Claude Code スキル
[`.claude/skills/update-apple-siri-docs/SKILL.md`](./.claude/skills/update-apple-siri-docs/SKILL.md)
に手順を固定してある。Claude Code で次のように呼び出す。

```
このリポジトリで Apple の Siri / Siri AI 関連ドキュメントを更新して
```

スキルは「固定した検索方法」で対象ページを洗い出し、`sources.yaml` と差分がある
ページだけを更新し、ブランチを切って commit → push → PR 作成まで行う。

## チュートリアルとMemoアプリ（ios/）

`docs/apple-doc/` のドキュメントを教材に、Siri/App Intents統合を学びながら実装する。

- `ios/App` — SwiftUIアプリの殻（Xcodeプロジェクト）
- `ios/Library` — SPMパッケージ（Clients / ClientsLive / Components / AppFeature / TestSupport）。
  pickle-app (akidon0000) のアーキテクチャを踏襲。Siri関連の実機能は、各章のプロンプトで実装していく。
- `ios/Library/Sources/AppFeature/AppFeature.docc` — DocC Tutorial形式のチュートリアル
  （SiriKitからApp Intentsへ → App Intentsの基礎 → App Shortcuts → Siriとの会話の設計 →
  スキーマ → Apple Intelligenceに文脈を渡す → Siri AI Developer Preview → 検証、の8章）。
  Memoアプリのコードを1ステップ数行ずつ組み立て、変えた行がハイライトされる。
  Xcodeの「Build Documentation」（⌃⇧⌘D）で読める。各章末に、Claude Codeに実装させて動かして確かめるワークショップ用のプロンプトがある
  （章のURL、作るもの、ビルド・テスト・シミュレータでの確認手順、報告の形式が入っている）。
  チュートリアルのコードは `tools/tutorial-code/` のソースから生成している（手順は [CLAUDE.md](./CLAUDE.md)）。
  GitHub Pagesでも公開していて、ブラウザから読める:
  [akidon0000.github.io/siri-ai-tutorials/tutorials/](https://akidon0000.github.io/siri-ai-tutorials/tutorials/)
  （章ごとのURLは `.../tutorials/appfeature/01-sirikit-to-app-intents` の形）
  （`ios/Library` 配下をmainにpushすると `.github/workflows/docc-pages.yml` が自動で再公開する）

構成の決定理由は [docs/adr/](./docs/adr/) を参照。

