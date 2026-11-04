import Clients
import TestSupport
import Testing

@Test func testMemoClientStartsFromSeed() async throws {
    let client: any MemoClient = TestMemoClient()
    #expect(try await client.allMemos() == TestMemoClient.seed)
}
