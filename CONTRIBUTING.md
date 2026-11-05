# コントリビュートの手引き

チュートリアルの誤字・誤り・古くなった記述を直したい人向けに、どこを触ればよいかと、PR を出す前に確かめることをまとめる。Issue だけでも歓迎する。

## 何を直したいかで触る場所が変わる

| 直したいもの | 触る場所 | 触らない場所 |
|---|---|---|
| 本文の文章・ステップの説明 | `ios/Library/Sources/AppFeature/AppFeature.docc/Tutorials/*.tutorial` と、英語版の `ios/Library/Documentation/en/AppFeature.docc/Tutorials/*.tutorial` | — |
| ステップに載っているコード | `tools/tutorial-code/seq/<名前>.<拡張子>.seq` と、英語版の対訳 `tools/tutorial-code/en/<名前>.<拡張子>.en` | `TutorialArt/Code/`（生成物。両言語とも） |
| skill の判断ガイド | `plugins/siri-ai/skills/siri-ai/SKILL.md` | `plugins/siri-ai/skills/siri-ai/references/`（生成物） |
| Memo アプリ本体 | `ios/App`、`ios/Library` | — |
| Apple ドキュメントの原文 | `update-apple-siri-docs` スキル経由で再取得 | `docs/apple-doc/` の手編集 |
| 構成上の判断 | `docs/adr/` に新番号で追加 | 既存 ADR の書き換え |

## チュートリアルのコードを直す

`TutorialArt/Code/` は `generate.py` が毎回消して作り直すので、直接編集しても消える。元ファイルの `.seq` を直して生成し直す。

```bash
python3 tools/tutorial-code/generate.py
```

`.seq` は1行ごとに、その行がどのステップから存在するかを先頭に書く。

```text
#name MemoIntent.swift
1|import AppIntents
1|
2|// Siri から呼ばれるメモ作成の Intent
2|struct CreateMemoIntent: AppIntent {
3-4|    // ステップ3と4でだけ見せる仮の実装
3-4|    func perform() async throws -> some IntentResult { .result() }
2|}
```

- `N|` はステップ N から最後まで、`N-M|` はステップ N から M までその行を出す。
- 先頭行の `#name` の後ろは `.tutorial` の `@Code(name:)` に使う表示名。
- 1ステップで足す行は、空行・閉じ括弧だけの行・コメントだけの行を除いて5行以内、空行とコメント以外で6行以内。超えると `generate.py` がエラーにするので、ステップを分ける。
- コードの各行には何のための行かを `//` コメントで書く。説明だけのステップを作りたいときも、前のステップのコードにコメントを足すステップにする。
- `.md` は DocC が記事として読んでしまうので、Markdown を載せたいときは `.txt.seq` にする。

途中にステップを挟むときは、先に番号をずらしてから `N|` の行を足す。日本語版・英語版の `.tutorial` 側の参照も一緒にずれる。

```bash
python3 tools/tutorial-code/shift.py <名前>.<拡張子> <N>
```

`.tutorial` からは次の形で参照する。`generate.py` は、使われていないスナップショットや `name`・`previousFile` の食い違いも検出する。

```text
@Code(name: "<#nameの値>", file: "<名前>-NN.<拡張子>", previousFile: "<名前>-(NN-1).<拡張子>")
```

## 英語版を揃える

英語版は `/en/` に公開している（[ADR 0010](./docs/adr/0010-english-catalog-with-language-switch.md)）。本文かコードを直したら、同じ PR で英語版も直す。

- 本文: `ios/Library/Documentation/en/AppFeature.docc/` の同じ名前のファイルを直す。セクション・ステップ・`@Code`・`@Image` の並びは日本語版と同じにする。
  章末プロンプト（`TutorialArt/NN-prompt.txt`）も英語版がある。英語版のプロンプトは `/en/` のURLと英語版の `.tutorial` のパスを指す。
- コード: 英語版のスナップショットは、同じ `.seq` の日本語を含む行を `tools/tutorial-code/en/<名前>.<拡張子>.en` の対訳で置き換えて作る。
  日本語の行を足したり変えたりしたら、対訳の組を足す（字下げは書かなくてよく、元の行のものが使われる）。

  ```text
  ja|// コンパイラがこの型を見つけて登録する。登録処理を呼ぶ必要は無い
  en|// The compiler finds and registers this type. There's no registration call to make
  ```

- `generate.py` は、日本語の行に対訳が無い・使われていない対訳がある・英語側に日本語が残っている・英語版の `.tutorial` の構成が日本語版と違う、のどれでもエラーにする。
- 英語版の章名では `【iOS 27.3 beta】` の代わりに ` [iOS 27.3 beta]` を、本文では「（iOS 27.3 beta）」の代わりに「(iOS 27.3 beta)」を使う。

## 本文の書き方の決まり

- `【iOS 27.3 beta】` は Siri AI Developer Preview を扱う章の章名の末尾にだけ付ける（例: `第7章: Siri AI Developer Preview【iOS 27.3 beta】`）。セクションには付けない。他の章で beta の API に触れるときは本文に「（iOS 27.3 beta）」と書く。
- `.tutorial` のファイル名を変えると公開 URL が変わり、旧 URL は 404 になる。改名したら日本語版・英語版の両方を同じ名前に変え、`tools/docc-redirects.sh` に `redirect <旧名> <新名>` を足す（両言語のサイトに転送ページが置かれる）。

## PR を出す前に確かめること

1. `python3 tools/tutorial-code/generate.py` がエラーなしで終わる
2. `python3 tools/skill/generate.py` で skill の `references/` を作り直し、差分もコミットする（CI の `skill-check.yml` が `--check` で古いままでないかを見る）
3. 日本語版と英語版の両方で `xcrun docc convert` が警告0件で通る

```bash
for catalog in ios/Library/Sources/AppFeature/AppFeature.docc ios/Library/Documentation/en/AppFeature.docc; do
  xcrun docc convert "$catalog" \
    --output-path /tmp/siri-ai-tutorials-docc \
    --fallback-display-name AppFeature \
    --fallback-bundle-identifier com.akidon0000.siri-ai-tutorials.AppFeature \
    --fallback-bundle-version 1.0 \
    --warnings-as-errors
done
```

CI（`docc-pages.yml`）は同じ変換に GitHub Pages 用のオプションを足して実行し、日本語版を `/siri-ai-tutorials/`、英語版を `/siri-ai-tutorials/en/` に置いて、`tools/docc-language-switch.sh` で全ページに言語切り替えを差し込む。PR でも変換までは実行する（公開はしない）。見た目を確かめたいなら、Xcode で `ios/Library` を開いて Build Documentation（⌃⇧⌘D）を使うのが早い。

`main` にマージされると GitHub Pages へ自動で再公開される。

## skill を直す

`plugins/siri-ai/` は、チュートリアルを Claude Code・APM・skills CLI から入れられる skill にしたもの。
`references/` は `.tutorial` と `.seq` から生成するので、本文やコードの誤りはチュートリアル側で直して生成し直す。
手で書くのは `SKILL.md`（章の見取り図・判断の分岐・間違えやすい点）だけで、章を足したり API が変わったりしたらここも揃える。
中身を変えたら `plugins/siri-ai/.claude-plugin/plugin.json`・`plugins/siri-ai/apm.yml`・`.claude-plugin/marketplace.json` の `version` を同じ値で上げる。

## Apple ドキュメントの原文

`docs/apple-doc/` は Apple Developer Documentation を1ページ1ファイルでそのまま保存したもので、改訂を `git diff` で追うために置いている。手で直すと差分の意味がなくなるので、再取得・ページの追加は Claude Code のスキル [update-apple-siri-docs](./.claude/skills/update-apple-siri-docs/SKILL.md) で行う。追跡中のページは [sources.yaml](./sources.yaml) にあり、各ページには `kind: article | tool` を付ける。原文の著作権の扱いは [DISCLAIMER.md](./DISCLAIMER.md) を参照。

## 構成を変えるとき

ディレクトリ構成・生成の仕組み・タグの付け方のような判断を変えるときは、`docs/adr/TEMPLATE/` を元に新しい番号で ADR を足し、[docs/adr/README.md](./docs/adr/README.md) の一覧も更新する。既存の判断を覆す場合も、古い ADR は書き換えずに状態を `Superseded` にする。

## Claude Code で作業する場合

このリポジトリの決まりは [CLAUDE.md](./CLAUDE.md) にも書いてあり、Claude Code はそれを読んで動く。この手引きの内容を変えたら CLAUDE.md も揃える。
