import AppIntents

extension MemoStore {
    func memosDidChange() {
        MemoShortcuts.updateAppShortcutParameters()
    }
}
