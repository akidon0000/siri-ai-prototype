// Don't import the app's types. Look up intents and entities by name strings
import AppIntentsTesting
import XCTest

final class MemoIntentsTests: XCTestCase {
    let app = XCUIApplication()
    var definitions: IntentDefinitions!

    override func setUp() async throws {
        app.launch()
        // Load the intents, entities, enums and queries the app registered, from its bundle ID
        definitions = IntentDefinitions(bundleIdentifier: "com.akidon0000.SiriAIPrototype")
    }

    // Run the intent from outside the app, through the same path as Siri and Shortcuts
    func testCreateMemo() async throws {
        let result = try await definitions.intents["CreateMemoIntent"].makeIntent(title: "Buy milk").run()
        let title: String = try result.value.title
        XCTAssertEqual(title, "Buy milk")
    }
}
