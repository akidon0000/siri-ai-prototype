import AppIntents

struct MemoShortcuts: AppShortcutsProvider {
    static var appShortcuts: [AppShortcut] {
        AppShortcut(
            intent: AddMemoIntent(),
            phrases: ["\(.applicationName)にメモを追加して"]
        )
    }
}
