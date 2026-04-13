import Foundation

struct DropEngine {
    /// 매 `batchSize`키마다 드롭 판정
    static let batchSize: Int = 50

    /// 배치당 드롭 확률
    static let dropChance: Double = 0.30

    /// 드롭 여부 판정
    static func shouldDrop() -> Bool {
        Double.random(in: 0..<1) < dropChance
    }

    /// 등급 결정 (가중 랜덤)
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

    /// 드롭 실행: 등급 결정 → 해당 등급에서 랜덤 키캡 선택
    static func executeDrop() -> Keycap? {
        guard shouldDrop() else { return nil }
        let rarity = rollRarity()
        return KeycapCatalog.randomKeycap(for: rarity)
    }
}
