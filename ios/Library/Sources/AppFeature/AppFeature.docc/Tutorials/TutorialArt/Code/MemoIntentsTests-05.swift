import AppIntentsTesting
import XCTest

final class MemoIntentsTests: XCTestCase {
    let app = XCUIApplication()
    var definitions: IntentDefinitions!

    override func setUp() async throws {
        app.launch()
        definitions = IntentDefinitions(bundleIdentifier: "com.akidon0000.SiriAIPrototype")
    }

    func testCreateMemo() async throws {
        let result = try await definitions.intents["CreateMemoIntent"].makeIntent(title: "牛乳を買う").run()
        let title: String = try result.value.title
        XCTAssertEqual(title, "牛乳を買う")
    }

    func testFindMemoByName() async throws {
        let memos = try await definitions.entities["MemoEntity"].entities(matching: "牛乳")
        XCTAssertFalse(memos.isEmpty)
    }

    func testMemoIsIndexedInSpotlight() async throws {
        let indexed = try await definitions.entities["MemoEntity"].spotlightQuery("牛乳")
        XCTAssertFalse(indexed.isEmpty)
    }
}
