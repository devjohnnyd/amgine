import SwiftUI

struct Level1FlipView: View {
    @Environment(GameViewModel.self) private var game
    @State private var motion = MotionManager()
    @State private var didRevealGravity = false
    @State private var hasCompletedTap = false

    private var progress: Double {
        min(max((motion.verticalGravity + 1) / 2, 0), 1)
    }

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()

            Text("amgine")
                .font(.system(size: 44, weight: .ultraLight, design: .serif))
                .tracking(10)
                .foregroundStyle(.white.opacity(wordOpacity))
                .rotationEffect(.degrees(180))
                .animation(.easeOut(duration: 0.25), value: progress)
        }
        .onAppear { motion.start() }
        .onDisappear { motion.stop() }
        .onChange(of: progress) { _, value in
            guard !didRevealGravity, value > 0.92 else { return }
            didRevealGravity = true
            game.revealGravityButton()
        }
        .onChange(of: game.isGravityNormal) { oldValue, newValue in
            guard didRevealGravity, !hasCompletedTap, oldValue != newValue else { return }
            hasCompletedTap = true
            motion.stop()
            game.solveCurrentLevel()
        }
    }

    private var wordOpacity: Double {
        let base = 0.10 + progress * 0.60
        return didRevealGravity ? min(base + 0.25, 1.0) : base
    }
}
