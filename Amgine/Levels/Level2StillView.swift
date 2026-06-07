import SwiftUI

/// Level 2 — "hold perfectly still."
///
/// A thin circle floats on screen, drifting with every movement of the phone
/// (offset driven by userAcceleration). The circle brightens as the phone
/// settles. Holding still for three uninterrupted seconds solves the level.
struct Level2StillView: View {
    @Environment(GameViewModel.self) private var game
    @State private var motion = MotionManager()
    @State private var hasSolved = false
    @State private var stillStart: Date? = nil

    private let threshold: Double = 0.04
    private let requiredDuration: Double = 3.0

    /// 0 when moving, ramps to 1 over three seconds of stillness.
    private var stillProgress: Double {
        guard let start = stillStart else { return 0 }
        return min(Date().timeIntervalSince(start) / requiredDuration, 1)
    }

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()

            Circle()
                .stroke(lineWidth: 0.5)
                .frame(width: 72, height: 72)
                .foregroundStyle(.white.opacity(0.10 + stillProgress * 0.90))
                .scaleEffect(1.0 + (1.0 - stillProgress) * 0.3)
                .offset(
                    x: motion.userAccelX * 22,
                    y: -motion.userAccelY * 22
                )
                .animation(.easeOut(duration: 0.2), value: stillProgress)
        }
        .onAppear { motion.start() }
        .onDisappear { motion.stop() }
        .onChange(of: motion.userAccelMagnitude) { _, magnitude in
            if magnitude < threshold {
                if stillStart == nil { stillStart = Date() }
            } else {
                stillStart = nil
            }

            guard !hasSolved,
                  let start = stillStart,
                  Date().timeIntervalSince(start) >= requiredDuration else { return }
            hasSolved = true
            motion.stop()
            game.solveCurrentLevel()
        }
    }
}
