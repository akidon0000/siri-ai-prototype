import AppIntents

// SiriKitを使ったことが無いので、CustomIntentMigratedAppIntent には準拠しない（第1章）
public struct CompleteMemoIntent: AppIntent {
    public static let title: LocalizedStringResource = "メモを完了にする"

    // 値が無ければ、システムが MemoEntity の候補を出して聞き返す
    @Parameter(title: "メモ")
    public var memo: MemoEntity

    public init() {}

    public func perform() async throws -> some IntentResult {
        try await MemoStore.shared.complete(memo.id)
        return .result()
    }
}
