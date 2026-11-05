import AppIntents

struct CompleteMemoIntent: AppIntent {
    static let title: LocalizedStringResource = "Complete Memo"

    // If there's no value, the system asks back with MemoEntity suggestions
    @Parameter(title: "Memo")
    var memo: MemoEntity
}
