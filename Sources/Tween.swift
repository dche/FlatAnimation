//
// FlatAnimation - Tween.swift.
//
// Copyright (c) 2017 The FlatAnimation authors.
// Licensed under MIT License.

#if os(Linux)
    import Glibc
#else
    import simd
#endif

import GLMath

public struct Tween<T>: AnimationData
    where
    T: Interpolatable,
    T.InterpolatableNumber: BinaryFloatingPoint
{
    public typealias Value = T

    public let from: T

    public let to: T

    public let curve: (Double) -> Double

    public init (
        from: T,
        to: T,
        curve: @escaping (Double) -> Double = UnitCurve.linear
    ) {
        self.from = from
        self.to = to
        self.curve = curve
    }

    public func sample(at t: Double) -> T {
        if t == 0 { return from }
        if t == 1 { return to }
        return from.interpolate(to, t: T.InterpolatableNumber(curve(t)))
    }
}

extension Animation
    where
    T.Value: Interpolatable,
    T.Value.InterpolatableNumber: BinaryFloatingPoint
{

    func tween(from: UInt64, to: Value, duration: UInt64) -> Animation<Tween<Value>> {
        let tween = Tween(from: self.sample(at: from), to: to)
        return Animation<Tween<Value>>(data: tween, duration: duration)
    }
}
