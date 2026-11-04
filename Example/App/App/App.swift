import AppFeature
import ClientsLive
import SwiftUI

@main
struct SiriAIPrototypeApp: App {
    init() {
        // intent はアプリの画面を開かずに実行されることもあるので、起動直後に渡しておく
        MemoStore.shared.configure(client: LiveMemoClient())
    }

    var body: some Scene {
        WindowGroup {
            AppFeatureView()
        }
    }
}
