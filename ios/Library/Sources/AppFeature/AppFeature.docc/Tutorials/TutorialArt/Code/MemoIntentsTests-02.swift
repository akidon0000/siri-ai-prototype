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
}
