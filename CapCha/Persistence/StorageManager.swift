import Foundation

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

    func saveCollection(_ items: [CollectedKeycap]) {
        do {
            let data = try JSONEncoder().encode(items)
            try data.write(to: collectionURL, options: .atomic)
        } catch {
            print("[StorageManager] Save failed: \(error)")
        }
    }

    func loadCollection() -> [CollectedKeycap] {
        guard let data = try? Data(contentsOf: collectionURL) else { return [] }
        return (try? JSONDecoder().decode([CollectedKeycap].self, from: data)) ?? []
    }
}
