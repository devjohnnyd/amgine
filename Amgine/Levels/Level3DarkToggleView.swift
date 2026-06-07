import SwiftUI

/// Level 3 — the screen is dark. The sun icon in the corner is the only clue.
/// Toggling to light mode reveals "enigma" and solves the level.
struct Level3DarkToggleView: View {
    @Environment(GameViewModel.self) private var game
    @State private var revealed = false
    @State private var hasSolved = false

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()

            Text("enigma")
                .font(.system(size: 44, weight: .ultraLight, design: .serif))
                .tracking(10)
                .foregroundStyle(.white.opacity(0.85))
                .opacity(revealed ? 1 : 0)
                .animation(.easeIn(duration: 0.6), value: revealed)
        }
        .onChange(of: game.isDarkMode) { _, dark in
            guard !hasSolved, !dark else { return }
            revealed = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.4) {
                guard !hasSolved else { return }
                hasSolved = true
                game.solveCurrentLevel()
            }
        }
    }
}
