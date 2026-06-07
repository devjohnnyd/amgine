import SwiftUI

struct GameContainerView: View {
    @Environment(GameViewModel.self) private var game
    @State private var gravityMotion = MotionManager()

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

            // Persistent overlay buttons — appear once unlocked and stay for all subsequent levels.
            if game.gravityUnlocked || game.darkModeUnlocked {
                VStack {
                    HStack {
                        // Apple/gravity button — top-left, rotates live with device orientation.
                        if game.gravityUnlocked {
                            Button {
                                game.flipGravity()
                            } label: {
                                Image(systemName: "apple.logo")
                                    .font(.system(size: 18, weight: .ultraLight))
                                    .foregroundStyle(.white.opacity(0.65))
                                    // Rotates 0° when upright, 180° when fully flipped.
                                    .rotationEffect(.degrees((gravityMotion.verticalGravity + 1) * 90))
                                    .animation(.easeOut(duration: 0.2), value: gravityMotion.verticalGravity)
                                    .padding(20)
                            }
                        }

                        Spacer()

                        // Sun/moon toggle — top-right.
                        if game.darkModeUnlocked {
                            Button {
                                game.toggleDarkMode()
                            } label: {
                                Image(systemName: game.isDarkMode ? "sun.max" : "moon")
                                    .font(.system(size: 18, weight: .ultraLight))
                                    .foregroundStyle(.white.opacity(0.65))
                                    .padding(20)
                            }
                        }
                    }
                    Spacer()
                }
            }
        }
        .onAppear {
            if game.gravityUnlocked { gravityMotion.start() }
        }
        .onChange(of: game.gravityUnlocked) { _, unlocked in
            if unlocked { gravityMotion.start() }
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
