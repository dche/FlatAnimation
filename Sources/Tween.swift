//
// FlatAnimation - Tween.swift.
//
// Copyright (c) 2016 The FlatAnimation authors.
// Licensed under MIT License.

import simd
import GLMath

public struct Tween<T: Interpolatable>: AnimationData where T.NumberType: BaseFloat {

    public typealias ValueType = T

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
        return from.interpolate(between: to, t: T.NumberType(curve(t)))
    }
}
