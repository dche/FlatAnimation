//
// FlatAnimation - Sampler.swift.
//
// Copyright (c) 2017 The FlatAnimation authors.
// Licensed under MIT License.

public struct Sampler {

    public let duration: UInt64

    public let isReversible: Bool

    private let end: UInt64

    public init (duration: UInt64, repeating: UInt64, reversible: Bool) {

        self.duration = duration
        self.isReversible = reversible

        if duration == 0 || repeating == 0 {
            // If `repeating` is `0`, `end` is not used.
            self.end = 0
        } else if !isReversible {
            self.end = (duration + 1) * repeating - 1
        } else {
            self.end = duration * repeating
        }
    }

    public func isFinished(at t: UInt64) -> Bool {
        return t > self.end
    }

    public func samplePosition(at tick: UInt64) -> Double {
        assert(self.duration > 0)
        assert(tick > 0)
        // Expect not finished.
        guard tick < self.end || self.end == 0 else {
            if !self.isReversible {
                return 1
            }
            return (self.end / self.duration) % 2 == 0 ? 0 : 1
        }
        let alpha: Double
        if isReversible {
            let loopCount = tick / self.duration
            let a = Double(tick % self.duration) / Double(self.duration)
            alpha = loopCount % 2 == 0 ? a : 1 - a
        } else {
            alpha = Double(tick % (self.duration + 1)) / Double(self.duration)
        }
        return alpha
    }
}
