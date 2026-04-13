import SwiftUI

enum Rarity: String, Codable, CaseIterable, Comparable {
    case common
    case uncommon
    case rare
    case epic
    case legendary
    case eternal

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
        case .eternal: return "🌈"
        }
    }

    var color: Color {
        switch self {
        case .common: return Color("RarityCommon")
        case .uncommon: return Color("RarityUncommon")
        case .rare: return Color("RarityRare")
        case .epic: return Color("RarityEpic")
        case .legendary: return Color("RarityLegendary")
        case .eternal: return .white
        }
    }

    /// Rainbow colors for each character of "Eternal"
    static let rainbowColors: [Color] = [
        Color(red: 1.0, green: 0.2, blue: 0.2),   // E - Red
        Color(red: 1.0, green: 0.6, blue: 0.1),   // t - Orange
        Color(red: 1.0, green: 0.9, blue: 0.2),   // e - Yellow
        Color(red: 0.3, green: 0.85, blue: 0.3),  // r - Green
        Color(red: 0.3, green: 0.6, blue: 1.0),   // n - Blue
        Color(red: 0.4, green: 0.3, blue: 0.9),   // a - Indigo
        Color(red: 0.7, green: 0.3, blue: 0.9),   // l - Violet
    ]

    var isRainbow: Bool {
        self == .eternal
    }

    var dropWeight: Double {
        switch self {
        case .common: return 0.594
        case .uncommon: return 0.25
        case .rare: return 0.10
        case .epic: return 0.04
        case .legendary: return 0.01
        case .eternal: return 0.006
        }
    }

    static func < (lhs: Rarity, rhs: Rarity) -> Bool {
        let order: [Rarity] = [.common, .uncommon, .rare, .epic, .legendary, .eternal]
        return order.firstIndex(of: lhs)! < order.firstIndex(of: rhs)!
    }
}

/// Prismatic animated rainbow text for Eternal rarity
struct RainbowText: View {
    let text: String
    let font: Font

    init(_ text: String, font: Font = .system(size: 11, weight: .bold)) {
        self.text = text
        self.font = font
    }

    var body: some View {
        TimelineView(.animation) { timeline in
            let time = timeline.date.timeIntervalSinceReferenceDate
            let phase = time.truncatingRemainder(dividingBy: 3.0) / 3.0

            HStack(spacing: 0) {
                ForEach(Array(text.enumerated()), id: \.offset) { index, char in
                    let hue = (phase + Double(index) / Double(text.count))
                        .truncatingRemainder(dividingBy: 1.0)
                    Text(String(char))
                        .font(font)
                        .fontWeight(.heavy)
                        .foregroundStyle(
                            Color(hue: hue, saturation: 0.75, brightness: 1.0)
                        )
                }
            }
        }
    }
}
