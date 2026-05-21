import XCTest
@testable import SwiftObjCAdvancedPractice

final class SwiftObjCAdvancedPracticeTests: XCTestCase {
    func testStringProcessorCountsCharacters() {
        let processor = StringProcessor()
        XCTAssertEqual(processor.process("Swift"), 5)
    }

    func testArrayProcessorTransformsValues() {
        let processor = ArrayProcessor(transform: { $0 * 2 })
        XCTAssertEqual(processor.process([1, 2, 3]), [2, 4, 6])
    }

    func testBuildConfigurationKeepsConditionalItems() {
        let includeCache = true

        let config = buildConfiguration {
            ServerConfig(description: "API")
            if includeCache {
                CacheConfig(description: "Redis")
            }
            DatabaseConfig(description: "PostgreSQL")
        }

        XCTAssertEqual(config.map(\.description), ["API", "Redis", "PostgreSQL"])
    }

    func testComparableSequenceRemovesDuplicatesAndSorts() {
        let values = processComparableSequence([3, 1, 2, 3, 2, 1])
        XCTAssertEqual(values, [1, 2, 3])
    }

    func testThreadSafeLazyInitializesOnce() {
        struct Box {
            @ThreadSafeLazy var value: Int = 42
        }

        var box = Box()
        XCTAssertEqual(box.value, 42)
        XCTAssertEqual(box.value, 42)
    }

    func testActorStoresAndRetrievesData() async {
        let actor = DataManagerActor.shared
        await actor.clearCache()

        await actor.store(Data("hello".utf8), forKey: "greeting")

        let stored = await actor.retrieve(forKey: "greeting")
        XCTAssertEqual(stored.flatMap { String(data: $0, encoding: .utf8) }, "hello")

        let stats = await actor.getStatistics()
        XCTAssertEqual(stats.count, 1)
        XCTAssertEqual(stats.accessCount, 2)
    }
}
