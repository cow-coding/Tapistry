import Foundation
import Combine

final class AppState: ObservableObject {
    let permissionManager = PermissionManager()
    let keystrokeMonitor = KeystrokeMonitor()

    @Published var collection: [CollectedKeycap] = []
    @Published var recentDrops: [CollectedKeycap] = []
    @Published var isMonitoring: Bool = false
    @Published var keystrokeCount: Int = 0

    private var sessionTracker: SessionTracker?
    private var reEnableTimer: Timer?
    private var permissionPollTimer: Timer?
    private var saveTimer: Timer?
    private var cancellables = Set<AnyCancellable>()

    init() {
        // Restore persisted data
        collection = StorageManager.shared.loadCollection()
        recentDrops = Array(collection.suffix(6).reversed())

        let stats = StorageManager.shared.loadStats()
        keystrokeMonitor.totalCount = stats.totalKeystrokes

        // Forward keystroke count changes to AppState for SwiftUI binding
        keystrokeMonitor.$totalCount
            .receive(on: DispatchQueue.main)
            .assign(to: &$keystrokeCount)

        tryStartMonitoring()

        // Auto-save stats every 60 seconds
        saveTimer = Timer.scheduledTimer(withTimeInterval: 60, repeats: true) { [weak self] _ in
            self?.saveStats()
        }
    }

    func tryStartMonitoring() {
        guard sessionTracker == nil else { return }

        keystrokeMonitor.start()

        if keystrokeMonitor.isRunning {
            isMonitoring = true
            print("[AppState] Monitoring started.")

            sessionTracker = SessionTracker(keystrokeMonitor: keystrokeMonitor) { [weak self] keycap, keystrokeNumber in
                self?.handleDrop(keycap: keycap, keystrokeNumber: keystrokeNumber)
            }
            reEnableTimer = Timer.scheduledTimer(withTimeInterval: 30, repeats: true) { [weak self] _ in
                self?.keystrokeMonitor.reEnableIfNeeded()
            }
        } else {
            isMonitoring = false
            print("[AppState] No permission. Polling...")
            startPermissionPolling()
        }
    }

    private func startPermissionPolling() {
        permissionPollTimer?.invalidate()
        permissionPollTimer = Timer.scheduledTimer(withTimeInterval: 2, repeats: true) { [weak self] timer in
            guard let self = self else { timer.invalidate(); return }
            self.keystrokeMonitor.start()
            if self.keystrokeMonitor.isRunning {
                timer.invalidate()
                self.permissionPollTimer = nil
                self.isMonitoring = true
                print("[AppState] Permission granted. Monitoring started.")

                self.sessionTracker = SessionTracker(keystrokeMonitor: self.keystrokeMonitor) { [weak self] keycap, keystrokeNumber in
                    self?.handleDrop(keycap: keycap, keystrokeNumber: keystrokeNumber)
                }
                self.reEnableTimer = Timer.scheduledTimer(withTimeInterval: 30, repeats: true) { [weak self] _ in
                    self?.keystrokeMonitor.reEnableIfNeeded()
                }
            }
        }
    }

    private func handleDrop(keycap: Keycap, keystrokeNumber: Int) {
        print("[AppState] DROP! \(keycap.name) (\(keycap.rarity.displayName)) at keystroke #\(keystrokeNumber)")
        let collected = CollectedKeycap(
            id: UUID(),
            keycap: keycap,
            collectedAt: Date(),
            keystrokeNumber: keystrokeNumber
        )

        collection.append(collected)
        recentDrops.insert(collected, at: 0)
        if recentDrops.count > 6 {
            recentDrops = Array(recentDrops.prefix(6))
        }

        StorageManager.shared.saveCollection(collection)
        saveStats()
        DropNotificationManager.shared.show(keycap: keycap)
    }

    private func saveStats() {
        let stats = UserStats(totalKeystrokes: keystrokeMonitor.totalCount)
        StorageManager.shared.saveStats(stats)
    }

    func saveOnExit() {
        StorageManager.shared.saveCollection(collection)
        saveStats()
        keystrokeMonitor.stop()
    }
}
