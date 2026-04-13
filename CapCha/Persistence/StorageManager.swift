import Foundation

struct UserStats: Codable {
    var totalKeystrokes: Int = 0
}

final class StorageManager {
    static let shared = StorageManager()

    private let fileManager = FileManager.default
    private let directory: URL

    private init() {
        let appSupport = fileManager.urls(for: .applicationSupportDirectory, in: .userDomainMask).first!
        directory = appSupport.appendingPathComponent("CapCha", isDirectory: true)
        try? fileManager.createDirectory(at: directory, withIntermediateDirectories: true)
    }

    private var collectionURL: URL {
        directory.appendingPathComponent("collection.json")
    }

    private var statsURL: URL {
        directory.appendingPathComponent("stats.json")
    }

    // MARK: - Collection

    func saveCollection(_ items: [CollectedKeycap]) {
        do {
            let data = try JSONEncoder().encode(items)
            try data.write(to: collectionURL, options: .atomic)
        } catch {
            print("[StorageManager] Save collection failed: \(error)")
        }
    }

    func loadCollection() -> [CollectedKeycap] {
        guard let data = try? Data(contentsOf: collectionURL) else { return [] }
        return (try? JSONDecoder().decode([CollectedKeycap].self, from: data)) ?? []
    }

    // MARK: - Stats

    func saveStats(_ stats: UserStats) {
        do {
            let data = try JSONEncoder().encode(stats)
            try data.write(to: statsURL, options: .atomic)
        } catch {
            print("[StorageManager] Save stats failed: \(error)")
        }
    }

    func loadStats() -> UserStats {
        guard let data = try? Data(contentsOf: statsURL) else { return UserStats() }
        return (try? JSONDecoder().decode(UserStats.self, from: data)) ?? UserStats()
    }
}
