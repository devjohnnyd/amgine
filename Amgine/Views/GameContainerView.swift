import SwiftUI

struct GameContainerView: View {
    @Environment(GameViewModel.self) private var game

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()

            if let level = game.currentLevel {
                level.view
                    .id(level.id)
                    .transition(.opacity)
            } else {
                CompletionView()
                    .transition(.opacity)
            }

            // Sun/moon toggle — unlocked after Level 2 is solved, persists for all subsequent levels.
            if game.darkModeUnlocked {
                VStack {
                    HStack {
                        Spacer()
                        Button {
                            game.toggleDarkMode()
                        } label: {
                            Image(systemName: game.isDarkMode ? "sun.max" : "moon")
                                .font(.system(size: 18, weight: .ultraLight))
                                .foregroundStyle(.white.opacity(0.65))
                                .padding(20)
                        }
                    }
                    Spacer()
                }
            }
        }
    }
}

private struct CompletionView: View {
    var body: some View {
        VStack(spacing: 14) {
            Image(systemName: "circle.dotted")
                .font(.system(size: 40, weight: .ultraLight))
            Text("more to come")
                .font(.system(.footnote, design: .serif))
                .tracking(4)
                .foregroundStyle(.secondary)
        }
        .foregroundStyle(.white.opacity(0.7))
    }
}
