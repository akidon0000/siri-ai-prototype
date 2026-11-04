import AppIntents
import CoreTransferable

// Transferable にすると、Siriが他のアプリへメモを渡せる
extension MemoEntity: Transferable {
    public static var transferRepresentation: some TransferRepresentation {
        // 文字列として渡す。受け取る側のアプリが読める形を選ぶ
        ProxyRepresentation(exporting: \.title)
    }
}
