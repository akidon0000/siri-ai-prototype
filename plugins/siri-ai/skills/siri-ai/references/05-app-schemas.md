# 第5章: スキーマでApple Intelligenceに載せる

所要時間の目安: 35分。公開版: https://akidon0000.github.io/siri-ai-tutorials/tutorials/appfeature/05-app-schemas

## スキーマでApple Intelligenceに載せる

スキーマは、App Intents側が用意した「この種類のアプリならこの形のintentとEntity」という型紙で、アプリとシステムの間の契約になる。スキーマに合わせたintentはApple Intelligenceの「app toolbox」に入り、Siriはいろいろな言い回しをそのintentに結び付けられるようになる。この章では、Memoアプリを Reminders ドメインのスキーマに合わせる。

教材: `docs/apple-doc/apple-intelligence/apple-intelligence-and-siri-ai.md`、[App schema domains](https://developer.apple.com/documentation/appintents/app-schema-domains)、[Making actions and content discoverable by Apple Intelligence](https://developer.apple.com/documentation/appintents/making-actions-and-content-discoverable-by-apple-intelligence)、[Reminders](https://developer.apple.com/documentation/appintents/app-schema-domain-reminders)

## ドメインを選ぶ

スキーマは「ドメイン」ごとにまとまっている。まずアプリの機能に合うドメインを探す。

1. Siriで使えるPrimary domainは、Audio・Calendar・Camera・Clock・Mail・Maps・Messages・ Notes・Phone・Photos・Reminders・System and in-app search・Video。Books・Browser・Files・Journaling・Presentation・Reader・Spreadsheet・Whiteboard・ Word processorは、Shortcutsアプリでだけ使えるドメイン。この章で合わせるスキーマを、見取り図として先に並べておく。 — コード: `MemoSchemaMap.swift`
2. Memoは「タイトル」と「完了状態」を持つので、メモ帳のNotesより、完了・未完了を扱うRemindersが合う。Remindersには `createReminder`・`updateReminder`・ `deleteReminders` などのintentスキーマと、`reminder`・`list` などのEntityスキーマがある。ドメインの本来の目的に合わない機能には、スキーマを当てはめない。Primary domainのスキーマに合わせたアプリは、Siriからそのドメインのアプリとして扱われる。Notesにも `createNote`・`updateNote`・`appendText` があるので、完了や期限を持たない文章中心のメモなら、Notesのスキーマを選ぶ。 — コード: `MemoSchemaMap.swift`
3. Audio・Clock・Mail・Maps・Messagesには「use-case group」という、同じ目的のスキーマの組がある。Siri AIで使うには組の全てを採用する必要があり、一部だけを採用するとXcodeが欠けているスキーマごとにビルド警告を出す。Remindersにはこの組が無いので、Memoアプリでは気にしなくてよい。 — コード: `MemoSchemaMap.swift`
4. Xcodeで `reminders_` と入力すると、スキーマを選ぶ補完候補が出て、必要なプロパティが全て入ったテンプレートを展開できる。以降のコードはこのテンプレートから作る。 — コード: `MemoSchemaMap.swift`

### このセクションを終えた時点のコード

`MemoSchemaMap.swift`

```swift
import AppIntents

// Siriで使えるPrimary domain（Swiftでの書き方）:
//   .audio  https://developer.apple.com/documentation/appintents/app-schema-domain-audio
//   .calendar  https://developer.apple.com/documentation/appintents/app-schema-domain-calendar
//   .camera  https://developer.apple.com/documentation/appintents/app-schema-domain-camera
//   .clock  https://developer.apple.com/documentation/appintents/app-schema-domain-clock
//   .mail  https://developer.apple.com/documentation/appintents/app-schema-domain-mail
//   .maps  https://developer.apple.com/documentation/appintents/app-schema-domain-maps
//   .messages  https://developer.apple.com/documentation/appintents/app-schema-domain-messages
//   .notes  https://developer.apple.com/documentation/appintents/app-schema-domain-notes
//   .phone  https://developer.apple.com/documentation/appintents/app-schema-domain-phone
//   .photos  https://developer.apple.com/documentation/appintents/app-schema-domain-photos
//   .reminders  https://developer.apple.com/documentation/appintents/app-schema-domain-reminders
//   .system  https://developer.apple.com/documentation/appintents/app-schema-domain-system-and-in-app-search
//   Video（SDK 27.1に無い）  https://developer.apple.com/documentation/appintents/app-schema-domain-video
// これらのスキーマに合わせると、Siriにも公開される
@AppIntent(schema: .reminders.createReminder)
struct CreateMemoIntent { /* … */ }

// Shortcutsアプリでだけ使えるドメイン:
//   .books  https://developer.apple.com/documentation/appintents/app-schema-domain-books
//   .browser  https://developer.apple.com/documentation/appintents/app-schema-domain-browser
//   .files  https://developer.apple.com/documentation/appintents/app-schema-domain-files
//   .journal  https://developer.apple.com/documentation/appintents/app-schema-domain-journaling
//   .presentation  https://developer.apple.com/documentation/appintents/app-schema-domain-presentation
//   .reader  https://developer.apple.com/documentation/appintents/app-schema-domain-reader
//   .spreadsheet  https://developer.apple.com/documentation/appintents/app-schema-domain-spreadsheet
//   .whiteboard  https://developer.apple.com/documentation/appintents/app-schema-domain-whiteboard
//   .wordProcessor  https://developer.apple.com/documentation/appintents/app-schema-domain-word-processor
// これらのスキーマは、Siriには公開されない
@AppIntent(schema: .journal.createEntry)
struct CreateJournalEntryIntent { /* … */ }

// Memoは完了・未完了を持つので、NotesではなくRemindersのスキーマに合わせる
@AppEntity(schema: .reminders.reminder)
struct MemoEntity { /* … */ }
// 更新と削除も .reminders.updateReminder と .reminders.deleteReminders に合わせる
// Remindersのintentは createReminder・updateReminder・deleteReminders・createList・createSection の5つ
// EntityはreminderとlistとsectionとgroupとlocationTrigger、Enumは listType と locationTriggerEvent
// Notesにも createNote・updateNote・appendText と、note・folder・account のEntityがある
// 完了や期限を持たない文章中心のメモなら、Notesのスキーマが合う

// Mailのように use-case group を持つドメインでは、組のスキーマを全て採用する
// 一部だけを採用すると、欠けているスキーマごとにビルド警告が出る

// Xcodeで reminders_ と入力して補完からスキーマを選ぶと、必要なプロパティが全て入ったテンプレートが展開される
```

## Entityをスキーマに合わせる

`reminder` スキーマは、リマインダーが所属するリスト（`list`）を必須にしている。先にリスト側のEntityとEnumを作り、そのあとで `MemoEntity` をスキーマに合わせる。

1. リストの種類を表すEnumに `@AppEnum(schema: .reminders.listType)` を付ける。`AppEnum` への準拠はマクロが付けるので、自分では書かない。 — コード: `MemoListType.swift`
2. メモのリストを表すEntityに `@AppEntity(schema: .reminders.list)` を付ける。スキーマが決めたプロパティ（`id`・`name`）は、名前も型もスキーマ通りにする。 — コード: `MemoListEntity.swift`
3. 残りの必須プロパティ `type` と `displayRepresentation` を足す。 — コード: `MemoListEntity.swift`
4. `defaultQuery` を足す。`MemoListQuery` は第2章の `MemoQuery` と同じ形で作る。 — コード: `MemoListEntity.swift`
5. `MemoEntity` に `@AppEntity(schema: .reminders.reminder)` を付け、`AppEntity` への準拠を外す。あわせて `typeDisplayRepresentation` も削除する。どちらもXcodeが展開するテンプレートには含まれていない。 — コード: `MemoEntity.swift`
6. スキーマでは完了状態の名前が `isCompleted` なので、`isDone` から名前を変える。`displayRepresentation` の中の参照も合わせて直す。必須プロパティが欠けていたり名前が違ったりすると、マクロがビルドエラーにして教えてくれる。 — コード: `MemoEntity.swift`
7. スキーマが求めるプロパティを足していく。まず `note`・`tags`・`urls`・`dueDate`・`recurrence`。Memoアプリが対応していない機能も、プロパティ自体は用意して `nil` や空の値を返せばよい。 — コード: `MemoEntity.swift`
8. 続けて `isFlagged`・`creationDate`・`completionDate`・`list`・`locationTrigger` を足す。`list` には先ほど作った `MemoListEntity` を使う。`locationTrigger` の型 `MemoLocationTriggerEntity` も `.reminders.locationTrigger` スキーマに合わせたEntityとして別に作る必要がある（作り方は `MemoListEntity` と同じなので省略する）。 — コード: `MemoEntity.swift`
9. 名前を変えた `isCompleted` に合わせて、第4章の `MemoSnippetView` も直す。 — コード: `MemoSnippetView.swift`

### このセクションを終えた時点のコード

`MemoListType.swift`

```swift
import AppIntents

// Remindersドメインの listType スキーマ。AppEnum への準拠はマクロが付ける
@AppEnum(schema: .reminders.listType)
enum MemoListType: String {
    case standard

    static let caseDisplayRepresentations: [Self: DisplayRepresentation] = [.standard: "通常"]
}
```

`MemoListEntity.swift`

```swift
import AppIntents

// Remindersドメインの list スキーマ。id と name は名前も型もスキーマ通りにする
@AppEntity(schema: .reminders.list)
struct MemoListEntity {
    let id: UUID
    var name: String
    var type: MemoListType

    var displayRepresentation: DisplayRepresentation {
        DisplayRepresentation(title: "\(name)")
    }

    static let defaultQuery = MemoListQuery()
}
```

`MemoEntity.swift`

```swift
import AppIntents

// Remindersドメインの reminder スキーマに合わせる。AppEntity への準拠はマクロが付ける
@AppEntity(schema: .reminders.reminder)
struct MemoEntity {
    // システムがこのメモを指すときに使う、変わらないID
    let id: UUID
    var title: String
    // スキーマでの完了状態の名前は isCompleted
    var isCompleted: Bool
    var sharedWith: [String]
    // ここからはスキーマが求めるプロパティ。対応していない機能は nil や空の値を返す
    var note: AttributedString?
    var tags: Set<String>
    var urls: [URL]
    var dueDate: DateComponents?
    var recurrence: Calendar.RecurrenceRule?
    var isFlagged: Bool?
    var creationDate: Date?
    var completionDate: Date?
    var list: MemoListEntity
    var locationTrigger: MemoLocationTriggerEntity?

    // Siriの応答・候補の一覧・Spotlightでメモ1件を表示するときの見た目
    var displayRepresentation: DisplayRepresentation {
        DisplayRepresentation(
            title: "\(title)",
            subtitle: isCompleted ? "完了" : "未完了",
            image: .init(systemName: isCompleted ? "checkmark.circle.fill" : "circle")
        )
    }

    // Siriが名前やIDからメモを探すときに使うクエリ
    static let defaultQuery = MemoQuery()
}
```

`MemoSnippetView.swift`

```swift
import SwiftUI

// Siriの結果に出すビュー。アプリの画面より小さく、要点だけを見せる
struct MemoSnippetView: View {
    let memo: MemoEntity

    var body: some View {
        HStack {
            Label(memo.title, systemImage: memo.isCompleted ? "checkmark.circle.fill" : "circle")
            // ボタンにintentを渡すと、押したときにアプリを開かずにそのintentが実行される
            Button("完了", intent: CompleteMemoIntent(memo: memo))
        }
    }
}
```

## intentをスキーマに合わせる

`AddMemoIntent` は `priority` を持つが、`createReminder` スキーマには優先度が無い。スキーマに合わないプロパティを持つ既存のintentを書き換えると、それを使っているショートカットが壊れる。Appleが勧めるのは、スキーマ対応のintentを別に作って並べる方法。

1. 新しい `CreateMemoIntent` に `@AppIntent(schema: .reminders.createReminder)` を付ける。スキーマのプロパティは `@Parameter` を書かず、普通のプロパティとして宣言する。システムは `perform()` を呼ぶ前に、これらのプロパティに値を入れる。 — コード: `CreateMemoIntent.swift`
2. スキーマが定める残りのプロパティを足す。まず `note`・`isFlagged`・`images`・`tags`・`urls`。 — コード: `CreateMemoIntent.swift`
3. 続けて `dueDate`・`recurrence`・`locationTrigger`・`section`。`section` も `.reminders.section` スキーマに合わせたEntityを別に用意する。Apple Intelligenceが使うのはスキーマが定めるプロパティだけで、それ以外に足したオプショナルなプロパティはShortcutsアプリだけが使う。 — コード: `CreateMemoIntent.swift`
4. `perform()` を書く。戻り値は、`MemoEntity` を返す `ReturnsValue<MemoEntity>`。 — コード: `CreateMemoIntent.swift`
5. `isAssistantOnly` を `true` にする。このintentはShortcutsアプリに出なくなり、Siri（Apple Intelligence）からだけ使われる。Shortcutsには旧 `AddMemoIntent` が残るので、同じ操作が2つ並ぶことは無い。利用者がショートカットを移し終えたら、この行を消して旧intentを廃止する。 — コード: `CreateMemoIntent.swift`
6. メモの完了は `updateReminder` スキーマの `isCompleted` で表す。`UpdateMemoIntent` を作り、対象の `target` と `isCompleted` から書き始める。 — コード: `UpdateMemoIntent.swift`
7. `title`・`note`・`tags`・`urls`・`dueDate` を足す。更新のスキーマなので、どのプロパティもオプショナルで、`nil` は「変更しない」を意味する。 — コード: `UpdateMemoIntent.swift`
8. 残りの `recurrence`・`isFlagged`・`list`・`locationTrigger` を足す。 — コード: `UpdateMemoIntent.swift`
9. `perform()` を書く。これで「このメモを完了にして」「期限を明日にして」が、同じ `UpdateMemoIntent` で処理される。 — コード: `UpdateMemoIntent.swift`
10. 第4章の `DeleteMemoIntent` を `deleteReminders` スキーマに合わせる。準拠先を `DeleteIntent` に変え、`title` と `@Parameter` を削除して、スキーマが定める `entities`（削除するメモの配列）に置き換える。まだ配布していないintentなのでその場で書き換えたが、配布済みなら `CreateMemoIntent` と同じく別のintentを作って並べる。 — コード: `DeleteMemoIntent.swift`

### このセクションを終えた時点のコード

`CreateMemoIntent.swift`

```swift
import AppIntents

@AppIntent(schema: .reminders.createReminder)
struct CreateMemoIntent {
    // スキーマのプロパティ。perform() を呼ぶ前にシステムが値を入れる
    var title: String
    var list: MemoListEntity?
    var note: AttributedString?
    var isFlagged: Bool?
    var images: [IntentFile]
    var tags: Set<String>
    var urls: [URL]
    var dueDate: DateComponents?
    var recurrence: Calendar.RecurrenceRule?
    var locationTrigger: MemoLocationTriggerEntity?
    // section も .reminders.section スキーマに合わせたEntityを使う
    var section: MemoSectionEntity?

    // Shortcutsアプリには出さず、Siriからだけ使う。Shortcutsには旧 AddMemoIntent が残る
    static let isAssistantOnly: Bool = true

    func perform() async throws -> some ReturnsValue<MemoEntity> {
        let memo = try await MemoStore.shared.add(title: title, list: list, dueDate: dueDate)
        // スキーマは作ったリマインダー（MemoEntity）を返すことを求める
        return .result(value: memo)
    }
}
```

`UpdateMemoIntent.swift`

```swift
import AppIntents

// 完了・期限・タイトルなどの変更を、この1つのintentで受ける
@AppIntent(schema: .reminders.updateReminder)
struct UpdateMemoIntent {
    var target: MemoEntity
    // 更新のスキーマなので全てオプショナル。nil は「変更しない」
    var isCompleted: Bool?
    var title: String?
    var note: AttributedString?
    var tags: Set<String>?
    var urls: [URL]?
    var dueDate: DateComponents?
    var recurrence: Calendar.RecurrenceRule?
    var isFlagged: Bool?
    var list: MemoListEntity?
    var locationTrigger: MemoLocationTriggerEntity?

    func perform() async throws -> some ReturnsValue<MemoEntity> {
        let memo = try await MemoStore.shared.update(target.id, title: title, isCompleted: isCompleted)
        return .result(value: memo)
    }
}
```

`DeleteMemoIntent.swift`

```swift
import AppIntents

// 複数のメモを消す deleteReminders スキーマ。準拠先は DeleteIntent
@AppIntent(schema: .reminders.deleteReminders)
struct DeleteMemoIntent: DeleteIntent {
    var entities: [MemoEntity]

    func perform() async throws -> some IntentResult {
        // 消す前に確認する。取り消されると例外が投げられ、次の行は実行されない
        try await requestConfirmation(dialog: "\(entities.count)件のメモを削除しますか？")
        try await MemoStore.shared.delete(entities.map(\.id))
        return .result()
    }
}
```

## 検索と表示をスキーマに乗せる

System and in-app searchドメインは、アプリの種類を問わず使える。どのドメインにも当てはまらないアプリでも、検索と表示はSiriに任せられる。

1. `SearchMemosIntent` に `@AppIntent(schema: .system.searchInApp)` を付け、`ShowInAppSearchResultsIntent` に準拠させる。`criteria` には、人がSiriに言った検索語が入る。 — コード: `SearchMemosIntent.swift`
2. `perform()` でアプリの検索画面を開き、`criteria.term` で検索する。「メモで買い物を探して」と言われたとき、Siriの検索結果ではなくアプリ自身の検索画面で結果を見せられる。 — コード: `SearchMemosIntent.swift`
3. `OpenMemoIntent` に `@AppIntent(schema: .system.open)` を付け、`OpenIntent` に準拠させる。`target` が開く対象のメモ。 — コード: `OpenMemoIntent.swift`
4. `perform()` で該当のメモの画面を開く。第6章でSpotlightに載せたメモをタップしたときや、ビジュアルインテリジェンスの検索結果から開くときにも、このintentが使われる。 — コード: `OpenMemoIntent.swift`

### このセクションを終えた時点のコード

`SearchMemosIntent.swift`

```swift
import AppIntents

// .system.searchInApp: 「〜をアプリで検索して」で呼ばれ、アプリ内の検索結果を開く
@AppIntent(schema: .system.searchInApp)
struct SearchMemosIntent: ShowInAppSearchResultsIntent {
    static let searchScopes: [StringSearchScope] = [.general]
    // 検索語は criteria.term に入る
    var criteria: StringSearchCriteria

    func perform() async throws -> some IntentResult {
        await MemoNavigator.shared.showSearchResults(for: criteria.term)
        return .result()
    }
}
```

`OpenMemoIntent.swift`

```swift
import AppIntents

// .system.open: 検索結果のメモをタップしたときなどに、アプリでそのメモを開く
@AppIntent(schema: .system.open)
struct OpenMemoIntent: OpenIntent {
    var target: MemoEntity

    func perform() async throws -> some IntentResult {
        await MemoNavigator.shared.show(target.id)
        return .result()
    }
}
```

## 参考: 日本だけのサイドボタン起動

Assistantドメインの `activate` スキーマは、iPhoneのサイドボタンを長押ししたときに音声で会話するアプリを起動させるもので、日本でだけ使える。Memoアプリは音声対話アプリではないので採用しないが、日本向けのSiri関連の機能として形だけ確認しておく。

1. `@AppIntent(schema: .assistant.activate)` を付け、`supportedModes` を `.foreground` にする。利用には `com.apple.developer.side-button-access.allow` entitlementが必要で、本番ではApple Accountの国または地域が日本で、日本国内にいる必要がある。 — コード: `ActivateConversationIntent.swift`
2. `perform()` では会話の画面を開き、すぐに話せるようにオーディオセッションを始める。 — コード: `ActivateConversationIntent.swift`

### このセクションを終えた時点のコード

`ActivateConversationIntent.swift`

```swift
import AppIntents

// 日本でサイドボタンを長押ししたときに呼ばれる。entitlementの申請が要る
@AppIntent(schema: .assistant.activate)
struct ActivateConversationIntent {
    static let supportedModes: IntentModes = .foreground

    func perform() async throws -> some IntentResult {
        await ConversationController.shared.startListening()
        return .result()
    }
}
```

## 次のステップ

MemoをRemindersドメインのスキーマに対応させてもらう。

1. 理解できたらこれをClaude Codeに貼る。実装から、ビルドと動作確認までを任せる。

### ワークショップ用プロンプト

チュートリアルのリポジトリ（akidon0000/siri-ai-tutorials）を clone した上で
Claude Code に渡すためのもの。自分のアプリで進めるときは、パスとターゲット名を読み替える。

```text
【ワークショップ】Siri AI Tutorials 第5章: スキーマでApple Intelligenceに載せる

チュートリアル: https://akidon0000.github.io/siri-ai-tutorials/tutorials/appfeature/05-app-schemas
リポジトリ: https://github.com/akidon0000/siri-ai-tutorials （clone済みのこのディレクトリで進める）

先に上のチュートリアルを読んで、コードの組み立て順と「なぜそう書くか」を把握する。
読めないときは ios/Library/Sources/AppFeature/AppFeature.docc/Tutorials/05-app-schemas.tutorial を読む。
合わせて読む原文:
  - docs/apple-doc/apple-intelligence/apple-intelligence-and-siri-ai.md
  - https://developer.apple.com/documentation/appintents/app-schema-domain-reminders
チュートリアルの MemoStore は、このリポジトリでは Clients の MemoClient と ClientsLive の LiveMemoClient に当たる。

## 作る
Memo を App Intents の Reminders ドメインのスキーマに対応させる。

- MemoListType (@AppEnum(schema: .reminders.listType)) と MemoListEntity (@AppEntity(schema: .reminders.list)) を追加する
- MemoEntity に @AppEntity(schema: .reminders.reminder) を付け、isDone を isCompleted に改名し、スキーマの必須プロパティを揃える
- locationTrigger / section 用に .reminders.locationTrigger / .reminders.section スキーマのEntityも用意する
- CreateMemoIntent (.reminders.createReminder) を新しく作り、isAssistantOnly = true にする（AddMemoIntent は残す）
- UpdateMemoIntent (.reminders.updateReminder) を追加する
- DeleteMemoIntent を .reminders.deleteReminders に合わせる
- SearchMemosIntent (.system.searchInApp) と OpenMemoIntent (.system.open) を追加する
- 各スキーマのテンプレートは Xcode の補完（reminders_ / system_）で展開したものと突き合わせる
- 既存のテストと TestMemoClient を新しいプロパティに合わせて直す

## 動かして確かめる
1. 単体テスト: `cd ios/Library && xcodebuild test -scheme Library -destination 'platform=iOS Simulator,name=iPhone 18 Pro'`
   （シミュレータ名は `xcrun simctl list devices available` で今あるiPhoneに合わせてよい）
2. アプリをビルドしてシミュレータで起動する:
   `cd ios/App && xcodebuild build -scheme SiriAIPrototype -destination 'platform=iOS Simulator,name=iPhone 18 Pro' -derivedDataPath build`
   `xcrun simctl boot 'iPhone 18 Pro' ; open -a Simulator ; xcrun simctl install booted ios/App/build/Build/Products/Debug-iphonesimulator/SiriAIPrototype.app ; xcrun simctl launch booted com.akidon0000.SiriAIPrototype`
   起動後に `xcrun simctl io booted screenshot` で画面を撮って確認する。
3. スキーマに必須のプロパティや型が足りないとビルドで落ちる。エラーが出たら、メッセージの指示どおりに直して通す。
   直した内容（どのスキーマの何が足りなかったか）を報告に書く。
4. ショートカットアプリのアクション一覧に、追加したIntent（CreateMemoIntent は assistantOnly なので出ない）が期待どおりに出る・出ないことを確かめる。
   UIを操作できるツールが無ければ、この手順をユーザーに案内して結果を聞く。

終わったら、次の3つに分けて報告する。
- 作ったもの（追加・変更したファイル）
- 動かして確認できたこと（実行したコマンドと結果、スクリーンショット）
- 確認できなかったこと（理由つき）。確認していないことを「動いた」と書かない
```
