
import XCTest
import FlatUtil
import GLMath
@testable import FlatAnimation

class KeyframeTests: XCTestCase {

    let kfs = (0 ..< 8).map { i in return Keyframe(value: Double(i + 1))! }

    func testSample() {
        let kd = KeyframeData(first: 0.0, rest: kfs)
        var ani = Animation(data: kd, duration: 17)
        XCTAssertEqual(ani.sample(at: 1), 0.0)
        XCTAssertEqual(ani.sample(at: 2), 0.5)
        XCTAssertEqual(ani.sample(at: 3), 1)
        XCTAssertEqual(ani.sample(at: 16), 7.5)
        XCTAssertEqual(ani.sample(at: 17), 8)
        XCTAssert(ani.isFinished)
    }

    func testEmptyFrames() {
        let kd = KeyframeData(first: 0.0, rest: [])
        var ani = Animation(data: kd, duration: 20)
        for i in 0 ..< 100 {
            XCTAssertEqual(ani.sample(at: UInt64(i)), 0)
        }
    }
}
