// アプリの型はimportしない。intentやEntityは名前の文字列で引く
import AppIntentsTesting
import XCTest

final class MemoIntentsTests: XCTestCase {
    let app = XCUIApplication()
    var definitions: IntentDefinitions!

    override func setUp() async throws {
        app.launch()
        // アプリが登録したintent・Entity・Enum・クエリを、バンドルIDから読み込む
        definitions = IntentDefinitions(bundleIdentifier: "com.akidon0000.SiriAIPrototype")
    }

    // SiriやShortcutsと同じ経路で、アプリの外からintentを実行する
    func testCreateMemo() async throws {
        let result = try await definitions.intents["CreateMemoIntent"].makeIntent(title: "牛乳を買う").run()
        let title: String = try result.value.title
        XCTAssertEqual(title, "牛乳を買う")
    }
}
