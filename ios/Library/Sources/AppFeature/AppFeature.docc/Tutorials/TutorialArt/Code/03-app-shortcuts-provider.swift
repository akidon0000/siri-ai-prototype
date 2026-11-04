import AppIntents

// AppShortcutsProvider: アプリをインストールした時点で
// Shortcuts/Siri/Spotlightが自動的に見つけられるフレーズの一覧。
struct MemoShortcuts: AppShortcutsProvider {
    static var appShortcuts: [AppShortcut] {
        AppShortcut(
            intent: AddMemoIntent(),
            phrases: [
                "\(.applicationName)にメモを追加して",
                "\(.applicationName)で\(\.$title)というメモを追加",
            ],
            shortTitle: "メモを追加",
            systemImageName: "note.text.badge.plus"
        )

        AppShortcut(
            intent: CompleteMemoIntent(),
            phrases: [
                "\(.applicationName)で\(\.$memo)を完了にして"
            ],
            shortTitle: "メモを完了",
            systemImageName: "checkmark.circle"
        )
    }
}
