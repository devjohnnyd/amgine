import SwiftUI

struct Level3DarkToggleView: View {
    @Environment(GameViewModel.self) private var game
    @State private var hasSolved = false

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()

            Text("enigma")
                .font(.system(size: 44, weight: .ultraLight, design: .serif))
                .tracking(10)
                .foregroundStyle(.white.opacity(0.85))
                .opacity(game.isDarkMode ? 1 : 0)
                .overlay {
                    Text("enigma")
                        .font(.system(size: 44, weight: .ultraLight, design: .serif))
                        .tracking(10)
                        .foregroundStyle(.white.opacity(game.isDarkMode ? 0 : 0.08))
                }
                .animation(.easeInOut(duration: 0.5), value: game.isDarkMode)
        }
        .onChange(of: game.isDarkMode) { _, dark in
            guard !hasSolved, !dark else { return }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.9) {
                guard !hasSolved else { return }
                hasSolved = true
                game.solveCurrentLevel()
            }
        }
    }
}
