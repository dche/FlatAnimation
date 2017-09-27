//
// FlatAnimation - Animation.swift.
//
// Copyright (c) 2017 The FlatAnimation authors.
// Licensed under MIT License.

#if os(Linux)
    import Glibc
#else
    import simd
#endif

import GLMath

///
public struct Keyframe<T: Interpolatable> {

    /// Target value of this `Frame`.
    public let frame: T

    /// Duration from previous `Frame` to `self`.
    public let duration: UInt64

    /// Interpolation curve used in this `Keyframe`.
    public let curve: (Double) -> Double

    /// Constructs a `Keyframe`.
    ///
    /// Returns `nil` if duration is `0` or `curve` is not a unit curve.
    public init? (
        value: T,
        duration: UInt64 = 1,
        curve: @escaping (Double) -> Double = UnitCurve.linear
    ) {
        guard duration > 0 else { return nil }
        guard curve(0) == 0 && curve(1) == 1 else { return nil }

        self.frame = value
        self.duration = duration
        self.curve = curve
    }
}


public struct KeyframeData<T: Interpolatable>: AnimationData
    where
    T.InterpolatableNumber: BaseFloat
{
    public typealias ValueType = T

    /// Value of first frame.
    let first: T

    let frames: [Keyframe<T>]

    private let fractions: [Double]

    public init (
        first: T,
        rest: [Keyframe<T>]
    ) {
        self.first = first
        self.frames = rest

        let duration = frames.map { $0.duration }.reduce(0) { $0 + $1 }
        if duration == 0 {
            self.fractions = []
        } else {
            let ds = frames.map { Double($0.duration) / Double(duration) }
            var fs: [Double] = [ds.first!]
            for i in 1 ..< ds.count - 1 {
                fs.append(fs.last! + ds[i])
            }
            self.fractions = fs
        }
    }

    public func sample(at t: Double) -> T {
        guard frames.count > 0 else { return first }
        guard t > 0 else { return first }
        guard t < 1 else { return frames.last!.frame }

        var i = 0
        var from = first
        var t0 = 0.0
        while i < fractions.count {
            if t < fractions[i] {
                let nt = T.InterpolatableNumber(frames[i].curve((t - t0) / (fractions[i] - t0)))
                return from.interpolate(frames[i].frame, t: nt)
            }
            from = frames[i].frame
            t0 = fractions[i]
            i += 1
        }
        let nt = T.InterpolatableNumber(frames.last!.curve((t - t0) / (1 - t0)))
        return from.interpolate(frames.last!.frame, t: nt)
    }
}
