# siri-ai-tutorials

## Appleの原文

- Apple Developer Documentation の原文は `docs/apple-doc/<category>/` に置く（`docs/adr/` `docs/superpowers/` と混ぜない）。
  各ページの frontmatter と `sources.yaml` に `kind: article | tool` を付ける。取得は `update-apple-siri-docs` スキルで行う。

## DocCチュートリアルのコード

- `ios/Library/Sources/AppFeature/AppFeature.docc/Tutorials/TutorialArt/Code/` は生成物。直接編集しない
  （`tools/tutorial-code/generate.py` が実行のたびに中身を消して作り直す）。
- コードを変えるときは `tools/tutorial-code/seq/<名前>.<拡張子>.seq` を編集し、`python3 tools/tutorial-code/generate.py` を実行する。
  - 各行の先頭に `N|`（ステップNから存在）か `N-M|`（ステップNからMまで存在）を付ける。先頭行の `#name` は `@Code(name:)` に使う表示名。
  - 1ステップで足す行は、空行・閉じ括弧だけの行・`//` コメントだけの行を除いて5行以内、空行とコメント以外で6行以内。超えるとエラーになるので、ステップを分ける。
  - `//` コメントは、コードや名前を読んでも分からないこと（Siriやシステムがその値をどう使うか、なぜそう書くか、注意点）だけに書く。
    `title` や `init` のように、コードを日本語で言い直すだけのコメントは書かない。
    説明文だけのステップは作らず、前のステップのコードにコメントを足すステップにする。
  - 途中にステップを挟むときは `python3 tools/tutorial-code/shift.py <名前>.<拡張子> <N>` で、N以降のステップ番号と `.tutorial` の参照をずらしてから、`N|` の行を足す。
- `【iOS 27.3 beta】` のタグは、Siri AI Developer Preview（iOS 27.3 beta）を扱う章の章名の末尾にだけ付ける（例: `第7章: Siri AI Developer Preview【iOS 27.3 beta】`）。
  セクションのタイトルには付けない。他の章でbetaのAPIに触れるときは、本文に「（iOS 27.3 beta）」と書く。
- `.tutorial` からは `@Code(name: "<#nameの値>", file: "<名前>-NN.<拡張子>", previousFile: "<名前>-(NN-1).<拡張子>")` で参照する。
  生成スクリプトは、全スナップショットがどこかのステップから参照されているか、`name` と `previousFile` が正しいかも検査する。
- `.md` をDocCカタログに置くと記事として解釈されるので、Markdownを載せたいときは拡張子を `.txt` にする（例: `MemoTriageSkill.txt.seq`）。
- 変更後は日本語版・英語版の両カタログで `xcrun docc convert` が警告0件で通ることを確かめる（コマンドは `.github/workflows/docc-pages.yml` と同じ）。
- `.tutorial` のファイル名を変えると公開URLが変わり、旧URLは404になる。改名したら両言語とも同じ名前に変え、`tools/docc-redirects.sh` に
  `redirect <旧名> <新名>` を足す（Pagesのデプロイ時に旧URLへ転送ページを置く）。

## 英語版（ADR 0010）

- 英語版のDocCカタログは `ios/Library/Documentation/en/AppFeature.docc/`。`/siri-ai-tutorials/en/` に公開し、日本語版と同じパスにする。
  公開時に `tools/docc-language-switch.sh` が全ページへ言語切り替え（右下のボタン）を差し込む。
- `.tutorial`・`AppFeature.md`・章末プロンプト（`TutorialArt/NN-prompt.txt`）を直したら、英語版の同じファイルも同じコミットで直す。
  セクション・ステップ・`@Code`・`@Image` の並びは日本語版と同じにする（`generate.py` が検査する）。
- 英語版のコードは同じ `.seq` から作る。日本語を含む行は `tools/tutorial-code/en/<名前>.<拡張子>.en` の対訳
  （`ja|<日本語の行>` と `en|<英語の行>` の組。字下げは元の行のものを使う）で置き換える。`.seq` の日本語の行を足す・変えたら対訳も直す。
  対訳が無い・使われていない・英語側に日本語が残っていると `generate.py` がエラーにする。
- 英語版の章名のbetaタグは ` [iOS 27.3 beta]`、本文では「(iOS 27.3 beta)」と書く。
- skill（`plugins/siri-ai`）は日本語版だけから生成する。

## Example

- `ios/` はワークショップを始める前の土台なので、Siri連携を実装しない。全章を実装したコードは `Example/` に置く（ADR 0008）。
- `Example/` は `ios/` と同じ App + Library 構成。DocCカタログは複製しない。`ios/` の土台を直したら `Example/` にも反映する。
- iOS 27.3 beta にしか無いAPIは `#if SIRI_AI_PREVIEW` で囲む。有効にするのは `Example/Library/Package.swift` の `siriAIPreview`。

## skill（plugins/siri-ai）

- `plugins/siri-ai/skills/siri-ai/references/` は生成物。直接編集しない（`tools/skill/generate.py` が毎回消して作り直す）。
- `.tutorial` か `.seq` を変えたら `python3 tools/skill/generate.py` を実行し、生成物の差分も同じコミットに入れる。
  CI は `--check` で古いままになっていないかを見る。
- 手で書くのは `SKILL.md` だけ。章や API が変わったら、章の見取り図と「間違えやすい点」も直す。
- 中身を変えたら `plugin.json`・`apm.yml`・`.claude-plugin/marketplace.json` の `version` を同じ値で上げる。
- `docs/apple-doc/` の原文は再配布しない方針（DISCLAIMER.md）なので、skill に入れない。

## 決定の記録

構成上の判断は `docs/adr/` に残す。
