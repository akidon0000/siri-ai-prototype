import Components
import SwiftUI

struct MemoListView: View {
    @State private var model = MemoListModel()

    var body: some View {
        List {
            Section {
                HStack {
                    TextField("新しいメモ", text: $model.draftTitle)
                        .onSubmit { Task { await model.addDraft() } }
                    Button("追加", systemImage: "plus.circle.fill") {
                        Task { await model.addDraft() }
                    }
                    .labelStyle(.iconOnly)
                    .disabled(model.draftTitle.isEmpty)
                }
            }

            Section {
                ForEach(model.memos) { memo in
                    MemoRow(memo: memo) {
                        Task { await model.complete(memo) }
                    }
                }
            }
        }
        .overlay {
            if model.memos.isEmpty {
                PlaceholderView("メモはまだありません", systemImage: "note.text", description: "上の欄に入力して追加します")
            }
        }
        .navigationTitle("メモ")
        .alert("操作できませんでした", isPresented: .constant(model.errorMessage != nil)) {
            Button("OK") { model.errorMessage = nil }
        } message: {
            Text(model.errorMessage ?? "")
        }
        .task { await model.load() }
        .task { await model.observeChanges() }
    }
}

private struct MemoRow: View {
    let memo: MemoEntity
    let complete: () -> Void

    var body: some View {
        HStack {
            Button(memo.isDone ? "完了済み" : "完了にする", systemImage: memo.isDone ? "checkmark.circle.fill" : "circle", action: complete)
                .labelStyle(.iconOnly)
                .disabled(memo.isDone)
            Text(memo.title)
                .strikethrough(memo.isDone)
                .foregroundStyle(memo.isDone ? .secondary : .primary)
        }
    }
}
