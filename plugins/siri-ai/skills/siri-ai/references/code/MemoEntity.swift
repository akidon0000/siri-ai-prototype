import AppIntents
import CoreSpotlight

// Remindersドメインの reminder スキーマに合わせる。AppEntity への準拠はマクロが付ける
@AppEntity(schema: .reminders.reminder)
// IndexedEntity にすると、Spotlightの索引に入れられる
struct MemoEntity: IndexedEntity {
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

    // 本文を含む応答の前に、端末の認証（Face IDなど）を求める
    @Property(title: "鍵付きメモの本文", description: "ロックしたメモの本文",
              authenticationPolicy: .requiresLocalDeviceAuthentication)
    var lockedBody: String?

    // アプリとそのextensionの中だけで使う値。Siri・Shortcutsには見せない
    @Property(title: "同期リビジョン", visibility: .internal)
    var revision: Int

    // 保存していない値を、計算してSiriに見せる
    @ComputedProperty(title: "期限切れ", description: "期限を過ぎていて、まだ完了していなければtrue")
    var isOverdue: Bool {
        !isCompleted && (dueDate?.date.map { $0 < .now } ?? false)
    }

    // 本文をSpotlightの contentDescription として索引に入れる
    @ComputedProperty(title: "本文", description: "メモの本文のテキスト", indexingKey: \.contentDescription)
    var noteText: String {
        note.map { String($0.characters) } ?? ""
    }

    // Spotlightに当てはまる属性が無いので、アプリ独自のキーで索引に入れる
    @ComputedProperty(title: "リスト名", description: "メモが入っているリストの名前",
                      customIndexingKey: CSCustomAttributeKey(keyName: "com_akidon0000_SiriAIPrototype_MemoEntity_listName")!)
    var listName: String {
        list.name
    }

    // サーバーへの問い合わせが要る値。Siriが必要としたときだけ取りに来る
    // indexingKey が無いので、Spotlightの索引には入らない
    @DeferredProperty(title: "共有相手", description: "このメモを共有している人の名前", authenticationPolicy: .requiresAuthentication)
    var collaboratorNames: [String] {
        get async {
            await MemoStore.shared.displayNames(for: sharedWith)
        }
    }

    // indexingKey を付けると索引に入る。索引を作るたびに取りに来るので、すぐ返せる値にする
    @DeferredProperty(title: "添付の文字", description: "添付した画像から読み取った文字", indexingKey: \.textContent)
    var attachmentText: String {
        get async {
            await MemoStore.shared.recognizedText(for: id)
        }
    }

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
