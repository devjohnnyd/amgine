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

            if game.gravityButtonVisible || game.darkModeButtonVisible {
                VStack {
                    HStack {
                        if game.gravityButtonVisible {
                            Button { game.flipGravity() } label: {
                                Image(systemName: game.isGravityNormal ? "arrow.down" : "arrow.up")
                                    .font(.system(size: 16, weight: .ultraLight))
                                    .foregroundStyle(overlayColor)
                                    .padding(20)
                            }
                            .transition(.opacity.combined(with: .scale))
                        }

                        Spacer()

                        if game.darkModeButtonVisible {
                            Button { game.toggleDarkMode() } label: {
                                Image(systemName: game.isDarkMode ? "moon" : "sun.max")
                                    .font(.system(size: 18, weight: .ultraLight))
                                    .foregroundStyle(overlayColor)
                                    .padding(20)
                            }
                            .transition(.opacity.combined(with: .scale))
                        }
                    }
                    Spacer()
                }
                .animation(.easeInOut(duration: 0.25), value: game.gravityButtonVisible)
                .animation(.easeInOut(duration: 0.25), value: game.darkModeButtonVisible)
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
