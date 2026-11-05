import AppIntents

extension MemoStore {
    func memosDidChange() {
        // Have the system reread, from suggestedEntities(), the titles that can fill \(\.$memo) in phrases
        MemoShortcuts.updateAppShortcutParameters()
    }
}
