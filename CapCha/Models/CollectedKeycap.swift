import Foundation

struct CollectedKeycap: Identifiable, Codable {
    let id: UUID
    let keycap: Keycap
    let collectedAt: Date
    let keystrokeNumber: Int
}
