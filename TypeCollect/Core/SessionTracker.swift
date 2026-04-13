import Foundation
import Combine

final class SessionTracker: ObservableObject {
    private var cancellables = Set<AnyCancellable>()
    private var lastCheckedCount: Int = 0

    private let keystrokeMonitor: KeystrokeMonitor
    private let onDrop: (Keycap, Int) -> Void

    init(keystrokeMonitor: KeystrokeMonitor, onDrop: @escaping (Keycap, Int) -> Void) {
        self.keystrokeMonitor = keystrokeMonitor
        self.onDrop = onDrop

        keystrokeMonitor.$totalCount
            .receive(on: DispatchQueue.main)
            .sink { [weak self] count in
                self?.evaluateBatch(currentCount: count)
            }
            .store(in: &cancellables)
    }

    private func evaluateBatch(currentCount: Int) {
        let batchSize = DropEngine.batchSize
        while currentCount - lastCheckedCount >= batchSize {
            lastCheckedCount += batchSize
            if let keycap = DropEngine.executeDrop() {
                onDrop(keycap, lastCheckedCount)
            }
        }
    }
}
