
import XCTest
@testable import FlatAnimation

import XCTest

class TweenTests: XCTestCase {

    let tween = Tween(from: 0.0, to: 1.0)

    func testSample() {

        var ani = Animation(data: tween, duration: 0)

        for i in 0 ..< 100 {
            XCTAssertEqual(ani.sample(at: UInt64(i)), 0.0)
        }

        ani = Animation(data: tween, duration: 8)
        XCTAssertEqual(ani.start(at: 10), 0.0)
        XCTAssertEqual(ani.sample(at: 17), 0.875)
        XCTAssertEqual(ani.sample(at: 18), 1.0)
    }
}
