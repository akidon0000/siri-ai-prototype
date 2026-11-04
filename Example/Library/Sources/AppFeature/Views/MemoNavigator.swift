import Foundation
import Observation

/// 画面の遷移先。OpenMemoIntent や SearchMemosIntent から、表示するメモや検索語を受け取る。
@Observable
final class MemoNavigator {
    static let shared = MemoNavigator()

    var path: [UUID] = []
    var searchText = ""

    func show(_ id: UUID) {
        searchText = ""
        path = [id]
    }

    func showSearchResults(for term: String) {
        path = []
        searchText = term
    }
}
