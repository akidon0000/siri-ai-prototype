import AppIntents
import Components
import SwiftUI

struct MemoListView: View {
    @Binding var searchText: String
    @State private var model = MemoListModel()
    @State private var selection = Set<UUID>()

    private var visibleMemos: [MemoEntity] {
        guard !searchText.isEmpty else { return model.memos }
        return model.memos.filter { $0.title.localizedCaseInsensitiveContains(searchText) }
    }

    var body: some View {
        List(selection: $selection) {
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
                ForEach(visibleMemos) { memo in
                    NavigationLink(value: memo.id) {
                        MemoRow(memo: memo) {
                            Task { await model.complete(memo) }
                        }
                    }
                    .contextMenu {
                        Picker("優先度", selection: Binding(
                            get: { memo.priority },
                            set: { priority in Task { await model.setPriority(priority, for: memo) } }
                        )) {
                            ForEach(MemoPriority.allCases, id: \.self) { priority in
                                Text(MemoPriority.caseDisplayRepresentations[priority]?.title ?? "")
                            }
                        }
                    }
                }
                .onDelete { offsets in
                    let targets = offsets.map { visibleMemos[$0] }
                    Task { await model.delete(targets) }
                }
            } footer: {
                MemoListFooter()
                    .padding(.top, 24)
                    .frame(maxWidth: .infinity)
            }
        }
        .overlay {
            if visibleMemos.isEmpty && searchText.isEmpty {
                PlaceholderView("メモはまだありません", systemImage: "note.text", description: "上の欄に入力して追加します")
            }
        }
        .navigationTitle("メモ")
        .searchable(text: $searchText, prompt: "メモを検索")
        // 選択中のメモをSiriに伝える。「これを完了にして」の「これ」になる
        .appEntityIdentifier(forSelectionType: UUID.self) { id in
            EntityIdentifier(for: MemoEntity.self, identifier: id)
        }
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
            Button(memo.isCompleted ? "完了済み" : "完了にする", systemImage: memo.isCompleted ? "checkmark.circle.fill" : "circle", action: complete)
                .buttonStyle(.borderless)
                .labelStyle(.iconOnly)
                .disabled(memo.isCompleted)
            Text(memo.title)
                .strikethrough(memo.isCompleted)
                .foregroundStyle(memo.isCompleted ? .secondary : .primary)
            if memo.priority == .high {
                Image(systemName: "exclamationmark")
                    .foregroundStyle(.orange)
                    .accessibilityLabel("優先度 高")
            }
        }
    }
}
