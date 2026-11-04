// アプリの型はimportしない。intentやEntityは名前の文字列で引く
import AppIntentsTesting
import XCTest

final class MemoIntentsTests: XCTestCase {
    let app = XCUIApplication()
    var definitions: IntentDefinitions!
}
