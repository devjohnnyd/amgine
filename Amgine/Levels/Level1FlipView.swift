import SwiftUI

/// Level 1 — "turn the phone upside down."
///
/// No instructions. The only thing on screen is the word `amgine`, drawn
/// rotated 180° in the device's frame. Because the app's orientation is locked
/// to portrait, the word looks upside-down to a player holding the phone
/// normally — the single ambiguous cue. It only reads correctly once the phone
/// is physically flipped, at which point the puzzle is solved.
///
/// As the player approaches the solution the word brightens (a quiet "warmer"
/// signal that rewards intuition without spelling anything out).
struct Level1FlipView: View {
    @Environment(GameViewModel.self) private var game
    @State private var motion = MotionManager()
    @State private var hasSolved = false

    /// 0 when upright, 1 when fully flipped.
    private var progress: Double {
        min(max((motion.verticalGravity + 1) / 2, 0), 1)
    }

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()

            Text("amgine")
                .font(.system(size: 44, weight: .ultraLight, design: .serif))
                .tracking(10)
                .foregroundStyle(.white.opacity(0.10 + progress * 0.90))
                .rotationEffect(.degrees(180))
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
