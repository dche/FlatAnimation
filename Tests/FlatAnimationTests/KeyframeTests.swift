
import XCTest
@testable import FlatAnimation

class KeyframeTests: XCTestCase {

    let kfs = (0 ..< 8).map { i in return Keyframe(value: Double(i + 1))! }

    func testSample() {
        let kd = KeyframeData(first: 0.0, rest: kfs)
        var ani = Animation(data: kd, duration: 16)
        let st: UInt64 = 234
        XCTAssertEqual(ani.start(at: st), 0.0)
        XCTAssertEqual(ani.sample(at: st + 1), 0.5)
        XCTAssertEqual(ani.sample(at: st + 2), 1)
        XCTAssertEqual(ani.sample(at: st + 15), 7.5)
        XCTAssertFalse(ani.isFinished(at: st + 16))
        XCTAssertEqual(ani.sample(at: st + 16), 8)
        XCTAssert(ani.isFinished(at: st + 17))
    }

    func testEmptyFrames() {
        let kd = KeyframeData(first: 0.0, rest: [])
        let ani = Animation(data: kd, duration: 20)
        for i in 0 ..< 100 {
            XCTAssertEqual(ani.sample(at: UInt64(i)), 0)
        }
    }

    func testOneFrame() {
        let kf = [Keyframe(value: 1)!]
        var ani = Animation(data: KeyframeData(first: 0.0, rest: kf), duration: 4)
        XCTAssertEqual(ani.start(at: 0), 0.0)
        XCTAssertEqual(ani.sample(at: 0), 0.0)
        XCTAssertEqual(ani.sample(at: 3), 0.75)
    }
}
