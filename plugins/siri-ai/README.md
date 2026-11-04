# siri-ai プラグイン

[siri-ai-tutorials](https://akidon0000.github.io/siri-ai-tutorials/tutorials/) の全8章を、Claude Code などのエージェントが読める skill にしたもの。
iOS アプリを Siri・App Intents・Apple Intelligence・Siri AI Developer Preview（iOS 27.3 beta）に対応させる作業で使う。

## 入れ方

Claude Code のプラグインとして入れる:

```text
/plugin marketplace add akidon0000/siri-ai-tutorials
/plugin install siri-ai@siri-ai-tutorials
```

[APM](https://github.com/microsoft/apm) で入れる:

```bash
apm install akidon0000/siri-ai-tutorials/plugins/siri-ai
```

skill だけを入れる（[skills CLI](https://github.com/vercel-labs/skills)）:

```bash
npx skills add akidon0000/siri-ai-tutorials --skill siri-ai
```

## 中身

| パス | 中身 | 書き方 |
|---|---|---|
| `skills/siri-ai/SKILL.md` | 章の見取り図、どの仕組みで公開するかの判断、間違えやすい点 | 手で書く |
| `skills/siri-ai/references/NN-*.md` | 章ごとの本文・ステップ・セクション終了時点のコード・ワークショップ用プロンプト | 生成物 |
| `skills/siri-ai/references/code/` | 全章を終えた時点の各ファイル | 生成物 |

`references/` はチュートリアル本体（`.tutorial` と `tools/tutorial-code/seq/`）から `python3 tools/skill/generate.py` で作る。
直接編集しても次の生成で消える。Apple の原文（`docs/apple-doc/`）は再配布しない方針なので、skill には入れていない。
