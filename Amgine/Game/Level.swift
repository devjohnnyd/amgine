import SwiftUI

/// A single puzzle. The view is responsible for detecting its own solve
/// condition and calling `game.solveCurrentLevel()` from the environment.
struct Level: Identifiable {
    let id: Int
    let title: String
    let view: AnyView

    init(id: Int, title: String, @ViewBuilder view: () -> some View) {
        self.id = id
        self.title = title
        self.view = AnyView(view())
    }
}
