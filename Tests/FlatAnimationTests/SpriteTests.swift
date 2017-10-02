
import XCTest
@testable import FlatAnimation

class SpriteTests: XCTestCase {

    let sprites = SpriteData([1, 2, 3, 4])

    func testDefaults() {
        var ani = Animation(data: sprites, duration: 0)

        XCTAssertEqual(ani.duration, 0)
        XCTAssertFalse(ani.isFinished(at: 0))
        XCTAssertFalse(ani.isFinished(at: 100))
        let _ = ani.start(at: 0)
        XCTAssertFalse(ani.isFinished(at: 0))
        XCTAssert(ani.isFinished(at: 1))
        XCTAssertFalse(ani.isReversible)
        XCTAssertFalse(ani.isPaused)

        ani = Animation(data: sprites, duration: 1)
        XCTAssertEqual(ani.duration, 1)
        XCTAssertFalse(ani.isPaused)
        let _ = ani.start(at: 100)
        XCTAssertFalse(ani.isFinished(at: 100))
        XCTAssertFalse(ani.isFinished(at: 101))
        XCTAssert(ani.isFinished(at: 102))


        ani = Animation(data: sprites, duration: 100)
        XCTAssertEqual(ani.duration, 100)
        XCTAssertFalse(ani.isPaused)
        let _ = ani.start(at: 0)
        XCTAssertFalse(ani.isFinished(at: 100))
        XCTAssert(ani.isFinished(at: 101))

    }

    func testReversible() {
        var ani = Animation(data: sprites, duration: 1, reversible: true)
        XCTAssert(ani.isReversible)
        let _ = ani.start(at: 0)
        XCTAssertFalse(ani.isFinished(at: 1))
        XCTAssert(ani.isFinished(at: 2))

        ani = Animation(data: sprites, duration: 2, repeating: 2, reversible: true)
        XCTAssert(ani.isReversible)
        let _ = ani.start(at: 10)
        XCTAssertFalse(ani.isFinished(at: 14))
        XCTAssert(ani.isFinished(at: 15))

        ani = Animation(data: sprites, duration: 3, repeating: 3, reversible: true)
        let _ = ani.start(at: 20)
        XCTAssertFalse(ani.isFinished(at: 29))
        XCTAssert(ani.isFinished(at: 30))
    }

    func testSample() {
        var ani = Animation(data: sprites, duration: 100)
        let _ = ani.start(at: 0)
        XCTAssertEqual(ani.sample(at: 1), 1)
        XCTAssertEqual(ani.sample(at: 24), 1)
        XCTAssertEqual(ani.sample(at: 25), 2)
        XCTAssertEqual(ani.sample(at: 49), 2)
        XCTAssertEqual(ani.sample(at: 50), 3)
        XCTAssertEqual(ani.sample(at: 74), 3)
        XCTAssertEqual(ani.sample(at: 75), 4)
        XCTAssertEqual(ani.sample(at: 99), 4)
        XCTAssertEqual(ani.sample(at: 100), 4)
    }

    func testRepeatition() {
        var ani = Animation(data: sprites, duration: 3, repeating: 2)
        XCTAssertEqual(ani.start(at: 1), 1)
        XCTAssertEqual(ani.sample(at: 4), 4)
        XCTAssertEqual(ani.sample(at: 5), 1)
        XCTAssertEqual(ani.sample(at: 7), 3)
        XCTAssertFalse(ani.isFinished(at: 8))
        XCTAssertEqual(ani.sample(at: 8), 4)
        XCTAssert(ani.isFinished(at: 9))
    }

    func testReversibleRepeatition() {
        var ani = Animation(data: sprites, duration: 3, repeating: 2, reversible: true)
        XCTAssertEqual(ani.start(at: 1), 1)
        XCTAssertEqual(ani.sample(at: 4), 4)
        XCTAssertEqual(ani.sample(at: 5), 3)
        XCTAssertEqual(ani.sample(at: 7), 1)
        XCTAssert(ani.isFinished(at: 8))
        XCTAssertEqual(ani.sample(at: 8), 1)
    }

    func testInfiniteLoop() {
        var ani = Animation(data: sprites, duration: 3, repeating: 0)
        XCTAssertEqual(ani.start(at: 1), 1)
        XCTAssertEqual(ani.sample(at: 4001), 1)
        XCTAssertEqual(ani.sample(at: 8002), 2)
        XCTAssertEqual(ani.sample(at: 100003), 3)
        XCTAssertEqual(ani.sample(at: 200004), 4)
    }
}
