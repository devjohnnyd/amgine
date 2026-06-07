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

            if game.gravityUnlocked || game.darkModeUnlocked {
                VStack {
                    HStack {
                        // Gravity toggle — top-left, rotates live with device orientation.
                        // Short tap flips gravity; icon faces the same way as the phone.
                        if game.gravityUnlocked {
                            Button { game.flipGravity() } label: {
                                Image(systemName: game.isGravityNormal ? "arrow.down" : "arrow.up")
                                    .font(.system(size: 16, weight: .ultraLight))
                                    .foregroundStyle(overlayColor)
                                    .padding(20)
                            }
                        }

                        Spacer()

                        // Sun/moon toggle — top-right.
                        if game.darkModeUnlocked {
                            Button { game.toggleDarkMode() } label: {
                                Image(systemName: game.isDarkMode ? "moon" : "sun.max")
                                    .font(.system(size: 18, weight: .ultraLight))
                                    .foregroundStyle(overlayColor)
                                    .padding(20)
                            }
                        }
                    }
                    Spacer()
                }
            }
        }
    }

    private var overlayColor: Color {
        game.isDarkMode ? .white.opacity(0.65) : .black.opacity(0.55)
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
