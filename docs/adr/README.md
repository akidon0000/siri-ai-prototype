# ADR（設計判断の記録）

- 読み手: 自分、将来のエージェントセッション
- 目的: このリポジトリでの採用・不採用の判断と、その理由を後から辿れるようにする

判断は、理由と一緒にMarkdownでリポジトリに残す。確定していない判断は書かない。

## 一覧

| ID | タイトル | 状態 | 概要 | 本文 |
|----|----------|------|------|------|
| 0001 | Siri PoCをApp+Library構成で作り、Android共有用sharedパッケージは作らない | Accepted | pickle-appのApp+Library(SPM)パターンを踏襲するが、shared/CI/配信は対象外にする | [0001-app-library-skeleton-without-shared-package.md](0001-app-library-skeleton-without-shared-package.md) |
| 0002 | DocCチュートリアルで理解を先行させ、Siri実装はコピペプロンプトで後から着手する | Accepted | `AppFeature.docc` にTutorial形式で5章を作り、各章末のプロンプトで段階的に実装を依頼する | [0002-docc-tutorial-defers-siri-implementation.md](0002-docc-tutorial-defers-siri-implementation.md) |
| 0003 | DocCチュートリアルのコードを、行ごとにステップ番号を付けたソースから生成する | Accepted | `tools/tutorial-code/seq/*.seq` からステップ別スナップショットを生成し、1ステップ5行程度の制限と参照の整合を自動で確かめる | [0003-generate-tutorial-code-snapshots-from-tagged-sources.md](0003-generate-tutorial-code-snapshots-from-tagged-sources.md) |
| 0004 | チュートリアルのコードにコメントを書き、行数制限から外す。ベータのAPIにはタグを付ける | Accepted | `//` コメントは行数制限に数えず、説明だけのステップでもコードを見せ続ける。iOS 27.3 betaのセクションに `【iOS 27.3 beta】` を付ける | [0004-tutorial-code-comments-and-beta-tags.md](0004-tutorial-code-comments-and-beta-tags.md) |
| 0005 | リポジトリを siri-ai-tutorials に改名し、Appleの原文を docs/apple-doc/ に分けて種類で分類する | Accepted | 原文を `docs/apple-doc/` に閉じ、`kind: article \| tool` で分類する。APIリファレンスも取得し、章末プロンプトは実装から動作確認までのワークショップ形式にする | [0005-rename-to-tutorials-and-separate-apple-doc.md](0005-rename-to-tutorials-and-separate-apple-doc.md) |

### 状態

- **Accepted**: 採用済み。今も有効
- **Superseded**: 後のADRで置き換えた。内容は履歴として残す

新しいADRは `Accepted` で追加する。

## 配置

```text
docs/adr/
  README.md              # この一覧と書き方
  TEMPLATE/NNNN-slug.md  # 新しいADRの雛形
  NNNN-slug.md           # 1件1ファイル
```

書式はakidon0000/pickle-appの `docs/adr/` と同じテンプレートに揃えている。
