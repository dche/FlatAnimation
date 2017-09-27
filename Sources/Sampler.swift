//
// FlatAnimation - Sampler.swift.
//
// Copyright (c) 2016 The FlatAnimation authors.
// Licensed under MIT License.

#if os(Linux)
    import Glibc
#else
    import simd
#endif

enum SampleDirection: Int {
    case forward = 1, backward = -1
}

struct Sampler {

    let duration: Int

    let repeatition: Int

    let reversible: Bool

    private let initialPosition: Double

    private let targetPosition: Double

    // How many loops has finished.
    private var _loop_count: Int = 0

    // Used iff `reversible` is true.
    private var _direction: SampleDirection

    // [0, duration]
    private var _step: Int = 0

    var isFinished: Bool { return _loop_count >= repeatition }

    func spawn(toPosition: Double, count: Int) -> Sampler {
        return Sampler(
            duration: UInt64(duration + 1),
            reversible: reversible,
            repeatition: count,
            initialPosition: position(at: _step),
            targetPosition: toPosition,
            initialDirection: _direction
        )
    }

    private func step(at: Double) -> Int {
        return Int(floor(Double(duration) * at))
    }

    private func position(at: Int) -> Double {
        return Double(at) / Double(duration)
    }

    init (
        duration: UInt64,
        reversible: Bool,
        repeatition: Int,
        initialPosition: Double,
        targetPosition: Double,
        initialDirection: SampleDirection
    ) {
        assert(duration > 0)
        assert(repeatition > 0)
        assert(initialPosition >= 0 && initialPosition <= 1)
        assert(targetPosition >= 0 && targetPosition <= 1)

        self.duration = Int(duration - 1)
        self.repeatition = repeatition
        self._loop_count = 0
        self.reversible = reversible
        self.initialPosition = initialPosition
        self.targetPosition = targetPosition
        self._direction = initialDirection
        self._step = step(at: initialPosition)
    }

    var currentPosition: Double {
        return position(at: _step)
    }

    mutating func samplePosition(after dt: UInt64) -> Double {
        assert(dt > 0)

        let initialStep = step(at: initialPosition)
        let targetStep = step(at: targetPosition)

        func closeLoop() {
            guard reversible else {
                if self._step == targetStep { self._loop_count += 1 }
                return
            }
            let target: Int
            if self._loop_count % 2 == 0 { target = targetStep }
            else { target = initialStep }
            if self._step == target { self._loop_count += 1 }
        }

        func nextStep() -> Int {
            guard reversible else {
                if self._step == self.duration { return 0 }
                else { return self._step + 1 }
            }
            if self._step == 0 { self._direction = .forward }
            else if self._step == self.duration { self._direction = .backward }
            return self._step + self._direction.rawValue
        }

        var i: UInt64 = 0
        while i < dt && !isFinished {
            _step = nextStep()
            closeLoop()
            i += 1
        }
        return self.currentPosition
    }
}
