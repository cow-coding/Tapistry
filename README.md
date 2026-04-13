# CapCha

A macOS menu bar app that collects virtual keycaps as you type.

[한국어](docs/README.ko.md)

## What is CapCha?

Just type as you normally do — coding, writing, chatting.
CapCha runs quietly in your menu bar and drops virtual keycap collectibles as you type.

- Runs silently in the background as a menu bar app
- **Never reads what you type** — only counts keystrokes
- 6-tier rarity system: Common → Uncommon → Rare → Epic → Legendary → Eternal
- 2,610 possible keycap combinations (87 keys × 5 sets × 6 rarities)
- Pity system guarantees drops — no endless drought
- Collection window to browse all your keycaps

## Installation

### 1. Download

Download the latest `CapCha-vX.X.X.dmg` from the [Releases](https://github.com/cow-coding/CapCha/releases) page.

### 2. Install

Open the DMG and drag **CapCha** to **Applications**.

### 3. First Launch — Gatekeeper Warning

Since CapCha is not signed with an Apple Developer ID, macOS will block it on first launch.

1. Open **CapCha** from Applications — macOS will show a warning dialog
2. Go to **System Settings → Privacy & Security**
3. Scroll down to the **Security** section
4. You'll see: *"CapCha" was blocked from use because it is not from an identified developer.*
5. Click **Open Anyway**
6. In the confirmation dialog, click **Open**

> You only need to do this once. After that, CapCha will open normally.

### 4. Grant Input Monitoring Permission

CapCha needs Input Monitoring permission to count your keystrokes.

1. On first launch, CapCha will request Input Monitoring access
2. If the system dialog appears, click **Open System Settings**
3. Go to **System Settings → Privacy & Security → Input Monitoring**
4. Find **CapCha** in the list and toggle it **ON**
5. You may need to restart CapCha after granting permission

### Updating to a New Version

When updating CapCha, the old entry may remain in Input Monitoring settings:

1. Go to **System Settings → Privacy & Security → Input Monitoring**
2. Remove the old **CapCha** entry (click **−** button)
3. Install the new version and grant permission again

> **Privacy**: CapCha uses `CGEvent tap` in listen-only mode. It only increments a counter on each key press — it never reads, stores, or transmits the content of your keystrokes.

## Usage

Once running, you'll see a keycap icon in your menu bar.

- **Click the icon** to see your keystroke count and recent drops
- **Keep typing** — keycaps drop with a base 0.25% chance per keystroke
- **Drop notification** — a popover appears below the menu bar icon when you get a new keycap
- **Open Collection** — browse all collected keycaps in a grid view
- **Settings** — toggle launch at login and drop notifications

### Rarity Tiers

| Rarity | Drop Weight | Visual Effect |
|--------|------------|---------------|
| Common | 59.4% | Plain |
| Uncommon | 25% | Green tint + subtle glow |
| Rare | 10% | Blue glow + thick outline |
| Epic | 4% | Purple glow + inner shine |
| Legendary | 1% | Gold glow + inner shine |
| Eternal | 0.6% | Animated rainbow glow |

### Pity System

No more endless droughts. Drop chance increases the longer you go without a drop:

| Keystrokes Since Last Drop | Drop Chance |
|---------------------------|-------------|
| 0 – 499 | 0.25% (base) |
| 500 – 999 | 0.25% → 0.5% (linear ramp) |
| 1,000 – 1,999 | 0.5% → 1.0% (linear ramp) |
| 2,000+ | **Guaranteed drop** |

New users get a guaranteed Common keycap within their first 100 keystrokes.

### Keycap Sets

| Set | Theme |
|-----|-------|
| Mechanical Classics | Cherry-inspired reds |
| Retro Computing | Vintage beige/brown |
| Artisan Collection | Deep purples |
| Nature Elements | Forest greens |
| Space Theme | Cosmic blues |

Each set contains all 87 TKL keys, and every key can appear in any rarity tier.
Duplicates stack with a count — trade them later!

## Tech Stack

- **Swift + SwiftUI** (macOS 13.0+)
- **CGEvent tap** (Listen-Only, tailAppend) for global keystroke counting
- **Combine** for reactive data flow
- **Canvas** for isometric keycap rendering
- **JSON** for local persistence (`~/Library/Application Support/CapCha/`)

## Build from Source

```bash
# Install xcodegen
brew install xcodegen

# Generate Xcode project
xcodegen generate

# Build
xcodebuild -project CapCha.xcodeproj -scheme CapCha -configuration Release build
```

## Documentation

- [DESIGN.md](./DESIGN.md) — Architecture design document (Korean)
- [docs/DESIGN.en.md](./docs/DESIGN.en.md) — Architecture design document (English)

## Privacy

CapCha uses macOS Input Monitoring permission to count keystrokes.
**We never read, store, or transmit what you type.** Only the keystroke count is tracked.

## License

TBD
