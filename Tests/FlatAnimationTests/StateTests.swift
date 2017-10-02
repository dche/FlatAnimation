
import XCTest
@testable import FlatAnimation

import XCTest

class StateTests: XCTestCase {

    let sprites = SpriteData([0,1,2,3,4])

    func testInactive() {
        let ani = Animation(data: sprites, duration: 4)
        XCTAssertFalse(ani.isPaused)
        XCTAssertEqual(ani.sample(at: 1), 0)
        XCTAssertEqual(ani.sample(at: 1234), 0)
    }

    func testPauseResume() {
        var ani = Animation(data: sprites, duration: 4, repeating: 10)
        XCTAssertEqual(ani.start(at: 100), 0)
        XCTAssertEqual(ani.pause(at: 101), 1)
        XCTAssertEqual(ani.sample(at: 102), 1)
        XCTAssertEqual(ani.sample(at: 103), 1)
        XCTAssertEqual(ani.sample(at: 104), 1)
        XCTAssertEqual(ani.sample(at: 10004), 1)
        XCTAssert(ani.isPaused)
        XCTAssertNil(ani.resume(at: 100))
        XCTAssert(ani.isPaused)
        XCTAssertEqual(ani.resume(at: 101)!, 1)
        XCTAssertFalse(ani.isPaused)
        XCTAssertEqual(ani.sample(at: 102), 2)
        XCTAssertEqual(ani.pause(at: 105), 0)
        XCTAssert(ani.isPaused)
        XCTAssertEqual(ani.sample(at: 104), 4)
        XCTAssertEqual(ani.sample(at: 106), 0)
        XCTAssertEqual(ani.sample(at: 116), 0)
        XCTAssertEqual(ani.resume(at: 111)!, 0)
        XCTAssertEqual(ani.sample(at: 112), 1)
    }

    func testStart() {
        var ani = Animation(data: sprites, duration: 4)
        XCTAssertEqual(ani.start(at: 100), 0)
        XCTAssertEqual(ani.sample(at: 101), 1)
        XCTAssertEqual(ani.start(at: 101), 0)
    }
}
