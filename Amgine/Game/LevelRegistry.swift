import Foundation

/// The ordered list of levels. To add a level, append it here.
@MainActor
enum LevelRegistry {
    static let levels: [Level] = [
        Level(id: 1, title: "Level 1") { Level1FlipView() },
        Level(id: 2, title: "Level 2") { Level2StillView() },
        Level(id: 3, title: "Level 3") { Level3FlatView() },
    ]
}
