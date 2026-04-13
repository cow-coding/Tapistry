import SwiftUI

enum Rarity: String, Codable, CaseIterable, Comparable {
    case common
    case uncommon
    case rare
    case epic
    case legendary

    var displayName: String {
        rawValue.capitalized
    }

    var emoji: String {
        switch self {
        case .common: return "⚪"
        case .uncommon: return "🟢"
        case .rare: return "🔵"
        case .epic: return "🟣"
        case .legendary: return "🟠"
        }
    }

    var color: Color {
        switch self {
        case .common: return .gray
        case .uncommon: return .green
        case .rare: return .blue
        case .epic: return .purple
        case .legendary: return .orange
        }
    }

    var dropWeight: Double {
        switch self {
        case .common: return 0.60
        case .uncommon: return 0.25
        case .rare: return 0.10
        case .epic: return 0.04
        case .legendary: return 0.01
        }
    }

    static func < (lhs: Rarity, rhs: Rarity) -> Bool {
        let order: [Rarity] = [.common, .uncommon, .rare, .epic, .legendary]
        return order.firstIndex(of: lhs)! < order.firstIndex(of: rhs)!
    }
}
