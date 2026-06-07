import SwiftUI

struct GameContainerView: View {
    @Environment(GameViewModel.self) private var game
    @State private var gravityMotion = MotionManager()
    @State private var pressStart: Date? = nil

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
                        // Apple icon — top-left.
                        // Short press (<0.3s): flip gravity.
                        // Hold: sets isAppleHeld so levels can react (e.g. fill cup in Level 3).
                        if game.gravityUnlocked {
                            Image(systemName: "apple.logo")
                                .font(.system(size: 18, weight: .ultraLight))
                                .foregroundStyle(overlayColor)
                                .rotationEffect(.degrees((gravityMotion.verticalGravity + 1) * 90))
                                .animation(.easeOut(duration: 0.2), value: gravityMotion.verticalGravity)
                                .padding(20)
                                .contentShape(Rectangle())
                                .gesture(
                                    DragGesture(minimumDistance: 0)
                                        .onChanged { _ in
                                            if pressStart == nil {
                                                pressStart = Date()
                                                game.setAppleHeld(true)
                                            }
                                        }
                                        .onEnded { _ in
                                            let duration = pressStart.map { -$0.timeIntervalSinceNow } ?? 0
                                            pressStart = nil
                                            game.setAppleHeld(false)
                                            if duration < 0.3 {
                                                game.flipGravity()
                                            }
                                        }
                                )
                        }

                        Spacer()

                        // Sun/moon toggle — top-right.
                        if game.darkModeUnlocked {
                            Button { game.toggleDarkMode() } label: {
                                Image(systemName: game.isDarkMode ? "sun.max" : "moon")
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
        .onAppear {
            if game.gravityUnlocked { gravityMotion.start() }
        }
        .onChange(of: game.gravityUnlocked) { _, unlocked in
            if unlocked { gravityMotion.start() }
        }
    }

    // Buttons are white on dark backgrounds, dark on light backgrounds.
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
