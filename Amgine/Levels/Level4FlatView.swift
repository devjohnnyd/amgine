import SwiftUI

/// Level 4 — "lay the phone face-up flat."
///
/// Starts in whatever mode Level 3 left off (light, sun icon showing).
/// The lay-flat line is barely visible in light mode and does nothing.
/// The player must tap the sun → moon (switch to dark mode) to activate it.
/// In dark mode the line brightens as the phone tilts face-up; holding it
/// flat solves the level.
struct Level4FlatView: View {
    @Environment(GameViewModel.self) private var game
    @State private var motion = MotionManager()
    @State private var hasSolved = false

    /// Only meaningful when in dark mode.
    private var flatProgress: Double {
        game.isDarkMode ? min(max(-motion.flatGravity, 0), 1) : 0
    }

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()

            Rectangle()
                .frame(width: 80, height: 0.5)
                .foregroundStyle(
                    .white.opacity(
                        game.isDarkMode
                            ? 0.10 + flatProgress * 0.90   // active in dark mode
                            : 0.08                          // hint it exists in light mode
                    )
                )
                .animation(.easeOut(duration: 0.25), value: flatProgress)
                .animation(.easeOut(duration: 0.4), value: game.isDarkMode)
        }
        .onAppear { motion.start() }
        .onDisappear { motion.stop() }
        .onChange(of: flatProgress) { _, value in
            guard !hasSolved, game.isDarkMode, value > 0.92 else { return }
            hasSolved = true
            motion.stop()
            game.solveCurrentLevel()
        }
    }
}
