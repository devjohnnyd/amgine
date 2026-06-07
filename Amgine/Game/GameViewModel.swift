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

    private(set) var isDarkMode: Bool = true

    /// True once the sun/moon toggle is unlocked (after Level 2 is solved).
    var darkModeUnlocked: Bool {
        currentIndex >= 2
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

    var didFinishAllLevels: Bool {
        currentIndex >= LevelRegistry.levels.count
    }

    func solveCurrentLevel() {
        guard !didFinishAllLevels else { return }
        Haptics.success()
        withAnimation(.easeInOut(duration: 0.7)) {
            currentIndex += 1
        }
    }

    func toggleDarkMode() {
        withAnimation(.easeInOut(duration: 0.4)) {
            isDarkMode.toggle()
        }
    }

    #if DEBUG
    func resetProgress() {
        isDarkMode = true
        withAnimation(.easeInOut(duration: 0.35)) {
            currentIndex = 0
        }
    }
    #endif
}
