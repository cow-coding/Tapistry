import SwiftUI

struct MenuBarContentView: View {
    @ObservedObject var appState: AppState

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // Header
            HStack {
                Image(systemName: "keyboard")
                Text("TypeCollect")
                    .font(.headline)
            }
            .padding(.horizontal, 16)
            .padding(.top, 12)
            .padding(.bottom, 8)

            Divider()

            // Stats
            VStack(alignment: .leading, spacing: 6) {
                if appState.isMonitoring {
                    HStack {
                        Text("Keystrokes")
                            .foregroundColor(.secondary)
                        Spacer()
                        Text("\(appState.keystrokeCount)")
                            .font(.system(.body, design: .monospaced))
                            .fontWeight(.medium)
                    }

                    HStack {
                        Text("Collected")
                            .foregroundColor(.secondary)
                        Spacer()
                        Text("\(appState.collection.count) / \(KeycapCatalog.all.count)")
                            .font(.system(.body, design: .monospaced))
                            .fontWeight(.medium)
                    }
                } else {
                    VStack(spacing: 8) {
                        Text("Input Monitoring permission required")
                            .font(.caption)
                            .foregroundColor(.secondary)
                            .multilineTextAlignment(.center)
                        Button("Open Settings") {
                            appState.permissionManager.openInputMonitoringSettings()
                        }
                        .buttonStyle(.borderedProminent)
                        .controlSize(.small)
                    }
                    .frame(maxWidth: .infinity)
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 10)

            // Recent Drops
            if !appState.recentDrops.isEmpty {
                Divider()

                VStack(alignment: .leading, spacing: 4) {
                    Text("Recent Drops")
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .padding(.bottom, 2)

                    ForEach(appState.recentDrops.prefix(5)) { drop in
                        HStack(spacing: 8) {
                            Circle()
                                .fill(drop.keycap.rarity.color)
                                .frame(width: 8, height: 8)
                            Text(drop.keycap.name)
                                .font(.system(size: 12))
                            Spacer()
                            Text(drop.keycap.rarity.displayName)
                                .font(.system(size: 10))
                                .foregroundColor(drop.keycap.rarity.color)
                        }
                    }
                }
                .padding(.horizontal, 16)
                .padding(.vertical, 10)
            }

            Divider()

            // Footer
            Button(action: {
                NSApplication.shared.terminate(nil)
            }) {
                HStack {
                    Image(systemName: "power")
                    Text("Quit TypeCollect")
                }
            }
            .buttonStyle(.plain)
            .padding(.horizontal, 16)
            .padding(.vertical, 10)
        }
        .frame(width: 280)
    }
}
