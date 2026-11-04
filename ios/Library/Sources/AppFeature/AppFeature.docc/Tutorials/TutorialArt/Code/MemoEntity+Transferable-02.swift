import AppIntents
import CoreTransferable

extension MemoEntity: Transferable {
    static var transferRepresentation: some TransferRepresentation {
        ProxyRepresentation(exporting: \.title)
    }
}
