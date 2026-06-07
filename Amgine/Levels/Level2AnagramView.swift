import SwiftUI

/// Level 2 — the letters of "amgine" fall *upward* when the view appears (the phone
/// is still inverted from Level 1). Once the player flips the phone right-side-up and
/// taps the gravity button the letters fall back down, and the anagram puzzle begins.
struct Level2AnagramView: View {
    @Environment(GameViewModel.self) private var game

    private let tileLetters = ["a", "m", "g", "i", "n", "e"]
    private let target      = ["e", "n", "i", "g", "m", "a"]
    private let tileSize: CGFloat = 48
    private let gap: CGFloat = 10

    @State private var positions: [CGPoint] = Array(repeating: .zero, count: 6)
    @State private var dragStart: [CGPoint] = Array(repeating: .zero, count: 6)
    @State private var activeDrag: Int? = nil

    // slot → tile index, tile → slot index
    @State private var slotOccupant: [Int?] = Array(repeating: nil, count: 6)
    @State private var tileSlot: [Int?]     = Array(repeating: nil, count: 6)

    @State private var isReady   = false
    @State private var hasFallen = false   // true once letters have landed at the bottom
    @State private var hasSolved = false

    var body: some View {
        GeometryReader { geo in
            let w = geo.size.width
            let h = geo.size.height
            let slotsY = h * 0.30
            let tilesY = h * 0.74

            ZStack {
                Color.black.ignoresSafeArea()

                // Drop slots — always visible
                ForEach(0..<6, id: \.self) { i in
                    SlotBorder(isOccupied: slotOccupant[i] != nil,
                               isCorrect: isCorrectlyPlaced(tileInSlot: i))
                        .position(slotPos(i, w: w, y: slotsY))
                }

                // Letter tiles — only interactive after they've fallen down
                if isReady {
                    ForEach(0..<6, id: \.self) { i in
                        LetterTile(letter: tileLetters[i],
                                   isCorrect: isCorrectlyPlaced(tile: i))
                            .position(positions[i])
                            .zIndex(activeDrag == i ? 10 : 1)
                            .gesture(
                                hasFallen
                                ? DragGesture(minimumDistance: 1,
                                              coordinateSpace: .named("board"))
                                    .onChanged { val in
                                        if activeDrag != i {
                                            activeDrag = i
                                            dragStart[i] = positions[i]
                                            if let s = tileSlot[i] {
                                                slotOccupant[s] = nil
                                                tileSlot[i] = nil
                                            }
                                        }
                                        positions[i] = CGPoint(
                                            x: dragStart[i].x + val.translation.width,
                                            y: dragStart[i].y + val.translation.height
                                        )
                                    }
                                    .onEnded { _ in
                                        activeDrag = nil
                                        trySnap(tile: i, slotsY: slotsY,
                                                w: w, tilesY: tilesY)
                                    }
                                : nil
                            )
                    }
                }
            }
            .coordinateSpace(name: "board")
            .onAppear {
                guard !isReady else { return }
                // Start gathered at center — where "amgine" lived in Level 1
                positions = Array(repeating: CGPoint(x: w / 2, y: h * 0.38), count: 6)
                isReady = true

                if game.isGravityNormal {
                    // Gravity already flipped (e.g. replay) — fall straight down
                    fallDown(w: w, tilesY: tilesY)
                } else {
                    // Phone is still inverted — letters fall upward
                    fallUp(w: w, tilesY: h * 0.10)
                }
            }
            .onChange(of: game.isGravityNormal) { _, normal in
                guard normal, !hasFallen else { return }
                fallDown(w: w, tilesY: tilesY)
            }
        }
    }

    // MARK: - Fall animations

    private func fallUp(w: CGFloat, tilesY: CGFloat) {
        let x0 = rowStartX(w: w)
        for i in 0..<6 {
            withAnimation(
                .interpolatingSpring(stiffness: 75, damping: 10)
                .delay(Double(i) * 0.07 + 0.2)
            ) {
                positions[i] = CGPoint(x: x0 + CGFloat(i) * (tileSize + gap), y: tilesY)
            }
        }
    }

    private func fallDown(w: CGFloat, tilesY: CGFloat) {
        let x0 = rowStartX(w: w)
        for i in 0..<6 {
            withAnimation(
                .interpolatingSpring(stiffness: 75, damping: 10)
                .delay(Double(i) * 0.07 + 0.1)
            ) {
                positions[i] = CGPoint(x: x0 + CGFloat(i) * (tileSize + gap), y: tilesY)
            }
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.6 + 0.07 * 5) {
            hasFallen = true
        }
    }

    // MARK: - Helpers

    private func rowStartX(w: CGFloat) -> CGFloat {
        (w - CGFloat(6) * tileSize - CGFloat(5) * gap) / 2 + tileSize / 2
    }

    private func slotPos(_ i: Int, w: CGFloat, y: CGFloat) -> CGPoint {
        CGPoint(x: rowStartX(w: w) + CGFloat(i) * (tileSize + gap), y: y)
    }

    private func isCorrectlyPlaced(tile: Int) -> Bool {
        guard let s = tileSlot[tile] else { return false }
        return tileLetters[tile] == target[s]
    }

    private func isCorrectlyPlaced(tileInSlot slot: Int) -> Bool {
        guard let t = slotOccupant[slot] else { return false }
        return tileLetters[t] == target[slot]
    }

    private func trySnap(tile: Int, slotsY: CGFloat, w: CGFloat, tilesY: CGFloat) {
        let pos = positions[tile]
        let threshold = tileSize * 0.85

        var best: Int? = nil
        var bestDist = threshold
        for s in 0..<6 {
            let sp = slotPos(s, w: w, y: slotsY)
            let d = hypot(pos.x - sp.x, pos.y - sp.y)
            if d < bestDist { bestDist = d; best = s }
        }

        guard let snap = best else { return }

        if let prev = slotOccupant[snap], prev != tile {
            tileSlot[prev] = nil
            let x0 = rowStartX(w: w)
            withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
                positions[prev] = CGPoint(x: x0 + CGFloat(prev) * (tileSize + gap), y: tilesY)
            }
        }

        slotOccupant[snap] = tile
        tileSlot[tile] = snap
        withAnimation(.spring(response: 0.25, dampingFraction: 0.8)) {
            positions[tile] = slotPos(snap, w: w, y: slotsY)
        }
        checkSolved()
    }

    private func checkSolved() {
        guard !hasSolved else { return }
        let complete = slotOccupant.allSatisfy { $0 != nil }
        guard complete else { return }
        let correct = (0..<6).allSatisfy { s in
            guard let t = slotOccupant[s] else { return false }
            return tileLetters[t] == target[s]
        }
        guard correct else { return }
        hasSolved = true
        game.solveCurrentLevel()
    }
}

// MARK: - Sub-views

private struct SlotBorder: View {
    let isOccupied: Bool
    let isCorrect: Bool

    var body: some View {
        RoundedRectangle(cornerRadius: 4)
            .stroke(lineWidth: 0.5)
            .frame(width: 48, height: 48)
            .foregroundStyle(.white.opacity(isOccupied ? 0 : 0.25))
            .animation(.easeOut(duration: 0.15), value: isOccupied)
    }
}

private struct LetterTile: View {
    let letter: String
    let isCorrect: Bool

    var body: some View {
        Text(letter)
            .font(.system(size: 18, weight: .ultraLight, design: .serif))
            .foregroundStyle(.white.opacity(isCorrect ? 1.0 : 0.85))
            .frame(width: 48, height: 48)
            .background(
                RoundedRectangle(cornerRadius: 4)
                    .fill(.white.opacity(isCorrect ? 0.12 : 0.06))
                    .stroke(.white.opacity(isCorrect ? 0.65 : 0.35), lineWidth: 0.5)
            )
            .animation(.easeOut(duration: 0.2), value: isCorrect)
    }
}
