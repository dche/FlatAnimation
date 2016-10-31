
import XCTest
import FlatUtil
import GLMath
@testable import FlatAnimation

import XCTest

class TweenTests: XCTestCase {

    let tween = Tween(from: 0.0, to: 1.0)

    func testSample() {

        var ani = Animation(data: tween)
        XCTAssertFalse(ani.isFinished)

        for i in 0 ..< 100 {
            XCTAssertEqual(ani.sample(at: UInt64(i)), 0.0)
        }

        ani = Animation(data: tween, duration: 9)
        XCTAssertEqual(ani.sample(at: 1), 0.0)
        XCTAssertEqual(ani.sample(at: 8), 0.875)
        XCTAssertEqual(ani.sample(at: 9), 1.0)
    }
}
