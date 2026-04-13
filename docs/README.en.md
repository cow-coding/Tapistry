# TypeCollect
A macOS menu bar app that collects virtual keycaps as you type

## Concept
- A menu bar app that runs quietly in the background
- Never collects keystroke content (only counts)
- 5-tier rarity system from Common to Legendary
- Pity system guaranteeing confirmed drops (planned)
- Combo, daily streak, and milestone bonuses (planned)

## Tech Stack
- Swift + SwiftUI (macOS 13.0+)
- CGEvent tap (Listen-Only) for global keystroke counting
- Combine for reactive data flow
- JSON for local persistence

## Features (MVP)
- [x] Architecture design
- [x] Menubar app with NSStatusItem
- [x] Global keystroke monitoring
- [x] Gacha drop system (per-keystroke, 0.6% chance)
- [x] 30 keycap catalog (5 rarity tiers)
- [x] Drop notification popover anchored to menu bar icon
- [x] Local JSON persistence
- [ ] Collection view window
- [ ] Pity system
- [ ] Bonus multipliers

## Privacy
Uses macOS Input Monitoring permission to count keystrokes. Never reads, stores, or transmits what you type. Only the keystroke count is tracked.
