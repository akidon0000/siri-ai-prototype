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

        AppShortcut(
            intent: CompleteMemoIntent(),
            // MemoEntity を埋め込むと、メモのタイトルそのものをフレーズの一部として言える
            phrases: ["\(.applicationName)で\(\.$memo)を完了にして"],
            shortTitle: "メモを完了",
            systemImageName: "checkmark.circle"
        )
    }

    static let shortcutTileColor: ShortcutTileColor = .orange

    // この言い方ではアプリを起動しない、というフレーズ
    static var negativePhrases: NegativeAppShortcutPhrases {
        NegativeAppShortcutPhrases(phrases: [
            "\(.applicationName)の使い方を教えて",
        ])
    }
}
