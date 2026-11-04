import AppFeature
import AppIntents
import ClientsLive
import SwiftUI

@main
struct SiriAIPrototypeApp: App {
    init() {
        // intent はアプリの画面を開かずに実行されることもあるので、起動直後に渡しておく
        MemoStore.shared.configure(client: LiveMemoClient()) {
            // フレーズの \(\.$memo) に入るタイトルの一覧を、suggestedEntities() から読み直してもらう
            MemoShortcuts.updateAppShortcutParameters()
        }
    }

    var body: some Scene {
        WindowGroup {
            AppFeatureView()
        }
    }
}
