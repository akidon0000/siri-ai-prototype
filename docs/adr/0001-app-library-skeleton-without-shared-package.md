---
title: "Siri PoCをApp+Library構成で作り、Android共有用sharedパッケージは作らない"
status: Accepted
proposed: 2026-11-04
accepted: 2026-11-04
supersedes:
issue:
---

# Siri PoCをApp+Library構成で作り、Android共有用sharedパッケージは作らない

## Decision（決定事項）

### 決定事項

`ios/App`（Xcodeアプリ本体）+ `ios/Library`（SPMパッケージ、Clients/ClientsLive/Components/
AppFeature/TestSuportターゲット）という構成でSiri PoCを作る。akidon0000の既存アプリ
`pickle-app` と同じパターンを踏襲するが、Android共有用の `shared` パッケージ、CI、
TestFlight配信は作らない。

### 比較・検討内容の要約

pickle-appの構成をそのまま複製する案（shared/CI/配信込み）と、Xcodeプロジェクト1つに
まとめる最小構成案も検討したが、「学習のためのPoCであり、Android展開もCI/配信も予定がない」
という目的に対して過不足のないApp+Libraryのみの構成を採用した。

## Context（経緯・背景情報）

### 背景

このリポジトリ (`siri-ai-prototype`) は、Apple Developer Documentationの
Siri/SiriKit/App Intents/Apple Intelligence (Siri AI)/Shortcuts関連ページを
`docs/` 配下に原文保存している。次のステップとして、それらを教材にしたSiri関連の
PoCをこのリポジトリに追加したい、という依頼があった。

### 課題

1. **ゼロから設計すると参考にできるものがない**
   - akidon0000には既にiOSアプリ `pickle-app` があり、App+Library(SPM)+shared(Android)
     +docs/adrという構成と、Observable Models + Clientsのアーキテクチャパターンが
     確立している。これをそのまま流用できれば設計コストを下げられる。

## Consideration（比較・検討内容）

### 比較対象

| 案 | ソリューション | 概要 |
|----|----------------|------|
| 案1 | pickle-appと完全に同じ構成 | shared(Android共有)、CI、TestFlight配信も含めて複製する |
| 案2 | **App + Libraryのみ** | pickle-appのiOS側の構成（App+Library, Clients/ClientsLive/Components/AppFeature/TestSupport）だけを採用する |
| 案3 | Xcodeプロジェクト1つの最小構成 | App/Libraryを分けず、1つのXcodeプロジェクトに全ソースを入れる |

### 比較表

| 評価項目 | 案1 完全複製 | 案2 App+Libraryのみ | 案3 単一Xcodeプロジェクト |
|----------|--------------|----------------------|----------------------------|
| PoCとしての身軽さ | 悪い。Android/CI/配信の設定が学習の本題と無関係に増える | 良い。iOS固有の学習に集中できる | 良いが、Clients/ClientsLive分離によるテスト容易性を失う |
| 将来App+Libraryパターンで実装を進める際の助走 | 同じだが過剰 | ちょうどよい。Tutorial内のプロンプトがそのままLibraryの各ターゲットを指定できる | 弱い。後からターゲット分割が必要になる |
| pickle-appとの比較学習のしやすさ | 良いが差分が大きすぎて何が本質か見えにくい | 良い。同じ形のまま中身だけPoC用に空にしてある | 悪い。構造から異なる |

### 総合評価

| 案 | 総合評価 | 判定 |
|----|----------|------|
| 案1: 完全複製 | PoCの目的に対して過剰 | **不採用** |
| 案2: App+Libraryのみ | 目的に対して過不足ない | **採用** |
| 案3: 単一Xcodeプロジェクト | 最速だが後で分割し直すコストが高い | **不採用** |

## Consequences（結果）

### 期待される効果

1. pickle-appのアーキテクチャ（Clients/ClientsLive分離によるテスト容易性）を
   最初から踏襲した状態でSiri実装を始められる。
2. DocCチュートリアル内のコピペプロンプトが、具体的なターゲット名
   （`Clients/MemoClient.swift` など）を指定できる。

### 技術的リスクと対策

| リスク | 内容 | 対策 |
|--------|------|------|
| 新しいXcodeプロジェクトファイル形式(`project.xcproj`)を手書きしている | Xcode 27で導入された新形式を、pickle-appの実ファイルを参考に手書きで作成した | `xcodebuild build` と実機シミュレータ起動で動作確認済み。壊れたらXcode GUIで開き直して再生成すればよい |

## References（参照）

- 関連ADR: 0002-docc-tutorial-defers-siri-implementation.md
- 外部: akidon0000/pickle-app (`ios/App`, `ios/Library`, `docs/adr/0009-ios-architecture-observable-models-and-clients.md`)
