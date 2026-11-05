import AppIntents
import CoreTransferable

// Making it Transferable lets Siri hand memos to other apps
extension MemoEntity: Transferable {
    static var transferRepresentation: some TransferRepresentation {
        // Hand it over as a string. Choose a form the receiving app can read
        ProxyRepresentation(exporting: \.title)
    }
}
