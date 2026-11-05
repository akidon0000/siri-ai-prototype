import AppIntents
import UniformTypeIdentifiers

// メモを画像ファイル（IntentFile）にして返す。Siriは、この画像を他のアプリやショートカットへ渡せる
struct ExportMemoImageIntent: AppIntent {
    static let title: LocalizedStringResource = "メモを画像にする"
    static let description = IntentDescription("メモのタイトルを書いた画像を作る。")

    @Parameter(title: "メモ") var memo: MemoEntity

    init() {}

    init(memo: MemoEntity) {
        self.memo = memo
    }

    func perform() async throws -> some ReturnsValue<IntentFile> {
        let latest = try await MemoStore.shared.memo(for: memo.id)
        let data = MemoImageRenderer.card(title: latest.title, isCompleted: latest.isCompleted)
        return .result(value: IntentFile(data: data, filename: "\(latest.title).png", type: .png))
    }
}
