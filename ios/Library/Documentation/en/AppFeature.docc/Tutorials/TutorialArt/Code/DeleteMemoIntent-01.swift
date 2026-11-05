import AppIntents

struct DeleteMemoIntent: AppIntent {
    static let title: LocalizedStringResource = "Delete Memo"

    @Parameter(title: "Memo")
    var memo: MemoEntity
}
