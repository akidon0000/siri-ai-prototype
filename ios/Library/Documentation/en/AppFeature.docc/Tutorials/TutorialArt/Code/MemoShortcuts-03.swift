import AppIntents

// The compiler finds and registers this type. There's no registration call to make
struct MemoShortcuts: AppShortcutsProvider {
    static var appShortcuts: [AppShortcut] {
        AppShortcut(
            intent: AddMemoIntent(),
            // Every phrase must include \(.applicationName)
            phrases: ["Add a memo in \(.applicationName)"],
            shortTitle: "Add Memo",
            systemImageName: "note.text.badge.plus"
        )
    }
}
