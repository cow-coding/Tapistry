import Foundation

struct DropEngine {
    /// Drop chance per keystroke (0.25% ≈ ~12-20 drops/day at 5,000-8,000 keystrokes)
    static let dropChance: Double = 0.0025

    /// Determine whether a drop occurs
    static func shouldDrop() -> Bool {
        Double.random(in: 0..<1) < dropChance
    }

    /// Determine rarity via weighted random
    static func rollRarity() -> Rarity {
        let roll = Double.random(in: 0..<1)
        var cumulative = 0.0
        for rarity in Rarity.allCases {
            cumulative += rarity.dropWeight
            if roll < cumulative {
                return rarity
            }
        }
        return .common
    }

    /// Execute drop: roll drop chance → determine rarity → pick random keycap
    static func executeDrop() -> Keycap? {
        guard shouldDrop() else { return nil }
        let rarity = rollRarity()
        return KeycapCatalog.randomKeycap(for: rarity)
    }
}
