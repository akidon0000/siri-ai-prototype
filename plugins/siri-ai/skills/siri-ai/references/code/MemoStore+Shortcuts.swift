import AppIntents

extension MemoStore {
    func memosDidChange() {
        // フレーズの \(\.$memo) に入るタイトルの一覧を、suggestedEntities() から読み直してもらう
        MemoShortcuts.updateAppShortcutParameters()
    }
}
