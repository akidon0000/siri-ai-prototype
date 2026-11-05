import UIKit

// 仮の画像を作る。メモごとの画像を持たせるときは、ここを差し替える
nonisolated enum MemoImageRenderer {
    // 候補や確認画面で、行の左に出る小さな画像
    static func thumbnail(isCompleted: Bool) -> Data {
        let size = CGSize(width: 128, height: 128)
        return UIGraphicsImageRenderer(size: size).pngData { _ in
            (isCompleted ? UIColor.systemGreen : UIColor.systemGray4).setFill()
            UIBezierPath(roundedRect: CGRect(origin: .zero, size: size), cornerRadius: 28).fill()
            let symbol = UIImage(systemName: isCompleted ? "checkmark" : "note.text",
                                 withConfiguration: UIImage.SymbolConfiguration(pointSize: 56, weight: .semibold))?
                .withTintColor(.white, renderingMode: .alwaysOriginal)
            let side = symbol?.size ?? .zero
            symbol?.draw(at: CGPoint(x: (size.width - side.width) / 2, y: (size.height - side.height) / 2))
        }
    }

    // メモのタイトルを書いたカード。画像ファイルとして他のアプリへ渡す
    static func card(title: String, isCompleted: Bool) -> Data {
        let size = CGSize(width: 1024, height: 512)
        return UIGraphicsImageRenderer(size: size).pngData { _ in
            UIColor.systemBackground.setFill()
            UIRectFill(CGRect(origin: .zero, size: size))
            let icon = UIImage(data: thumbnail(isCompleted: isCompleted))
            icon?.draw(in: CGRect(x: 64, y: 192, width: 128, height: 128))
            let attributes: [NSAttributedString.Key: Any] = [
                .font: UIFont.systemFont(ofSize: 72, weight: .bold),
                .foregroundColor: UIColor.label,
            ]
            (title as NSString).draw(in: CGRect(x: 232, y: 196, width: 740, height: 120), withAttributes: attributes)
        }
    }
}
