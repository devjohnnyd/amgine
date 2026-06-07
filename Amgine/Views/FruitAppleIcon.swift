import SwiftUI

/// A minimal fruit-apple icon drawn to match the thin stroke weight of
/// SF Symbols like `sun.max` and `moon`. Two lobes at the top, tapered
/// body, short curved stem.
struct FruitAppleIcon: View {
    var color: Color = .white.opacity(0.65)
    var size: CGFloat = 18

    var body: some View {
        Canvas { ctx, rect in
            let w = rect.width
            let h = rect.height
            let lw: CGFloat = max(0.6, w * 0.055)   // stroke weight scales with size

            // ── Body ──────────────────────────────────────────────────
            // Start at the notch dip (center, between the two lobes).
            var body = Path()
            body.move(to: .init(x: w * 0.50, y: h * 0.29))

            // Notch → left shoulder (top of left lobe)
            body.addCurve(
                to: .init(x: w * 0.20, y: h * 0.20),
                control1: .init(x: w * 0.38, y: h * 0.29),
                control2: .init(x: w * 0.28, y: h * 0.16)
            )
            // Left shoulder → widest left point
            body.addCurve(
                to: .init(x: w * 0.04, y: h * 0.54),
                control1: .init(x: w * 0.04, y: h * 0.20),
                control2: .init(x: w * 0.02, y: h * 0.36)
            )
            // Widest left → bottom center
            body.addCurve(
                to: .init(x: w * 0.50, y: h * 0.96),
                control1: .init(x: w * 0.04, y: h * 0.80),
                control2: .init(x: w * 0.22, y: h * 0.96)
            )
            // Bottom center → widest right point
            body.addCurve(
                to: .init(x: w * 0.96, y: h * 0.54),
                control1: .init(x: w * 0.78, y: h * 0.96),
                control2: .init(x: w * 0.96, y: h * 0.80)
            )
            // Widest right → right shoulder (top of right lobe)
            body.addCurve(
                to: .init(x: w * 0.80, y: h * 0.20),
                control1: .init(x: w * 0.98, y: h * 0.36),
                control2: .init(x: w * 0.96, y: h * 0.20)
            )
            // Right shoulder → notch dip
            body.addCurve(
                to: .init(x: w * 0.50, y: h * 0.29),
                control1: .init(x: w * 0.72, y: h * 0.16),
                control2: .init(x: w * 0.62, y: h * 0.29)
            )
            body.closeSubpath()
            ctx.stroke(body, with: .color(color), lineWidth: lw)

            // ── Stem ──────────────────────────────────────────────────
            var stem = Path()
            stem.move(to: .init(x: w * 0.50, y: h * 0.26))
            stem.addQuadCurve(
                to: .init(x: w * 0.64, y: h * 0.06),
                control: .init(x: w * 0.54, y: h * 0.13)
            )
            ctx.stroke(stem, with: .color(color), lineWidth: lw)
        }
        .frame(width: size * 0.88, height: size)
    }
}
