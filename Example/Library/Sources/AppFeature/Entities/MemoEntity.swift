import AppIntents
import Clients
import CoreSpotlight

// Remindersドメインの reminder スキーマに合わせる。AppEntity への準拠はマクロが付ける
// IndexedEntity・Transferable への準拠は MemoEntity+Spotlight.swift と MemoEntity+Transferable.swift
@AppEntity(schema: .reminders.reminder)
public struct MemoEntity: Sendable {
    // システムがこのメモを指すときに使う、変わらないID
    public let id: UUID
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

    // スキーマに無い値も、@Property を付ければSiriに見せられる
    @Property(title: "優先度")
    var priority: MemoPriority

    // 27.3 beta では、本文を含む応答の前に端末の認証（Face IDなど）を求める
    // 27.1 には認証を求める指定が無いので、@Property を付けずにSiriへは見せない
    #if SIRI_AI_PREVIEW
    @Property(title: "鍵付きメモの本文", description: "ロックしたメモの本文",
              authenticationPolicy: .requiresLocalDeviceAuthentication)
    #endif
    var lockedBody: String?

    // アプリとそのextensionの中だけで使う値。Siri・Shortcutsには見せない
    // internal の property には indexingKey / customIndexingKey を組み合わせない
    #if SIRI_AI_PREVIEW
    @Property(title: "同期リビジョン", visibility: .internal)
    #endif
    var revision: Int

    // 保存していない値を、計算してSiriに見せる
    #if SIRI_AI_PREVIEW
    @ComputedProperty(title: "期限切れ", description: "期限を過ぎていて、まだ完了していなければtrue")
    #else
    @ComputedProperty(title: "期限切れ")
    #endif
    var isOverdue: Bool {
        guard !isCompleted, let dueDate, let date = Calendar.current.date(from: dueDate) else { return false }
        return date < .now
    }

    // 本文をSpotlightの contentDescription として索引に入れる
    #if SIRI_AI_PREVIEW
    @ComputedProperty(title: "本文", description: "メモの本文のテキスト", indexingKey: \.contentDescription)
    #else
    @ComputedProperty(title: "本文", indexingKey: \.contentDescription)
    #endif
    var noteText: String {
        note.map { String($0.characters) } ?? ""
    }

    // Spotlightに当てはまる属性が無いので、アプリ独自のキーで索引に入れる
    #if SIRI_AI_PREVIEW
    @ComputedProperty(title: "リスト名", description: "メモが入っているリストの名前",
                      customIndexingKey: CSCustomAttributeKey(keyName: "com_akidon0000_SiriAIPrototype_MemoEntity_listName")!)
    #else
    @ComputedProperty(title: "リスト名",
                      customIndexingKey: CSCustomAttributeKey(keyName: "com_akidon0000_SiriAIPrototype_MemoEntity_listName")!)
    #endif
    var listName: String {
        list.name
    }

    #if SIRI_AI_PREVIEW
    // サーバーへの問い合わせが要る値。Siriが必要としたときだけ取りに来る
    // indexingKey が無いので、Spotlightの索引には入らない
    // 27.1 には認証を求める指定が無いので、27.3 beta でだけ公開する
    @DeferredProperty(title: "共有相手", description: "このメモを共有している人の名前", authenticationPolicy: .requiresAuthentication)
    var collaboratorNames: [String] {
        get async throws {
            try await MemoStore.shared.displayNames(for: sharedWith)
        }
    }
    #endif

    // indexingKey を付けると索引に入る。索引を作るたびに取りに来るので、すぐ返せる値にする
    #if SIRI_AI_PREVIEW
    @DeferredProperty(title: "添付の文字", description: "添付した画像から読み取った文字", indexingKey: \.textContent)
    #else
    @DeferredProperty(title: "添付の文字", indexingKey: \.textContent)
    #endif
    var attachmentText: String {
        get async throws {
            try await MemoStore.shared.recognizedText(for: id)
        }
    }

    public var displayRepresentation: DisplayRepresentation {
        DisplayRepresentation(
            title: "\(title)",
            subtitle: isCompleted ? "完了" : "未完了",
            // 画像データを渡すと、SF Symbols以外の絵も出せる
            image: .init(data: MemoImageRenderer.thumbnail(isCompleted: isCompleted))
        )
    }

    public static let defaultQuery = MemoQuery()
}

extension MemoEntity {
    nonisolated init(_ memo: Memo, list: MemoList = .default) {
        // マクロがスキーマのプロパティを @Property に変えるので、スキーマ外の保存プロパティを先に入れる
        id = memo.id
        sharedWith = memo.sharedWith
        lockedBody = memo.lockedBody
        revision = memo.revision
        title = memo.title
        isCompleted = memo.isCompleted
        note = memo.note.map { AttributedString($0) }
        tags = memo.tags
        urls = []
        dueDate = memo.dueDate
        recurrence = nil
        isFlagged = memo.isFlagged
        creationDate = memo.creationDate
        completionDate = memo.completionDate
        self.list = MemoListEntity(list)
        locationTrigger = nil
        priority = MemoPriority(memo.priority)
    }
}
