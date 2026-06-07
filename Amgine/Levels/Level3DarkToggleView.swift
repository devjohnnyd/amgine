import SwiftUI

/// Level 3 — the word "enigma" is visible in the dark but vanishes in the light.
///
/// The sun icon (top-right) toggles light/dark mode. Switching to light reveals
/// an empty cup and hides the word. Holding the apple icon (top-left) fills the
/// cup with apple juice over ~3.5 seconds. A full cup solves the level.
struct Level3DarkToggleView: View {
    @Environment(GameViewModel.self) private var game

    @State private var fillProgress: Double = 0
    @State private var hasSolved = false

    var body: some View {
        ZStack {
            // Background shifts with mode
            (game.isDarkMode ? Color.black : Color(white: 0.96))
                .ignoresSafeArea()
                .animation(.easeInOut(duration: 0.5), value: game.isDarkMode)

            // "enigma" — visible in dark, invisible in light
            Text("enigma")
                .font(.system(size: 44, weight: .ultraLight, design: .serif))
                .tracking(10)
                .foregroundStyle(.white.opacity(game.isDarkMode ? 0.55 : 0))
                .animation(.easeInOut(duration: 0.5), value: game.isDarkMode)

            // Cup — appears in light mode only
            if !game.isDarkMode {
                JuiceCup(fillProgress: fillProgress)
                    .transition(.opacity)
            }
        }
        // Fill cup while apple is held AND in light mode
        .task(id: game.isAppleHeld && !game.isDarkMode) {
            guard game.isAppleHeld, !game.isDarkMode else { return }
            while !Task.isCancelled, fillProgress < 1.0,
                  game.isAppleHeld, !game.isDarkMode {
                try? await Task.sleep(for: .milliseconds(16))
                fillProgress = min(fillProgress + 0.016 / 3.5, 1.0)
            }
            if fillProgress >= 1.0, !hasSolved {
                hasSolved = true
                game.solveCurrentLevel()
            }
        }
    }
}

// MARK: - Cup

private struct JuiceCup: View {
    let fillProgress: Double

    private let cupW: CGFloat = 76
    private let cupH: CGFloat = 108
    private let radius: CGFloat = 6

    var body: some View {
        ZStack(alignment: .bottom) {
            // Juice fill (clipped to cup shape)
            Rectangle()
                .fill(
                    LinearGradient(
                        colors: [
                            Color(red: 0.98, green: 0.78, blue: 0.15),
                            Color(red: 0.88, green: 0.58, blue: 0.05)
                        ],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
                .frame(width: cupW - 2, height: max(0, CGFloat(fillProgress) * (cupH - 2)))
        }
        .frame(width: cupW, height: cupH)
        .clipShape(RoundedRectangle(cornerRadius: radius))
        .overlay {
            RoundedRectangle(cornerRadius: radius)
                .stroke(Color(white: 0.55).opacity(0.6), lineWidth: 0.75)
        }
    }
}
