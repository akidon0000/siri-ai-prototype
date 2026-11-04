import AppIntents

// intentが投げるエラー。Siriはこの型の文をそのまま読み上げる
enum MemoIntentError: Error, CustomLocalizedStringResourceConvertible {
    case memoDeleted
}
