---
name: verify
description: Build, launch, and capture evidence from the Life in Numbers app (macOS + iOS Simulator) to verify changes at the UI surface.
---

# Verifying Life in Numbers

## Build

Always set `DEVELOPER_DIR` — the shell's default toolchain is CommandLineTools and lacks XCTest/simulators:

```bash
cd apps/life-in-numbers/LifeInNumbers
DEVELOPER_DIR=/Applications/Xcode.app/Contents/Developer \
  xcodebuild -project LifeInNumbers.xcodeproj -scheme LifeInNumbers \
  -destination 'platform=macOS,arch=arm64' -quiet build          # macOS
# or: -destination 'platform=iOS Simulator,name=iPhone 17'       # iOS sim
```

Kit tests: `cd apps/life-in-numbers/LifeMetricsKit && DEVELOPER_DIR=... swift test`

## Drive & capture — iOS Simulator (works without any TCC permissions)

macOS app driving is blocked: the terminal lacks Screen Recording and
Automation permissions (screencapture and System Events both fail).
The simulator needs neither:

```bash
UDID=$(xcrun simctl list devices available | grep "iPhone 17 (" | grep -oE '[A-F0-9-]{36}')
APP=$(ls -d ~/Library/Developer/Xcode/DerivedData/LifeInNumbers-*/Build/Products/Debug-iphonesimulator/LifeInNumbers.app)
xcrun simctl install $UDID "$APP"
xcrun simctl launch $UDID com.subbuiyer.LifeInNumbers
xcrun simctl io $UDID screenshot out.png
```

- Fresh onboarding: `xcrun simctl uninstall` then reinstall (defaults
  delete alone is not reliable).
- Launch-argument defaults reach `UserDefaults.standard` (argument
  domain), e.g. `-profile.hasOnboarded YES -profile.interest "Sports"`.
  Keys are in `AppModel.Keys`.
- No tap injection exists (`simctl` can't, idb/applesimutils not
  installed). To reach a specific tab, temporarily give MainView's
  TabView a selection binding seeded from a `-debug.initialTab
  "<AppSection rawValue>"` launch arg, rebuild, screenshot, then
  `git checkout` the file. Tab raw values: "Numbers", "Life in Months",
  "Milestones", "Reflection".

## Gotchas

- Reflection's LLM generation is unavailable in the simulator (MLX
  needs a real device) — the unsupported card is the expected state.
- Diary seeding happens on first visit to Life in Months and persists;
  uninstall to reset.
- Interactive-only flows (typing in the city field, flipping cards,
  recording voice notes) can't be driven headlessly today; verify those
  on macOS after granting the terminal Screen Recording + Accessibility,
  or note them as not exercised.
