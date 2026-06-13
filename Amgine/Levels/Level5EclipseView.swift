import SwiftUI

struct Level5EclipseView: View {
    @Environment(GameViewModel.self) private var game
    @State private var hasSolved = false

    private var verticalOffset: CGFloat {
        game.isGravityNormal ? 0 : -72
    }

    private var horizontalOffset: CGFloat {
        game.isDarkMode ? 46 : 0
    }

    private var shadowOpacity: Double {
        game.isDarkMode ? 0.92 : 0.28
    }

    private var isSolved: Bool {
        !game.isDarkMode && game.isGravityNormal
    }

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()

            Circle()
                .fill(.white.opacity(0.92))
                .frame(width: 120, height: 120)

            Circle()
                .fill(.black.opacity(shadowOpacity))
                .frame(width: 120, height: 120)
                .offset(x: horizontalOffset, y: verticalOffset)
                .animation(.spring(response: 0.45, dampingFraction: 0.82), value: game.isGravityNormal)
                .animation(.easeInOut(duration: 0.35), value: game.isDarkMode)
        }
        .onChange(of: game.isDarkMode) { _, _ in checkSolve() }
        .onChange(of: game.isGravityNormal) { _, _ in checkSolve() }
    }

    private func checkSolve() {
        guard !hasSolved, isSolved else { return }
        hasSolved = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.8) {
            game.solveCurrentLevel()
        }
    }
}
