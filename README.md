# siri-ai-prototype

Apple Developer Documentation のうち Siri / Siri AI (Apple Intelligence) 関連ページを
そのまま git 管理し、改訂の差分を `git log` / `git diff` で追えるようにするための個人用アーカイブ。

対象カテゴリは以下の4つ（それぞれ `docs/<category>/` に対応）。

| カテゴリ | ディレクトリ | 内容 |
|---|---|---|
| SiriKit | `docs/sirikit/` | 旧世代の Intents / IntentsUI フレームワーク |
| App Intents | `docs/app-intents/` | App Intents フレームワーク本体 |
| Apple Intelligence / Siri | `docs/apple-intelligence/` | Apple Intelligence と Siri AI への統合、Siri AI Developer Preview、Siri の HIG |
| Shortcuts | `docs/shortcuts/` | App Shortcuts（Shortcuts アプリ・Siri からの呼び出し） |

## ファイル形式

各ページは1ファイル1ページで、frontmatter に出典情報を付けて本文をそのまま保存する。

```markdown
---
source_url: https://developer.apple.com/documentation/...
title: ページタイトル
category: sirikit | app-intents | apple-intelligence | shortcuts
fetched_at: 2026-11-04T00:00:00Z
---

(本文)
```

`sources.yaml` が追跡中ページの一覧（マニフェスト）。カテゴリ・ローカルパス・初回取得日・最終取得日を持つ。

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

## Siri PoC（ios/）

`docs/` のドキュメントを教材に、Siri/App Intents統合を学びながら実装するためのPoC。

- `ios/App` — SwiftUIアプリの殻（Xcodeプロジェクト）
- `ios/Library` — SPMパッケージ（Clients / ClientsLive / Components / AppFeature / TestSupport）。
  pickle-app (akidon0000) のアーキテクチャを踏襲。Siri関連の実機能はまだ実装していない。
- `ios/Library/Sources/AppFeature/AppFeature.docc` — DocC Tutorial形式のチュートリアル
  （SiriKitの限界 → App Intentsの基礎 → App Shortcuts → Apple Intelligence/Siri AI統合 →
  Siri AI Developer PreviewのToolIntent、の5章）。Xcodeの「Build Documentation」
  （⌃⇧⌘D）で読める。各章末に、理解したあと実装を指示するためのコピペ用プロンプトがある。
  GitHub Pagesでも公開していて、ブラウザから読める:
  [akidon0000.github.io/siri-ai-prototype/tutorials/siriaitutorials](https://akidon0000.github.io/siri-ai-prototype/tutorials/siriaitutorials/)
  （`ios/Library` 配下をmainにpushすると `.github/workflows/docc-pages.yml` が自動で再公開する）

構成の決定理由は [docs/adr/](./docs/adr/) を参照。

