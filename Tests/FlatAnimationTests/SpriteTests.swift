
import XCTest
import FlatUtil
import GLMath
@testable import FlatAnimation

class SpriteTests: XCTestCase {

    let sprites = SpriteData([1, 2, 3, 4])

    func testDuration() {
        var ani = Animation(data: sprites, duration: 0)
        XCTAssertEqual(ani.duration, 1)
        ani = Animation(data: sprites)
        XCTAssertEqual(ani.duration, 1)
        ani = Animation(data: sprites, duration: 100)
        XCTAssertEqual(ani.duration, 100)
    }

    func testReversible() {
        var ani = Animation(data: sprites, reversible: true)
        XCTAssertFalse(ani.isReversible)
        ani = Animation(data: sprites, duration: 2, reversible: false)
        XCTAssertFalse(ani.isReversible)
        ani = Animation(data: sprites, duration: 2, reversible: true)
        XCTAssert(ani.isReversible)
    }

    func testInitialState() {
        let ani = Animation(data: sprites)
        XCTAssert(ani.isPaused)
        XCTAssertFalse(ani.isFinished)
        XCTAssertFalse(ani.isRunning)
    }

    func testSample() {
        var ani = Animation(data: sprites, duration: 100)
        XCTAssertEqual(ani.sample(at: 1), 1)
        XCTAssertEqual(ani.sample(at: 50), 2)
        XCTAssertEqual(ani.sample(at: 51), 3)
        XCTAssertEqual(ani.sample(at: 75), 3)
        XCTAssertEqual(ani.sample(at: 76), 4)
        XCTAssertEqual(ani.sample(at: 99), 4)
        XCTAssertFalse(ani.isFinished)
        XCTAssert(ani.isRunning)
        XCTAssertEqual(ani.sample(at: 100), 4)
        XCTAssert(ani.isFinished)
    }

    func testPause() {
        var ani = Animation(data: sprites, duration: 4)
        XCTAssertEqual(ani.sample(at: 0), 1)
        XCTAssert(ani.isPaused)
        XCTAssertEqual(ani.sample(at: 2), 1)
        XCTAssertFalse(ani.isPaused)
        XCTAssert(ani.isRunning)
        ani.pause()
        XCTAssert(ani.isPaused)
        XCTAssertFalse(ani.isRunning)
        XCTAssertFalse(ani.isFinished)
        XCTAssertEqual(ani.sample(at: 3), 1)
        XCTAssertEqual(ani.sample(at: 4), 2)
        ani.pause()
        XCTAssertEqual(ani.sample(at: 16), 2)
        XCTAssertEqual(ani.sample(at: 18), 4)
        XCTAssert(ani.isFinished)
        XCTAssertFalse(ani.isRunning)
        XCTAssertFalse(ani.isPaused)
        XCTAssertEqual(ani.sample(at: 19), 4)
        XCTAssertEqual(ani.sample(at: 7), 4)
    }

    func testReset() {
        var ani = Animation(data: sprites, duration: 8)
        XCTAssertEqual(ani.sample(at: 1), 1)
        let _ = ani.sample(at: 8)
        XCTAssertEqual(ani.sample(at: 1), 4)
        XCTAssert(ani.isFinished)
        XCTAssertFalse(ani.isPaused)
        ani.reset()
        XCTAssert(ani.isPaused)
        XCTAssertFalse(ani.isFinished)
        XCTAssertEqual(ani.sample(at: 1), 1)
        XCTAssertEqual(ani.sample(at: 3), 2)
    }

    func testRepeatition() {
        var ani = Animation(data: sprites, duration: 4, repeatition: 2)
        XCTAssertEqual(ani.sample(at: 1), 1)
        XCTAssertEqual(ani.sample(at: 4), 4)
        XCTAssertEqual(ani.sample(at: 5), 1)
        XCTAssertEqual(ani.sample(at: 7), 3)
        XCTAssertFalse(ani.isFinished)
        XCTAssertEqual(ani.sample(at: 8), 4)
        XCTAssert(ani.isFinished)
    }

    func testReversibleRepeatition() {
        var ani = Animation(data: sprites, duration: 4, reversible: true, repeatition: 2)
        XCTAssertEqual(ani.sample(at: 1), 1)
        XCTAssertEqual(ani.sample(at: 4), 4)
        XCTAssertEqual(ani.sample(at: 5), 3)
        XCTAssertEqual(ani.sample(at: 7), 1)
        XCTAssert(ani.isFinished)
        XCTAssertEqual(ani.sample(at: 8), 1)
    }
}
