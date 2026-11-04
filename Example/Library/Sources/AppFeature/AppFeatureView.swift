import Clients
import SwiftUI

/// アプリのルートView。
public struct AppFeatureView: View {
    public init() {}

    public var body: some View {
        NavigationStack {
            MemoListView()
        }
    }
}
