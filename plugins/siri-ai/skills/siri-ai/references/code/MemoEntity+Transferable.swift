import AppIntents
import CoreTransferable

// Transferable にすると、Siriが他のアプリへメモを渡せる
// 「このメモをメールで送って」は、この変換でメモがメールアプリに渡って初めて成り立つ
extension MemoEntity: Transferable {
    static var transferRepresentation: some TransferRepresentation {
        // 文字列として渡す。受け取る側のアプリが読める形を選ぶ
        ProxyRepresentation(exporting: \.title)
    }
}
