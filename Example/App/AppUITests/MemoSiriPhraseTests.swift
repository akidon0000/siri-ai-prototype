import AppIntents
import AppIntentsTesting
import XCTest

@MainActor
final class MemoSiriPhraseTests: XCTestCase {
    let app = XCUIApplication()

    override func setUp() async throws {
        continueAfterFailure = true
        app.launch()
        let definitions = IntentDefinitions(bundleIdentifier: "com.akidon0000.SiriAIPrototype")
        _ = try await definitions.intents["ResetMemosIntent"].makeIntent().run()
        XCUIDevice.shared.press(.home)
    }

    func testProbe() async throws {
        let phrases = (ProcessInfo.processInfo.environment["SIRI_PHRASE"] ?? "よんよんにメモを追加して")
            .split(separator: "|").map(String.init)
        for (i, phrase) in phrases.enumerated() {
            XCUIDevice.shared.siriService.activate(voiceRecognitionText: phrase)
            try await Task.sleep(for: .seconds(8))
            let attachment = XCTAttachment(screenshot: XCUIScreen.main.screenshot())
            attachment.name = "\(i)-\(phrase)"
            attachment.lifetime = .keepAlways
            add(attachment)
            XCUIDevice.shared.press(.home)
            try await Task.sleep(for: .seconds(3))
        }
    }
}
