# siri-ai-prototype

## DocCチュートリアルのコード

- `ios/Library/Sources/AppFeature/AppFeature.docc/Tutorials/TutorialArt/Code/` は生成物。直接編集しない
  （`tools/tutorial-code/generate.py` が実行のたびに中身を消して作り直す）。
- コードを変えるときは `tools/tutorial-code/seq/<名前>.<拡張子>.seq` を編集し、`python3 tools/tutorial-code/generate.py` を実行する。
  - 各行の先頭に `N|`（ステップNから存在）か `N-M|`（ステップNからMまで存在）を付ける。先頭行の `#name` は `@Code(name:)` に使う表示名。
  - 1ステップで足す行は、空行と閉じ括弧だけの行を除いて5行以内、空行以外で6行以内。超えるとエラーになるので、ステップを分ける。
- `.tutorial` からは `@Code(name: "<#nameの値>", file: "<名前>-NN.<拡張子>", previousFile: "<名前>-(NN-1).<拡張子>")` で参照する。
  生成スクリプトは、全スナップショットがどこかのステップから参照されているか、`name` と `previousFile` が正しいかも検査する。
- `.md` をDocCカタログに置くと記事として解釈されるので、Markdownを載せたいときは拡張子を `.txt` にする（例: `MemoTriageSkill.txt.seq`）。
- 変更後は `xcrun docc convert` が警告0件で通ることを確かめる（コマンドは `.github/workflows/docc-pages.yml` と同じ）。
- `.tutorial` のファイル名を変えると公開URLが変わり、旧URLは404になる。改名したら `tools/docc-redirects.sh` に
  `redirect <旧名> <新名>` を足す（Pagesのデプロイ時に旧URLへ転送ページを置く）。

## 決定の記録

構成上の判断は `docs/adr/` に残す。
