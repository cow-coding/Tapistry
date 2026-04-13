import Foundation

struct KeycapCatalog {
    static let all: [Keycap] = [
        // MARK: - Common (12)
        Keycap(id: "mech-cherry-red-c01", name: "Cherry Red", rarity: .common, legendCharacter: "A", primaryColor: "#CC3333", setName: "Mechanical Classics"),
        Keycap(id: "mech-cherry-blue-c02", name: "Cherry Blue", rarity: .common, legendCharacter: "S", primaryColor: "#3366CC", setName: "Mechanical Classics"),
        Keycap(id: "mech-cherry-brown-c03", name: "Cherry Brown", rarity: .common, legendCharacter: "D", primaryColor: "#8B6914", setName: "Mechanical Classics"),
        Keycap(id: "mech-cherry-black-c04", name: "Cherry Black", rarity: .common, legendCharacter: "F", primaryColor: "#2D2D2D", setName: "Mechanical Classics"),
        Keycap(id: "retro-beige-c05", name: "IBM Beige", rarity: .common, legendCharacter: "G", primaryColor: "#D4C5A9", setName: "Retro Computing"),
        Keycap(id: "retro-gray-c06", name: "Terminal Gray", rarity: .common, legendCharacter: "H", primaryColor: "#808080", setName: "Retro Computing"),
        Keycap(id: "retro-cream-c07", name: "Apple Cream", rarity: .common, legendCharacter: "J", primaryColor: "#FFFDD0", setName: "Retro Computing"),
        Keycap(id: "nature-leaf-c08", name: "Forest Leaf", rarity: .common, legendCharacter: "K", primaryColor: "#228B22", setName: "Nature Elements"),
        Keycap(id: "nature-stone-c09", name: "River Stone", rarity: .common, legendCharacter: "L", primaryColor: "#A0A0A0", setName: "Nature Elements"),
        Keycap(id: "nature-sand-c10", name: "Desert Sand", rarity: .common, legendCharacter: "Q", primaryColor: "#C2B280", setName: "Nature Elements"),
        Keycap(id: "space-dust-c11", name: "Star Dust", rarity: .common, legendCharacter: "W", primaryColor: "#B0C4DE", setName: "Space Theme"),
        Keycap(id: "space-iron-c12", name: "Meteor Iron", rarity: .common, legendCharacter: "E", primaryColor: "#4A4A4A", setName: "Space Theme"),

        // MARK: - Uncommon (8)
        Keycap(id: "mech-gateron-u01", name: "Gateron Yellow", rarity: .uncommon, legendCharacter: "R", primaryColor: "#FFD700", setName: "Mechanical Classics"),
        Keycap(id: "mech-kailh-u02", name: "Kailh Box White", rarity: .uncommon, legendCharacter: "T", primaryColor: "#F0F0F0", setName: "Mechanical Classics"),
        Keycap(id: "retro-c64-u03", name: "C64 Brown", rarity: .uncommon, legendCharacter: "Y", primaryColor: "#6B4226", setName: "Retro Computing"),
        Keycap(id: "retro-amiga-u04", name: "Amiga White", rarity: .uncommon, legendCharacter: "U", primaryColor: "#E8E8E8", setName: "Retro Computing"),
        Keycap(id: "nature-ocean-u05", name: "Deep Ocean", rarity: .uncommon, legendCharacter: "I", primaryColor: "#006994", setName: "Nature Elements"),
        Keycap(id: "nature-sunset-u06", name: "Sunset Glow", rarity: .uncommon, legendCharacter: "O", primaryColor: "#FF6347", setName: "Nature Elements"),
        Keycap(id: "space-mars-u07", name: "Mars Red", rarity: .uncommon, legendCharacter: "P", primaryColor: "#CD5C5C", setName: "Space Theme"),
        Keycap(id: "space-neptune-u08", name: "Neptune Blue", rarity: .uncommon, legendCharacter: "Z", primaryColor: "#4169E1", setName: "Space Theme"),

        // MARK: - Rare (5)
        Keycap(id: "mech-holypanda-r01", name: "Holy Panda", rarity: .rare, legendCharacter: "X", primaryColor: "#FF8C00", setName: "Mechanical Classics"),
        Keycap(id: "retro-model-m-r02", name: "Model M Buckling", rarity: .rare, legendCharacter: "C", primaryColor: "#D3D3D3", setName: "Retro Computing"),
        Keycap(id: "nature-aurora-r03", name: "Aurora Borealis", rarity: .rare, legendCharacter: "V", primaryColor: "#00FF7F", setName: "Nature Elements"),
        Keycap(id: "space-nebula-r04", name: "Nebula Pink", rarity: .rare, legendCharacter: "B", primaryColor: "#FF69B4", setName: "Space Theme"),
        Keycap(id: "artisan-sakura-r05", name: "Sakura Blossom", rarity: .rare, legendCharacter: "N", primaryColor: "#FFB7C5", setName: "Artisan Collection"),

        // MARK: - Epic (3)
        Keycap(id: "artisan-dragon-e01", name: "Dragon Scale", rarity: .epic, legendCharacter: "M", primaryColor: "#8B0000", setName: "Artisan Collection"),
        Keycap(id: "space-blackhole-e02", name: "Black Hole", rarity: .epic, legendCharacter: "Esc", primaryColor: "#0D0D0D", setName: "Space Theme"),
        Keycap(id: "artisan-crystal-e03", name: "Crystal Ice", rarity: .epic, legendCharacter: "Tab", primaryColor: "#B0E0E6", setName: "Artisan Collection"),

        // MARK: - Legendary (2)
        Keycap(id: "artisan-galaxy-l01", name: "Galaxy Resin", rarity: .legendary, legendCharacter: "Space", primaryColor: "#191970", setName: "Artisan Collection"),
        Keycap(id: "milestone-million-l02", name: "The Millionaire", rarity: .legendary, legendCharacter: "Enter", primaryColor: "#FFD700", setName: "Milestone Specials"),

        // MARK: - Eternal (1)
        Keycap(id: "eternal-prisma-et01", name: "Prismatic Core", rarity: .eternal, legendCharacter: "★", primaryColor: "#FF69B4", setName: "Eternal Collection"),
    ]

    static func keycaps(for rarity: Rarity) -> [Keycap] {
        all.filter { $0.rarity == rarity }
    }

    static func randomKeycap(for rarity: Rarity) -> Keycap? {
        keycaps(for: rarity).randomElement()
    }
}
