import SwiftUI

/// アプリのルートView。
public struct AppFeatureView: View {
    @State private var navigator = MemoNavigator.shared

    public init() {}

    public var body: some View {
        NavigationStack(path: $navigator.path) {
            MemoListView(searchText: $navigator.searchText)
                .navigationDestination(for: UUID.self) { id in
                    MemoDetailView(id: id)
                }
        }
    }
}
