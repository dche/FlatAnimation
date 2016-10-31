//
// FlatAnimation - Generator.swift.
//
// Copyright (c) 2016 The FlatAnimation authors.
// Licensed under MIT License.

import FlatUtil
import GLMath

public struct Generator<T>: AnimationData {

    public typealias Value = T

    private let gen: (Double) -> T

    public init (_ gen: @escaping (Double) -> T) {
        self.gen = gen
    }

    public func sample(at t: Double) -> T {
        return gen(t)
    }
}
