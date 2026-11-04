import AppIntents

extension MemoStore {
    // メモが増えたり減ったりしたら呼ぶ
    func memosDidChange() {
        // フレーズの \(\.$memo) に入るタイトルの一覧を、suggestedEntities() から読み直してもらう
        MemoShortcuts.updateAppShortcutParameters()
    }
}
