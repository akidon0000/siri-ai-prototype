import AppIntents

// コンパイラがこの型を見つけて登録する。登録処理を呼ぶ必要は無い
struct MemoShortcuts: AppShortcutsProvider {
    static var appShortcuts: [AppShortcut] {
        AppShortcut(
            intent: AddMemoIntent(),
            // フレーズには必ず \(.applicationName) を入れる
            phrases: ["\(.applicationName)にメモを追加して"],
            shortTitle: "メモを追加",
            systemImageName: "note.text.badge.plus"
        )
    }
}
