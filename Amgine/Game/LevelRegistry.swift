import Foundation

/// The ordered list of levels. To add a level, append it here.
@MainActor
enum LevelRegistry {
    static let levels: [Level] = [
        Level(id: 1, title: "Level 1") { Level1FlipView() },
    ]
}
