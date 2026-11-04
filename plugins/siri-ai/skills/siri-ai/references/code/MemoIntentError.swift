import AppIntents

// intentが投げるエラー。Siriはこの型の文をそのまま読み上げる
enum MemoIntentError: Error, CustomLocalizedStringResourceConvertible {
    case memoDeleted

    var localizedStringResource: LocalizedStringResource {
        switch self {
        // 何が起きたかを、その状況の言葉で伝える。広告や課金の勧誘は入れない
        case .memoDeleted: "そのメモはもう削除されています"
        }
    }
}
