import SwiftUI

@MainActor
@Observable
final class GameViewModel {
    private static let progressKey   = "amgine.currentLevelIndex"
    private static let schemaKey     = "amgine.levelSchemaVersion"
    private static let schemaVersion = 5   // bump whenever the level list changes

    private let defaults: UserDefaults

    private(set) var currentIndex: Int {
        didSet {
            defaults.set(currentIndex, forKey: Self.progressKey)
        }
    }

    private(set) var isDarkMode: Bool = true
    private(set) var isGravityNormal: Bool = false

    /// True once the gravity toggle is unlocked (after Level 1 is solved).
    var gravityUnlocked: Bool { currentIndex >= 1 }

    /// True once the sun/moon toggle is unlocked (after Level 2 is solved).
    var darkModeUnlocked: Bool { currentIndex >= 2 }

    init(defaults: UserDefaults = .standard) {
        self.defaults = defaults
        if defaults.integer(forKey: Self.schemaKey) != Self.schemaVersion {
            defaults.set(0, forKey: Self.progressKey)
            defaults.set(Self.schemaVersion, forKey: Self.schemaKey)
        }
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

    func flipGravity() {
        Haptics.success()
        withAnimation(.spring(response: 0.5, dampingFraction: 0.7)) {
            isGravityNormal.toggle()
        }
    }

    #if DEBUG
    func resetProgress() {
        isDarkMode = true
        isGravityNormal = false
        withAnimation(.easeInOut(duration: 0.35)) {
            currentIndex = 0
        }
    }
    #endif
}
