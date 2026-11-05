import AppIntents

// The compiler finds and registers this type. There's no registration call to make
struct MemoShortcuts: AppShortcutsProvider {
    static var appShortcuts: [AppShortcut] {
        // Can be assigned to the Action button. Make responses work without looking at the screen (chapter 4)
        AppShortcut(
            intent: AddMemoIntent(),
            // Every phrase must include \(.applicationName)
            // \(\.$priority) is filled with a priority (Low, Normal, High). String parameters can't be embedded
            phrases: [
                "Add a memo in \(.applicationName)",
                "Add a \(\.$priority) priority memo in \(.applicationName)",
            ],
            shortTitle: "Add Memo",
            systemImageName: "note.text.badge.plus"
        )

        AppShortcut(
            intent: CompleteMemoIntent(),
            // Embedding a MemoEntity lets people say the memo's title itself as part of the phrase
            phrases: ["Complete \(\.$memo) in \(.applicationName)"],
            shortTitle: "Complete Memo",
            systemImageName: "checkmark.circle"
        )
    }

    static let shortcutTileColor: ShortcutTileColor = .orange

    // Phrases that should not launch the app
    static var negativePhrases: NegativeAppShortcutPhrases {
        NegativeAppShortcutPhrases(phrases: [
            "How do I use \(.applicationName)",
        ])
    }
}
