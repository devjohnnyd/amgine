import SwiftUI

@main
struct AmgineApp: App {
    @State private var game = GameViewModel()

    var body: some Scene {
        WindowGroup {
            GameContainerView()
                .environment(game)
                .preferredColorScheme(.dark)
                .statusBarHidden(true)
                .persistentSystemOverlays(.hidden)
        }
    }
}
