# siri-ai-tutorials

Memoアプリを1ステップ数行ずつ組み立てながら、SiriKit から Siri AI Developer Preview（iOS 27.3 beta）までを順に学ぶ DocC チュートリアル。

**読む:** [akidon0000.github.io/siri-ai-tutorials/tutorials/](https://akidon0000.github.io/siri-ai-tutorials/tutorials/)

Created by Opus 5.5 with Dan Akiyama ([@akidon0000](https://github.com/akidon0000))

誤りや不足を見つけたら 気軽に [akidon0000/siri-ai-tutorials](https://github.com/akidon0000/siri-ai-tutorials) にPRを。

## 章立て

| 章 | 内容 |
|---|---|
| 1 | SiriKit から App Intents へ |
| 2 | App Intents の基礎 |
| 3 | App Shortcuts でフレーズを固定する |
| 4 | Siri との会話を設計する |
| 5 | スキーマで Apple Intelligence に載せる |
| 6 | Apple Intelligence に文脈を渡す |
| 7 | Siri AI Developer Preview【iOS 27.3 beta】 |
| 8 | 検証する |

各ステップでは、そのステップで足した行がハイライトされる。章末には Claude Code に渡すワークショップ用プロンプトがあり、章の内容を実際に実装してビルド・テスト・シミュレータで確かめるところまでを任せられる。

ブラウザのほか、Xcode で `ios/Library` を開いて Build Documentation（⌃⇧⌘D）でも読める。

## リポジトリの中身

| パス | 中身 |
|---|---|
| `ios/Library/Sources/AppFeature/AppFeature.docc/` | チュートリアル本体（`.tutorial`） |
| `tools/tutorial-code/` | チュートリアルに載せるコードの元ファイル（`seq/*.seq`）と生成スクリプト |
| `ios/App`、`ios/Library` | Memoアプリ（SwiftUI の殻と SPM パッケージ）。Siri 連携はまだ入っておらず、章末プロンプトで実装していく |
| `Example/` | 第1章から第8章までを実装し終えた Memoアプリ。構成は `ios/` と同じ。答え合わせ用（[Example/README.md](./Example/README.md)） |
| `docs/apple-doc/` | 教材にした Apple Developer Documentation の原文。改訂を `git diff` で追う |
| `docs/adr/` | 構成上の決定の記録 |

## チュートリアルを直すとき

コードは `tools/tutorial-code/seq/` を編集して `python3 tools/tutorial-code/generate.py` で生成する。生成先の `TutorialArt/Code/` は直接触らない。`.seq` の書式、1ステップの行数制限、`.tutorial` の改名時のリダイレクト、PR 前の確認は [CONTRIBUTING.md](./CONTRIBUTING.md) にまとめてある。

手元での確認は `xcrun docc convert` が警告0件で通ればよい（コマンドは [docc-pages.yml](./.github/workflows/docc-pages.yml) と同じ）。`main` に push すると GitHub Pages に自動で再公開される。

## Apple ドキュメントのアーカイブ

`docs/apple-doc/<category>/` に、Siri 関連のページを1ページ1ファイルで保存している。カテゴリは `sirikit`、`app-intents`、`apple-intelligence`、`shortcuts` の4つ。追跡中のページ一覧は [sources.yaml](./sources.yaml)。

再取得・追加・PR 作成までの手順は Claude Code のスキル [update-apple-siri-docs](./.claude/skills/update-apple-siri-docs/SKILL.md) に固定してある。このリポジトリで「Apple の Siri 関連ドキュメントを更新して」と頼めば動く。

原文の著作権は Apple Inc. にある。扱いの方針は [DISCLAIMER.md](./DISCLAIMER.md) を参照。
