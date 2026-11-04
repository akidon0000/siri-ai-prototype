@testable import AppFeature
import Clients
import Foundation
import TestSupport
import Testing

/// `MemoStore.shared` を差し替えるので、このスイートの中は順に実行する。
@Suite(.serialized)
struct MemoIntentTests {
    let client = TestMemoClient()

    init() {
        MemoStore.shared.configure(client: client)
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
        #expect(stored?.isDone == true)
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
