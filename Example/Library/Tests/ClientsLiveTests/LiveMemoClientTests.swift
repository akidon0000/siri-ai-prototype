import Clients
import ClientsLive
import Foundation
import Testing

@Test func addedMemoCanBeFoundByIDAndName() async throws {
    let client: any MemoClient = LiveMemoClient()
    let memo = try await client.add(title: "牛乳を買う", priority: .high)

    #expect(try await client.memos(for: [memo.id]) == [memo])
    #expect(try await client.memos(matching: "牛乳") == [memo])
    #expect(try await client.memos(matching: "パン").isEmpty)
}

@Test func completedMemoLeavesRecentMemos() async throws {
    let client: any MemoClient = LiveMemoClient()
    let memo = try await client.add(title: "牛乳を買う", priority: .normal)

    try await client.complete(memo.id)

    #expect(try await client.recentMemos().isEmpty)
    #expect(try await client.allMemos().first?.isDone == true)
}

@Test func deletedMemoIsGoneAndTitleCheckIgnoresCase() async throws {
    let client: any MemoClient = LiveMemoClient()
    let memo = try await client.add(title: "Milk", priority: .normal)

    #expect(try await client.contains(title: "milk"))
    try await client.delete([memo.id])
    #expect(try await client.allMemos().isEmpty)
    #expect(try await !client.contains(title: "milk"))
}

@Test func completingUnknownMemoThrows() async {
    let client: any MemoClient = LiveMemoClient()
    let id = UUID()
    await #expect(throws: MemoClientError.notFound(id)) {
        try await client.complete(id)
    }
}
