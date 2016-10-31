//
// FlatAnimation - Sprites.swift.
//
// Copyright (c) 2016 The FlatAnimation authors.
// Licensed under MIT License.

import simd
import GLMath

/// The simplest animation type that gets its value by ...
public struct SpriteData<T>: AnimationData {

    public typealias ValueType = T

    public let sprites: [T]

    public init (_ sprites: [T]) {
        precondition(sprites.count > 0, "Sprites should NOT be empty.")
        self.sprites = sprites
    }

    public func sample(at t: Double) -> T {
        guard t < 1 else {
            return sprites.last!
        }
        guard t > 0 else {
            return sprites[0]
        }
        let i = Int(floor(t * Double(sprites.count)))
        return sprites[i]
    }
}
