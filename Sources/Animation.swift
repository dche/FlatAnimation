//
// FlatAnimation - Animation.swift.
//
// Copyright (c) 2017 The FlatAnimation authors.
// Licensed under MIT License.

public protocol AnimationData {

    associatedtype Value

    /// Returns the value at sample position `t`.
    ///
    /// If called by `Animation`, `t` is guaranteed in the range [0, 1].
    ///
    /// - parameter t: The sample position.
    /// - returns: The sampled value.
    func sample(at t: Double) -> Value
}

public struct Animation<T: AnimationData> {

    /// Type of values this `Animation` object generates.
    public typealias Value = T.Value

    /// The animation data to be sampled.
    public let data: T

    // Last time when the receiver is sampled.
    private var _tick: UInt64 = 0

    private var _sampler: Sampler?

    /// Constructs an `Animation` object, which produces animated values by
    /// sampling underlying `AnimationData`.
    ///
    /// - parameter data: The `AnimationData` to be sampled.
    /// - parameter duration: Duration of the one pass of sampling.
    ///   If this value is less than `2`, then the sampling is always at
    ///   sample position `0.0`.
    /// - parameter reversible: If `repeatition` is larger than `1`, this
    ///   parameter decides that after sample position reaches `1.0`, if it
    ///   should decrease, instead of resetting to `0.0`.
    /// - parameter repeatition: How many times the sampling process shall
    ///   be repeated.
    public init (
        data: T,
        duration: UInt64 = 1,
        reversible: Bool = false,
        repeatition: Int = 1
    ) {
        self.data = data
        if duration > 1 {
            _sampler = Sampler(
                duration: duration,
                reversible: reversible,
                repeatition: max(repeatition, 1),
                initialPosition: 0,
                targetPosition: 1,
                initialDirection: .forward
            )
        }
    }

    /// `true` if the sampling process is ongoing.
    public var isRunning: Bool { return _tick != 0 && !isFinished }

    /// `true` if the sampling process is paused.
    public var isPaused: Bool { return _tick == 0 && !isFinished }

    /// `true` if the receiver finished sampling.
    public var isFinished: Bool { return _sampler?.isFinished ?? false }

    /// Duration of the one pass of sampling.
    public var duration: UInt64 {
        return UInt64((_sampler?.duration ?? 0) + 1)
    }

    /// `true` if the receiver is reversible.
    public var isReversible: Bool { return _sampler?.reversible ?? false }

    /// Resets the receiver's sampling state as if it was new created.
    ///
    /// - note: After `reset`, `repeatition` is set to current `repeatition`
    ///   value, which may be different than the value you specified when
    ///   construction.
    public mutating func reset() {
        _tick = 0
        guard let splr = _sampler else { return }
        _sampler = Sampler(
            duration: self.duration,
            reversible: self.isReversible,
            repeatition: splr.repeatition,
            initialPosition: 0,
            targetPosition: 1,
            initialDirection: .forward
        )
    }

    /// Pauses the receiver if it is running and not finished.
    public mutating func pause() {
        guard !isFinished else { return }
        _tick = 0
    }

    /// Gets the animation value at virtual time `tick`.
    public mutating func sample(at tick: UInt64) -> Value {
        guard var splr = _sampler else {
            return data.sample(at: 0)
        }
        guard tick > _tick && !isFinished else {
            return data.sample(at: splr.currentPosition)
        }
        let alpha: Double
        if _tick == 0 {
            alpha = splr.currentPosition
        } else {
            alpha = splr.samplePosition(after: tick - _tick)
            _sampler = splr
        }
        _tick = tick
        return data.sample(at: alpha)
    }

    /// Aaks the receiver to sample from current position to `to` and repeat
    /// `count` times.
    public mutating func loop(to: Double, count: Int) {
        guard to >= 0 && to <= 1 else { return }
        guard count > 0 else { return }
        _sampler = _sampler?.spawn(toPosition: to, count: count)
    }
}

extension Animation {

    /// Asks the receiver to sample from current position to `to` and then stop.
    public mutating func run(to: Double) {
        loop(to: to, count: 1)
    }

    /// Asks the receiver to sample from current position to the final position
    /// of `data` (i.e., the sample position `1.0`), and repeat `count` times.
    public mutating func loop(count: Int) {
        loop(to: 1, count: count)
    }
}
