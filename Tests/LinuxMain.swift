import XCTest
@testable import FlatAnimationTests

extension KeyframeTests {
    static let allTests: [(String, (KeyframeTests) -> () throws -> ())] = [
        ("testSample", testSample),
        ("testEmptyFrames", testEmptyFrames),
    ]
}

extension SpriteTests {
    static let allTests: [(String, (SpriteTests) -> () throws -> ())] = [
        ("testDuration", testDuration),
        ("testReversible", testReversible),
        ("testInitialState", testInitialState),
        ("testSample", testSample),
        ("testPause", testPause),
        ("testReset", testReset),
        ("testRepeatition", testRepeatition),
        ("testReversibleRepeatition", testReversibleRepeatition),
    ]
}

extension TweenTests {
    static let allTests: [(String, (TweenTests) -> () throws -> ())] = [
        ("testSample", testSample),
    ]
}

XCTMain([
    testCase(KeyframeTests.allTests),
    testCase(SpriteTests.allTests),
    testCase(TweenTests.allTests),
])
