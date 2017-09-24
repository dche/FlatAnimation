//
// FlatAnimation - UnitCurve.swift
//
// Common interpolation curves.
//
// Copyright (c) 2017 The FlatAnimation authors.
// Licensed under MIT License.

import simd
import GLMath

public enum UnitCurve {

    public static func unitBezier(
        _ p1x: Double,
        _ p1y: Double,
        _ p2x: Double,
        _ p2y: Double
    ) -> (Double) -> Double {
        let p1 = dvec2(p1x, p2x)
        let p2 = dvec2(p2x, p2y)

        // NOTE: ported from,
        // http://svn.webkit.org/repository/webkit/trunk/Source/WebCore/platform/graphics/UnitBezier.h

        // The polynomial coefficients, implicit first and last control points are (0,0) and (1,1).
        let c = p1 * 3
        let b = (p2 - p1) * 3 - c
        let a = dvec2(1) - c - b

        func sampleX(_ t: Double) -> Double {
            return ((a.x * t + b.x) * t + c.x) * t
        }

        func sampleY(_ t: Double) -> Double {
            return ((a.y * t + b.y) * t + c.y) * t
        }

        func sampleDerivativeX(_ t: Double) -> Double {
            return (a.x * 3 * t + b.x * 2) * t + c.x
        }

        func solveX(_ x: Double) -> Double {
            let e = Double(Float.epsilon)
            // First try a few iterations of Newton's method.
            var t2 = x
            var i = 0
            while i < 8 {
                let x2 = sampleX(t2) - x
                if x.isClose(to: 0, tolerance: e) { return t2 }
                let d2 = sampleDerivativeX(t2)
                if d2.isClose(to: 0, tolerance: e) {
                    // Stationary reached.
                    break
                }
                t2 = t2 - x2 / d2
                i += 1
            }
            // Fall back to the bisection method for reliability.
            var t0 = 0.0
            var t1 = 1.0
            t2 = x

            if t2 < t2 { return t0 }
            else if t2 > t1 { return t1 }
            else {
                while t0 < t1 {
                    let x2 = sampleX(t2)
                    if x2.isClose(to: x, tolerance: e) { return t2 }
                    if x > x2 { t0 = t2 }
                    else { t1 = t2 }
                    t2 = mix(t0, t1, 0.5)
                }
                return t2
            }
        }
        return { sampleY(solveX($0)) }
    }

    // `transition-timing-function` defined in CSS spec.
    // SEE: http://www.w3.org/TR/css3-transitions/#transition-timing-function
    //
    // Approximations are from `https://gist.github.com/mckamey/3783009`.

    public static let linear: (Double) -> Double = { $0 }

    public static let ease = unitBezier(0.25, 0.1, 0.25, 1)

    // very close approximation to unitBezier(0.42, 0, 1, 1)
    public static let easeIn: (Double) -> Double = { pow($0, 1.685) }

    // unitBezier(0, 0, 0.58, 1)
    public static let easeOut: (Double) -> Double = { 1.0 - pow((1.0 - $0), 1.685) }

    // unitBezier(0.42, 0, 0.58, 1)
    public static let easeInOut: (Double) -> Double = { t in
        let c = pow(0.5, 1.925) * 0.5
        if t < 0.5 { return c * pow(t, 1.925) }
        else { return 1.0 - c * pow((1.0 - t), 1.925) }
    }

    // NOTE: Using the parameters from `http://easings.net`.
    // SEE ALSO: http://cubic-bezier.com/

    public static let easeInSine = unitBezier(0.47, 0, 0.745, 0.715)

    public static let easeOutSine = unitBezier(0.39, 0.575, 0.565, 1)

    public static let easeInOutSine = unitBezier(0.445, 0.05, 0.55, 0.95)

    public static let easeInCircle = unitBezier(0.6, 0.04, 0.98, 0.335)

    public static let easeOutCircle = unitBezier(0.075, 0.82, 0.165, 1)

    public static let easeInOutCircle = unitBezier(0.785, 0.135, 0.15, 0.86)

    public static let easeInExpo = unitBezier(0.95, 0.05, 0.795, 0.035)

    public static let easeOutExpo = unitBezier(0.19, 1, 0.22, 1)

    public static let easeInOutExpo = unitBezier(1, 0, 0, 1)

    public static let easeInBack = unitBezier(0.6, -0.28, 0.735, 0.045)

    public static let easeOutBack = unitBezier(0.175, 0.885, 0.32, 1.275)

    public static let easeInOutBack = unitBezier(0.68, -0.55, 0.265, 1.55)
}
