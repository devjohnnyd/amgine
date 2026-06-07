import SwiftUI

/// Level 3 — "lay the phone face-up on a flat surface."
///
/// A thin horizontal line is visible on screen, dim at first. As the phone
/// tilts toward face-up the line brightens — the same quiet "warmer" signal
/// as Level 1. Resting the phone flat face-up solves the level.
///
/// gravity.z ≈ -1 when face-up flat, 0 when upright.
/// progress = clamp(-gravity.z, 0, 1)
struct Level3FlatView: View {
    @Environment(GameViewModel.self) private var game
    @State private var motion = MotionManager()
    @State private var hasSolved = false

    /// 0 when upright, 1 when fully face-up flat.
    private var progress: Double {
        min(max(-motion.flatGravity, 0), 1)
    }

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()

            Rectangle()
                .frame(width: 80, height: 0.5)
                .foregroundStyle(.white.opacity(0.10 + progress * 0.90))
                .animation(.easeOut(duration: 0.25), value: progress)
        }
        .onAppear { motion.start() }
        .onDisappear { motion.stop() }
        .onChange(of: progress) { _, value in
            guard !hasSolved, value > 0.92 else { return }
            hasSolved = true
            motion.stop()
            game.solveCurrentLevel()
        }
    }
}
