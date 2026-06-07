import SwiftUI

/// Level 4 — "lay the phone face-up on a flat surface."
///
/// A thin horizontal line brightens as the phone approaches face-up.
/// gravity.z ≈ -1 when face-up flat, 0 when upright.
struct Level4FlatView: View {
    @Environment(GameViewModel.self) private var game
    @State private var motion = MotionManager()
    @State private var hasSolved = false

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
