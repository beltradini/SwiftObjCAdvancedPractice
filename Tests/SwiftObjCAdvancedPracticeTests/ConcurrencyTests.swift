import XCTest
@testable import SwiftObjCAdvancedPractice

/// Actor and concurrency tests.
final class ConcurrencyTests: XCTestCase {

    // MARK: - Actor Tests 

    func testActorStoreAndRetrieve() async throws {
        let actor = DataManagerActor.shared
        await actor.clearCache()
        let testData = Data("Test Data".utf8)

        await actor.store(testData, forKey: "testKey")

        let retrieved = await actor.retrieve(forKey: "testKey")
        XCTAssertNotNil(retrieved)
        XCTAssertEqual(retrieved, testData)
    }

    func testActorStatistics() async throws {
        let actor = DataManagerActor.shared
        await actor.clearCache()
        let testData = Data("Test Data".utf8)
        
        await actor.store(testData, forKey: "testKey")
        
        let stats = await actor.getStatistics()
        XCTAssertEqual(stats.count, 1)
        XCTAssertEqual(stats.accessCount, 1)
    }

    func testActorThreadSafety() async throws {
        let actor = DataManagerActor.shared
        await actor.clearCache()
        let testData = Data("Test".utf8)

        await withTaskGroup(of: Void.self, returning: Void.self, body: { group in
            for i in 0..<100 {
                group.addTask {
                    await actor.store(testData, forKey: "key\(i)")
                }
            }
            await group.waitForAll()
        })
    }
}
