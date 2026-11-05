import AppIntents

// The error the intent throws. Siri reads this type's text aloud as is
enum MemoIntentError: Error, CustomLocalizedStringResourceConvertible {
    case memoDeleted
}
