import AppFeature
import AppIntents

// コンパイラがこの型を見つけて登録する。登録処理を呼ぶ必要は無い
// パッケージに置くとアプリのメタデータに入らないので、アプリのターゲットに置く
struct MemoShortcuts: AppShortcutsProvider {
    static var appShortcuts: [AppShortcut] {
        AppShortcut(
            intent: AddMemoIntent(),
            // フレーズには必ず \(.applicationName) を入れる
            // String型のパラメータ（title）は埋め込めない。AppEnum の priority だけを埋め込む
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

    static var negativePhrases: NegativeAppShortcutPhrases {
        NegativeAppShortcutPhrases(phrases: [
            "\(.applicationName)の使い方を教えて",
        ])
    }
}
