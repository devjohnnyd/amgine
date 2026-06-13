import SwiftUI

@main
struct AmgineApp: App {
    @State private var game = GameViewModel()
    @Environment(\.scenePhase) private var scenePhase

    var body: some Scene {
        WindowGroup {
            GameContainerView()
                .environment(game)
                .preferredColorScheme(.dark)
                .statusBarHidden(true)
                .persistentSystemOverlays(.hidden)
                .onChange(of: scenePhase) { _, newPhase in
                    guard newPhase == .background else { return }
                    game.resetProgress()
                }
        }
    }
}
