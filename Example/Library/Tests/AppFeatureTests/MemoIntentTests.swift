@testable import AppFeature
import Clients
import Foundation
import TestSupport
import Testing

/// Spotlightの代わりに、索引への登録と削除を記録する。
actor RecordingIndexer: MemoIndexing {
    private(set) var indexed: [MemoEntity.ID] = []
    private(set) var removed: [MemoEntity.ID] = []

    func index(_ memos: [MemoEntity]) {
        indexed += memos.map(\.id)
    }

    func remove(_ ids: [MemoEntity.ID]) {
        removed += ids
    }
}

/// `MemoStore.shared` を差し替えるので、このスイートの中は順に実行する。
@Suite(.serialized)
struct MemoIntentTests {
    let client = TestMemoClient()
    let indexer = RecordingIndexer()

    init() {
        MemoStore.shared.configure(client: client)
        MemoStore.shared.configure(indexer: indexer)
    }

    @Test func addMemoIntentAddsAndReturnsMemo() async throws {
        let intent = AddMemoIntent()
        intent.title = "卵を買う"
        intent.priority = .high

        let result = try await intent.perform()

        let memo = try #require(result.value)
        #expect(memo.title == "卵を買う")
        let stored = await client.storage.first { $0.id == memo.id }
        #expect(stored?.priority == .high)
    }

    @Test func completeMemoIntentThrowsWhenMemoWasDeleted() async throws {
        await client.delete([TestMemoClient.milkID])
        let intent = CompleteMemoIntent()
        intent.memo = MemoEntity(TestMemoClient.seed[0])

        await #expect(throws: MemoIntentError.memoDeleted) {
            _ = try await intent.perform()
        }
    }

    @Test func sharedMemoReportsSharedOwnership() {
        var memo = MemoEntity(TestMemoClient.seed[0])
        #expect(memo.ownership == .unknown)
        memo.sharedWith = ["friend"]
        #expect(memo.ownership == .shared)
    }

    @Test func completeMemoIntentMarksMemoDone() async throws {
        let intent = CompleteMemoIntent()
        intent.memo = MemoEntity(TestMemoClient.seed[0])

        _ = try await intent.perform()

        let stored = await client.storage.first { $0.id == TestMemoClient.milkID }
        #expect(stored?.isCompleted == true)
    }

    @Test func createMemoIntentAddsMemoToList() async throws {
        let intent = CreateMemoIntent()
        intent.title = "卵を買う"
        intent.tags = ["買い物"]

        let result = try await intent.perform()

        let memo = try #require(result.value)
        #expect(memo.title == "卵を買う")
        #expect(memo.list.id == MemoList.defaultID)
        let stored = await client.storage.first { $0.id == memo.id }
        #expect(stored?.tags == ["買い物"])
    }

    @Test func updateMemoIntentChangesOnlyGivenProperties() async throws {
        let intent = UpdateMemoIntent()
        intent.target = MemoEntity(TestMemoClient.seed[0])
        intent.isCompleted = true

        let result = try await intent.perform()

        let memo = try #require(result.value)
        #expect(memo.isCompleted)
        #expect(memo.title == "牛乳を買う")
        #expect(memo.completionDate != nil)
    }

    @Test func addingUpdatingAndDeletingKeepSpotlightIndexInSync() async throws {
        let added = try await MemoStore.shared.add(title: "卵を買う")
        _ = try await MemoStore.shared.update(added.id, MemoChange(title: "卵を2パック買う"))
        try await MemoStore.shared.delete([added.id])

        #expect(await indexer.indexed == [added.id, added.id])
        #expect(await indexer.removed == [added.id])
    }

    @Test func memoQueryReturnsTitlesWithoutBuildingEntities() async throws {
        let representations = try await MemoQuery().displayRepresentations(for: [TestMemoClient.milkID])
        #expect(representations.keys.contains(TestMemoClient.milkID))
    }

    @Test func visualSearchLabelsMatchTitleOrTags() async throws {
        _ = try await MemoStore.shared.add(title: "Buy milk", tags: ["dairy"])
        let byTitle = try await MemoStore.shared.memos(matchingAnyOf: ["milk"])
        let byTag = try await MemoStore.shared.memos(matchingAnyOf: ["Dairy"])
        #expect(byTitle.map(\.title) == ["Buy milk"])
        #expect(byTag.map(\.title) == ["Buy milk"])
    }

    @Test func setMemoPriorityIntentChangesPriority() async throws {
        let intent = SetMemoPriorityIntent()
        intent.memo = MemoEntity(TestMemoClient.seed[1])
        intent.priority = .high

        _ = try await intent.perform()

        let stored = await client.storage.first { $0.id == TestMemoClient.breadID }
        #expect(stored?.priority == .high)
    }

    @Test func searchFiltersOpenMemosByKeywordAndPriority() async throws {
        let high = try await MemoStore.shared.memos(matching: "買う", priorities: [.high])
        let any = try await MemoStore.shared.memos(matching: "買う", priorities: [])
        #expect(high.map(\.id) == [TestMemoClient.milkID])
        #expect(Set(any.map(\.id)) == [TestMemoClient.milkID, TestMemoClient.breadID])
    }

    @Test func overdueOnlyWhenPastDueAndOpen() {
        let memo = MemoEntity(TestMemoClient.seed[0])
        memo.dueDate = Calendar.current.dateComponents([.year, .month, .day, .hour], from: .now.addingTimeInterval(-86_400))
        #expect(memo.isOverdue)
        memo.isCompleted = true
        #expect(!memo.isOverdue)
    }

    @Test func memoListQueryEnumeratesAllLists() async throws {
        let lists = try await MemoListQuery().allEntities()
        #expect(lists.map(\.id) == [MemoList.defaultID])
    }

    @Test func memoListQueryFindsListByName() async throws {
        let lists = try await MemoListQuery().entities(matching: "メモ")
        #expect(lists.map(\.id) == [MemoList.defaultID])
    }

    @Test func memoQueryFindsMemosByName() async throws {
        let found = try await MemoQuery().entities(matching: "牛乳")
        #expect(found.map(\.id) == [TestMemoClient.milkID])
    }

    @Test func memoQueryResolvesIdentifiersInOrder() async throws {
        let found = try await MemoQuery().entities(for: [TestMemoClient.breadID, TestMemoClient.milkID])
        #expect(found.map(\.title) == ["パンを買う", "牛乳を買う"])
    }

    @Test func memoQuerySuggestsNewestFirst() async throws {
        let suggested = try await MemoQuery().suggestedEntities()
        #expect(suggested.map(\.id) == [TestMemoClient.breadID, TestMemoClient.milkID])
    }
}
