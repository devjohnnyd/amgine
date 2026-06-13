import SwiftUI

@MainActor
@Observable
final class GameViewModel {
    private(set) var currentIndex = 0
    private(set) var gravityButtonVisible = false
    private(set) var darkModeButtonVisible = false
    private(set) var isDarkMode: Bool = true
    private(set) var isGravityNormal: Bool = false

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

    func revealGravityButton() {
        guard !gravityButtonVisible else { return }
        Haptics.tick()
        withAnimation(.easeInOut(duration: 0.35)) {
            gravityButtonVisible = true
        }
    }

    func revealDarkModeButton() {
        guard !darkModeButtonVisible else { return }
        Haptics.tick()
        withAnimation(.easeInOut(duration: 0.35)) {
            darkModeButtonVisible = true
        }
    }

    func toggleDarkMode() {
        guard darkModeButtonVisible else { return }
        withAnimation(.easeInOut(duration: 0.4)) {
            isDarkMode.toggle()
        }
    }

    func flipGravity() {
        guard gravityButtonVisible else { return }
        Haptics.success()
        withAnimation(.spring(response: 0.5, dampingFraction: 0.7)) {
            isGravityNormal.toggle()
        }
    }

    func resetProgress() {
        gravityButtonVisible = false
        darkModeButtonVisible = false
        isDarkMode = true
        isGravityNormal = false
        withAnimation(.easeInOut(duration: 0.35)) {
            currentIndex = 0
        }
    }
}
