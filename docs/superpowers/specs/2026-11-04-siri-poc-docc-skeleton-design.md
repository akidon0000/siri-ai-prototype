# Siri PoC: App+Libraryスケルトン + DocCチュートリアル設計

## 背景

このリポジトリ (`siri-ai-prototype`) は Apple Developer Documentation の Siri / SiriKit /
App Intents / Apple Intelligence (Siri AI) / Shortcuts 関連ページを `docs/` 配下に
原文保存している（`update-apple-siri-docs` スキル）。

次のステップとして、Siri 関連機能を実際に動かす PoC を同リポジトリに作る。ただし今回は
Siri 機能の実装そのものは行わない。代わりに、保存済みドキュメントを教材にした
DocC チュートリアルを作り、読んで理解した上でユーザーが選んだ範囲だけ、
チュートリアル内の「コピペ用プロンプト」を使って後から実装を指示できるようにする。

## 決定事項

- アーキテクチャは `pickle-app`（akidon0000の既存iOSアプリ）の `ios/App` + `ios/Library`
  (SPM, Clients/ClientsLive/Components/AppFeature/TestSupport) パターンを踏襲する。
  Android共有用の `shared/` パッケージ、CI、TestFlight配信は対象外（PoCのため）。
- `ios/Library` の各ターゲットは今回はビルドが通るだけの空スケルトン（TODOコメント付き）。
  Siri関連の実装コードは書かない。
- DocCチュートリアルは `ios/Library/Sources/AppFeature/AppFeature.docc/` に置く。
  Tutorial形式（`@Tutorials` / `@Chapter` / `@Tutorial`）で以下5章を作る。各章は
  既存の `docs/` ページを教材として参照し、章末に「理解したらコピペして実装を指示する」
  プロンプトのコードブロックを置く。

  1. SiriKitの限界 — 教材: `docs/sirikit/sirikit.md`
  2. App Intentsの基礎（Intent/Entity/Enum） — 教材: `docs/app-intents/app-intents.md`
  3. App Shortcutsでフレーズを固定する — 教材: `docs/shortcuts/app-shortcuts.md`
  4. Apple IntelligenceとSiri AIへの統合 — 教材: `docs/apple-intelligence/apple-intelligence-and-siri-ai.md`, `apple-intelligence.md`
  5. Siri AI Developer PreviewのToolIntent — 教材: `docs/apple-intelligence/siri-ai-developer-preview.md`

  作中の例で扱うドメインは「メモ（追加・一覧・完了）」。状態を持つApp Entityと
  複数Intentの連携例として適切で、Tutorial 5のToolIntent例にも自然に繋がる。

- このPoC固有の構成決定は `docs/adr/` にADRとして残す（既存の `docs/sirikit/` 等の
  ドキュメント原文アーカイブとは別のサブディレクトリなので衝突しない）。

## 検証方法

- `swift build`（`ios/Library` 単体）でスケルトンがビルドできることを確認。
- `docc preview` または `swift package generate-documentation` で DocC カタログが
  ビルド・表示できることを確認。
- Xcode App shell (`ios/App`) は本設計の後続ステップで作成し、シミュレータでの起動を確認する。

## スコープ外

- Siri/SiriKit/App Intentsの実機能実装（チュートリアル内のコピペプロンプトで後日行う）
- Android共有パッケージ (`shared/`)
- CI/CD、TestFlight配信
