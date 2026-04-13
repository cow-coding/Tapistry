import Foundation

struct Keycap: Identifiable, Codable, Hashable {
    let id: String
    let name: String
    let rarity: Rarity
    let legendCharacter: String
    let primaryColor: String  // Hex
    let setName: String
}
