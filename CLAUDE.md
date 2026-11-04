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
- 変更後は `xcrun docc convert` が警告0件で通ることを確かめる（コマンドは `.github/workflows/docc-pages.yml` と同じ）。
- `.tutorial` のファイル名を変えると公開URLが変わり、旧URLは404になる。改名したら `tools/docc-redirects.sh` に
  `redirect <旧名> <新名>` を足す（Pagesのデプロイ時に旧URLへ転送ページを置く）。

## Example

- `ios/` はワークショップを始める前の土台なので、Siri連携を実装しない。全章を実装したコードは `Example/` に置く（ADR 0008）。
- `Example/` は `ios/` と同じ App + Library 構成。DocCカタログは複製しない。`ios/` の土台を直したら `Example/` にも反映する。
- iOS 27.3 beta にしか無いAPIは `#if SIRI_AI_PREVIEW` で囲む。有効にするのは `Example/Library/Package.swift` の `siriAIPreview`。

## 決定の記録

構成上の判断は `docs/adr/` に残す。
