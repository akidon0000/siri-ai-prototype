import AppIntents

// コンパイラがこの型を見つけて登録する。登録処理を呼ぶ必要は無い
struct MemoShortcuts: AppShortcutsProvider {
    static var appShortcuts: [AppShortcut] {
        AppShortcut(
            intent: AddMemoIntent(),
            // フレーズには必ず \(.applicationName) を入れる
            // \(\.$priority) には優先度（低・通常・高）が入る。String型のパラメータは埋め込めない
            phrases: [
                "\(.applicationName)にメモを追加して",
                "\(.applicationName)に優先度\(\.$priority)のメモを追加",
            ],
            shortTitle: "メモを追加",
            systemImageName: "note.text.badge.plus"
        )
    }
}
