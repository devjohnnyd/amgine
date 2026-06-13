import SwiftUI

struct Level4CrossView: View {
    @Environment(GameViewModel.self) private var game
    @State private var hasSolved = false

    private var hBrightness: Double { game.isDarkMode ? 0.85 : 0.07 }
    private var vBrightness: Double { !game.isGravityNormal ? 0.85 : 0.07 }

    private var isSolved: Bool {
        game.isDarkMode && !game.isGravityNormal
    }

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()

            Rectangle()
                .frame(width: 80, height: 0.5)
                .foregroundStyle(.white.opacity(hBrightness))
                .animation(.easeOut(duration: 0.4), value: game.isDarkMode)

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
