# Amgine

A minimalist iOS puzzle game. Each level is a hidden interaction you must
discover through wit and intuition — there are no instructions. ("Amgine" is
"Enigma" reversed; the reversal motif runs through the game, starting with
Level 1.)

## Requirements

- Xcode 26+
- iOS 26+ (deployment target)
- Swift 6

## Run

```sh
open Amgine.xcodeproj
```

Then select an iPhone simulator (or a device) and press Run (⌘R).

> Level 1 relies on the physical motion of the device. The iOS Simulator does
> not report real accelerometer data, so to actually *solve* Level 1 you need a
> real iPhone. On the simulator you can still launch and see the screen.

### Command-line build check

```sh
xcodebuild -project Amgine.xcodeproj -scheme Amgine \
  -destination 'generic/platform=iOS Simulator' build
```

## Architecture

```
Amgine/
  AmgineApp.swift          @main entry point
  Game/
    GameViewModel.swift    Observable game state; advances levels on solve
    Level.swift            Level model
    LevelRegistry.swift    Ordered list of levels — add new levels here
  Levels/
    Level1FlipView.swift   Level 1: turn the phone upside down
  Core/
    MotionManager.swift    CoreMotion (gravity vector) wrapper
    Haptics.swift          Success / tick feedback
  Views/
    GameContainerView.swift Hosts the current level and handles transitions
```

### Adding a level

1. Create a `LevelNView.swift` in `Levels/`. It reads the game state from the
   environment and calls `game.solveCurrentLevel()` when solved.
2. Append it to the array in `LevelRegistry.swift`.

That's it — the container and progression handle the rest.
