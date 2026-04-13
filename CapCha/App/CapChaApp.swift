import SwiftUI

@main
struct CapChaApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    var body: some Scene {
        Settings {
            EmptyView()
        }
    }
}

final class AppDelegate: NSObject, NSApplicationDelegate {
    private var statusItem: NSStatusItem!
    private var popover: NSPopover!
    private var appState: AppState!

    func applicationDidFinishLaunching(_ notification: Notification) {
        appState = AppState()

        // Create menu bar icon
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        if let button = statusItem.button {
            let icon = NSImage(named: "MenuBarIcon")
            icon?.isTemplate = true
            icon?.size = NSSize(width: 22, height: 22)
            button.image = icon
            button.action = #selector(togglePopover)
            button.target = self
        }

        // Main popover
        popover = NSPopover()
        popover.contentSize = NSSize(width: 280, height: 300)
        popover.behavior = .transient
        popover.contentViewController = NSHostingController(rootView: MenuBarContentView(appState: appState))

        // Pass status item button to drop notification manager
        DropNotificationManager.shared.anchorButton = statusItem.button
    }

    @objc private func togglePopover() {
        guard let button = statusItem.button else { return }
        if popover.isShown {
            popover.performClose(nil)
        } else {
            popover.show(relativeTo: button.bounds, of: button, preferredEdge: .minY)
        }
    }

    func applicationWillTerminate(_ notification: Notification) {
        appState.saveOnExit()
    }
}
