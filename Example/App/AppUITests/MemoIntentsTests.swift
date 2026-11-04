// アプリの型はimportしない。intentやEntityは名前の文字列で引く
import AppIntents
import AppIntentsTesting
import XCTest

// XCUIApplication はメインアクターで扱う
@MainActor
final class MemoIntentsTests: XCTestCase {
    let app = XCUIApplication()
    var definitions: IntentDefinitions!

    override func setUp() async throws {
        app.launch()
        // アプリが登録したintent・Entity・Enum・クエリを、バンドルIDから読み込む
        definitions = IntentDefinitions(bundleIdentifier: "com.akidon0000.SiriAIPrototype")
        // どのテストも同じ初期データから始める
        _ = try await definitions.intents["ResetMemosIntent"].makeIntent().run()
    }

    // SiriやShortcutsと同じ経路で、アプリの外からintentを実行する
    func testCreateMemo() async throws {
        // images・tags・urls はスキーマが必須にしているので、空の値を渡さないと値を聞き返されて失敗する
        let result = try await definitions.intents["CreateMemoIntent"]
            .makeIntent(title: "卵を買う", images: [IntentFile](), tags: [String](), urls: [URL]())
            .run()
        let title: String = try result.value.title
        XCTAssertEqual(title, "卵を買う")
    }

    // Siriが名前を聞き取ったときと同じ探し方で、メモが見つかるか
    func testFindMemoByName() async throws {
        let memos = try await definitions.entities["MemoEntity"].entities(matching: "牛乳")
        XCTAssertFalse(memos.isEmpty)
    }

    func testMemoIsIndexedInSpotlight() async throws {
        let indexed = try await definitions.entities["MemoEntity"].spotlightQuery("牛乳")
        XCTAssertFalse(indexed.isEmpty)
    }
}
