import SwiftUI

/// Level 4 — two faint lines on screen, one horizontal, one vertical.
///
/// The horizontal line brightens in dark mode (moon).
/// The vertical line brightens when gravity is flipped up (↑).
/// Both must be active at the same time to form a cross and solve the level.
struct Level4CrossView: View {
    @Environment(GameViewModel.self) private var game
    @State private var hasSolved = false

    // Level starts: light mode (☀️) + gravity normal (↓) — both lines are dim.
    // Solution: dark mode (🌙) + gravity up (↑) — both lines are bright.

    private var hBrightness: Double { game.isDarkMode ? 0.85 : 0.07 }
    private var vBrightness: Double { !game.isGravityNormal ? 0.85 : 0.07 }

    private var isSolved: Bool {
        game.isDarkMode && !game.isGravityNormal
    }

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()

            // Horizontal — responds to dark mode
            Rectangle()
                .frame(width: 80, height: 0.5)
                .foregroundStyle(.white.opacity(hBrightness))
                .animation(.easeOut(duration: 0.4), value: game.isDarkMode)

            // Vertical — responds to gravity up
            Rectangle()
                .frame(width: 0.5, height: 80)
                .foregroundStyle(.white.opacity(vBrightness))
                .animation(.easeOut(duration: 0.4), value: game.isGravityNormal)
        }
        .onChange(of: game.isDarkMode)      { _, _ in checkSolve() }
        .onChange(of: game.isGravityNormal) { _, _ in checkSolve() }
    }

    private func checkSolve() {
        guard !hasSolved, isSolved else { return }
        hasSolved = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.9) {
            game.solveCurrentLevel()
        }
    }
}
