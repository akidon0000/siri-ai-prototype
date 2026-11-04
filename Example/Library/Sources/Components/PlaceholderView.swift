import SwiftUI

/// 一覧が空のときに出す表示。
public struct PlaceholderView: View {
    let title: LocalizedStringKey
    let systemImage: String
    let description: LocalizedStringKey

    public init(_ title: LocalizedStringKey, systemImage: String, description: LocalizedStringKey) {
        self.title = title
        self.systemImage = systemImage
        self.description = description
    }

    public var body: some View {
        ContentUnavailableView(title, systemImage: systemImage, description: Text(description))
    }
}
