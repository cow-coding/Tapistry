import Foundation
import CoreGraphics
import AppKit

final class PermissionManager: ObservableObject {
    @Published var hasPermission: Bool = false

    init() {
        checkPermission()
    }

    func checkPermission() {
        // CGPreflightListenEventAccess는 개발 중 신뢰할 수 없으므로
        // 실제로 event tap 생성을 시도하여 권한 확인
        let eventMask: CGEventMask = (1 << CGEventType.keyDown.rawValue)
        if let tap = CGEvent.tapCreate(
            tap: .cgSessionEventTap,
            place: .headInsertEventTap,
            options: .listenOnly,
            eventsOfInterest: eventMask,
            callback: { _, _, event, _ in Unmanaged.passUnretained(event) },
            userInfo: nil
        ) {
            // 생성 성공 → 권한 있음, 바로 정리
            CGEvent.tapEnable(tap: tap, enable: false)
            hasPermission = true
        } else {
            hasPermission = false
        }
    }

    func requestPermission() {
        _ = CGRequestListenEventAccess()
        checkPermission()

        if !hasPermission {
            openInputMonitoringSettings()
        }
    }

    func openInputMonitoringSettings() {
        if let url = URL(string: "x-apple.systempreferences:com.apple.preference.security?Privacy_ListenEvent") {
            NSWorkspace.shared.open(url)
        }
    }
}
