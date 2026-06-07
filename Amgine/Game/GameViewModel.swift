import SwiftUI

@MainActor
@Observable
final class GameViewModel {
    private static let progressKey = "amgine.currentLevelIndex"

    private let defaults: UserDefaults

    private(set) var currentIndex: Int {
        didSet {
            defaults.set(currentIndex, forKey: Self.progressKey)
        }
    }

    init(defaults: UserDefaults = .standard) {
        self.defaults = defaults
        let savedIndex = defaults.integer(forKey: Self.progressKey)
        self.currentIndex = min(max(savedIndex, 0), LevelRegistry.levels.count)
    }

    var currentLevel: Level? {
        guard currentIndex >= 0, currentIndex < LevelRegistry.levels.count else { return nil }
        return LevelRegistry.levels[currentIndex]
    }

    /// True once the player has cleared every implemented level.
    var didFinishAllLevels: Bool {
        currentIndex >= LevelRegistry.levels.count
    }

    /// Called by a level's view when its hidden condition is satisfied.
    func solveCurrentLevel() {
        guard !didFinishAllLevels else { return }
        Haptics.success()
        withAnimation(.easeInOut(duration: 0.7)) {
            currentIndex += 1
        }
    }

    #if DEBUG
    /// Developer-only escape hatch while tuning hidden interactions.
    func resetProgress() {
        withAnimation(.easeInOut(duration: 0.35)) {
            currentIndex = 0
        }
    }
    #endif
}
