//
// FlatAnimation - Animation.swift.
//
// Copyright (c) 2017 The FlatAnimation authors.
// Licensed under MIT License.

public protocol AnimationData {

    associatedtype Value

    /// Returns the value at sample position `t`.
    ///
    /// - parameter t: The sample position. If called by `Animation`,
    ///   `t` is guaranteed to be in the range [0, 1].
    /// - returns: The sampled value.
    func sample(at t: Double) -> Value
}

public struct Animation<T: AnimationData> {

    private enum State {
        case inactive
        case run(startTime: UInt64)
        case paused(at: UInt64, startTime: UInt64)
    }

    public typealias Value = T.Value

    /// The animation data to be sampled.
    public let data: T

    private let sampler: Sampler

    private var _state: State = .inactive

    /// Duration of the one pass of sampling.
    public var duration: UInt64 {
        return sampler.duration
    }

    /// `true` if the receiver is reversible.
    public var isReversible: Bool {
        return sampler.isReversible
    }

    /// Constructs an `Animation` object, which produces animated values by
    /// sampling underlying `AnimationData`.
    ///
    /// - parameters:
    ///   - data: The `AnimationData` to be sampled.
    ///   - duration: Duration of the one pass of sampling, in virtual
    ///     time ticks. If this value is `0`, then the sampling is always at
    ///     position `1.0`.
    ///   - repeating: How many times the sampling process shall
    ///     be repeated. If this value is `0`, then
    ///   - reversible: If `repeating` is larger than `1`, this
    ///     parameter decides that after sample position reaches `1.0`, if
    ///     the sample position should decrease, instead of resetting to `0.0`.
    public init (
        data: T,
        duration: UInt64,
        repeating: UInt64 = 1,
        reversible: Bool = false
    ) {
        self.data = data
        self.sampler = Sampler(
            duration: duration,
            repeating: repeating,
            reversible: reversible
        )
    }

    /// Returns `true` if the receiver finishes sampling at virtual time tick `t`.
    public func isFinished(at t: UInt64) -> Bool {
        switch self._state {
        case let .run(startTime: st):
            return sampler.isFinished(at: t - st)
        default:
            return false
        }
    }

    /// Returns `true` if the receiver is paused.
    public var isPaused: Bool {
        switch self._state {
        case .paused(_, _):
            return true
        default:
            return false
        }
    }

    /// Samples the animation data at virtual time `tick`.
    ///
    /// - returns: Sampled value.
    public func sample(at tick: UInt64) -> Value {
        switch self._state {
        case .inactive:
            return data.sample(at: 0)
        case let .paused(at: t, startTime: st):
            assert(t > 0)
            guard tick > st else {
                return data.sample(at: 0)
            }
            return data.sample(at: sampler.samplePosition(at: min(tick - st, t)))
        case let .run(startTime: st):
            guard self.duration > 0 else {
                return data.sample(at: 1)
            }
            guard tick > st else {
                return data.sample(at: 0)
            }
            return data.sample(at: sampler.samplePosition(at: tick - st))
        }
    }

    /// Starts the receiver at virtual time `tick`.
    public mutating func start(at tick: UInt64) -> Value {
        self._state = .run(startTime: tick)
        return data.sample(at: 0)
    }

    /// Pauses the sampling at virtual time 'tick'.
    public mutating func pause(at tick: UInt64) -> Value {
        switch self._state {
        case let .run(startTime: st):
            let t = tick - st
            if sampler.isFinished(at: t) {
                return data.sample(at: 1)
            }
            self._state = .paused(at: t, startTime: st)
            return data.sample(at: sampler.samplePosition(at: t))
        case let .paused(at: t, _):
            return data.sample(at: sampler.samplePosition(at: t))
        case .inactive:
            return data.sample(at: 0)
        }
    }

    public mutating func resume(at tick: UInt64) -> Value? {
        switch self._state {
        case let .paused(at: t, startTime: st) where tick >= st + t:
            assert(!sampler.isFinished(at: t))
            self._state = .run(startTime: tick - t)
            return data.sample(at: sampler.samplePosition(at: t))
        default:
            return nil
        }
    }
}
