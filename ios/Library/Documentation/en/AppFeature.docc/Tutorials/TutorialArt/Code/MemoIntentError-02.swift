import AppIntents

// The error the intent throws. Siri reads this type's text aloud as is
enum MemoIntentError: Error, CustomLocalizedStringResourceConvertible {
    case memoDeleted

    var localizedStringResource: LocalizedStringResource {
        switch self {
        // Say what happened in terms of the situation. No ads or upsells
        case .memoDeleted: "That memo has already been deleted"
        }
    }
}
