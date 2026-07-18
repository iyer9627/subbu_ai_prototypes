import SwiftUI

/// A rectangle with softly deckled, torn-paper edges. The wobble is
/// generated from a seed so a given card keeps the same tear between
/// renders instead of shimmering.
struct TornPaperShape: Shape {
    var seed: UInt64 = 1

    func path(in rect: CGRect) -> Path {
        var generator = SplitMix64(seed: seed)
        let step: CGFloat = 16
        let wobble: CGFloat = 2.6

        func jitter() -> CGFloat {
            (CGFloat(generator.next() % 1000) / 1000 - 0.5) * 2 * wobble
        }

        // Walk the perimeter clockwise, bowing each segment slightly.
        var points: [CGPoint] = []
        let corners = [
            CGPoint(x: rect.minX, y: rect.minY),
            CGPoint(x: rect.maxX, y: rect.minY),
            CGPoint(x: rect.maxX, y: rect.maxY),
            CGPoint(x: rect.minX, y: rect.maxY),
        ]
        for i in 0..<4 {
            let from = corners[i]
            let to = corners[(i + 1) % 4]
            let length = hypot(to.x - from.x, to.y - from.y)
            let count = max(2, Int(length / step))
            for j in 0..<count {
                let t = CGFloat(j) / CGFloat(count)
                var x = from.x + (to.x - from.x) * t
                var y = from.y + (to.y - from.y) * t
                if j != 0 {
                    // Jitter perpendicular to the edge only.
                    if from.y == to.y { y += jitter() } else { x += jitter() }
                }
                points.append(CGPoint(x: x, y: y))
            }
        }

        var path = Path()
        guard let first = points.first else { return path }
        path.move(to: first)
        for i in 1..<points.count {
            let previous = points[i - 1]
            let current = points[i]
            let mid = CGPoint(x: (previous.x + current.x) / 2, y: (previous.y + current.y) / 2)
            path.addQuadCurve(to: mid, control: previous)
        }
        path.closeSubpath()
        return path
    }
}

/// Tiny deterministic RNG so tears are stable per seed.
struct SplitMix64 {
    private var state: UInt64
    init(seed: UInt64) { state = seed &+ 0x9E3779B97F4A7C15 }
    mutating func next() -> UInt64 {
        state &+= 0x9E3779B97F4A7C15
        var z = state
        z = (z ^ (z >> 30)) &* 0xBF58476D1CE4E5B9
        z = (z ^ (z >> 27)) &* 0x94D049BB133111EB
        return z ^ (z >> 31)
    }
}
