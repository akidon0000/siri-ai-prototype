import AppIntents

struct MemoShortcuts: AppShortcutsProvider {
    static var appShortcuts: [AppShortcut] {
        AppShortcut(
            intent: AddMemoIntent(),
            phrases: [
                "\(.applicationName)にメモを追加して",
                "\(.applicationName)に優先度\(\.$priority)のメモを追加",
            ],
            shortTitle: "メモを追加",
            systemImageName: "note.text.badge.plus"
        )

        AppShortcut(
            intent: CompleteMemoIntent(),
            phrases: ["\(.applicationName)で\(\.$memo)を完了にして"],
            shortTitle: "メモを完了",
            systemImageName: "checkmark.circle"
        )
    }
}
