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
        }
    }
}

/// Placeholder shown after the last implemented level is solved.
/// Doubles as the "Level 2 — coming soon" gate for now.
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
