# Life in Numbers

Your whole story, counted. Enter your birth date and watch your life quantified in
real time — heartbeats, breaths, full moons, kilometers traveled around the Sun,
and a "life in weeks" grid where every box is one week of an expected lifespan.

A native **macOS + iPhone** app built from a single SwiftUI codebase.

## Features

- **Numbers dashboard** — 13 live-updating statistics (days, weeks, hours, seconds,
  heartbeats, breaths, sleep, blinks, full moons, distance through space, trips
  around the Sun, life progress), ticking once per second via `TimelineView`.
- **Life in Weeks** — a Canvas-drawn grid of ~4,160 boxes (52 weeks × expected
  years): terracotta for weeks lived, dusty blue for the current week, faded for
  the weeks ahead.
- **Milestones** — upcoming round numbers worth celebrating: your 15,000th day,
  week 2,000, 2 billion seconds, the next trip around the Sun, the halfway point.
- **Settings** — adjust birth date and life expectancy (40–120 years); everything
  recomputes instantly.

## Design

The visual language is borrowed from a watercolor sketch: warm paper backgrounds,
ink-dark serif type, and three muted pigments — terracotta, dusty blue, and sage —
cycled across cards. Light and dark appearance are both supported.

## Architecture

```
life-in-numbers/
├── LifeMetricsKit/          # Platform-agnostic Swift package (the brains)
│   ├── Sources/
│   │   ├── LifeProfile      # User input: birth date + life expectancy
│   │   ├── LifeCalculator   # All statistics, deterministic & documented rates
│   │   ├── WeeksGrid        # Life-in-weeks grid math
│   │   ├── MilestoneGenerator # Upcoming round-number milestones
│   │   └── MetricFormatter  # "2.1 billion"-style compact formatting
│   └── Tests/               # XCTest suite for every calculation
└── LifeInNumbers/           # SwiftUI multiplatform app (the face)
    ├── LifeInNumbers.xcodeproj  # Single target: iOS 17+ & macOS 14+
    └── LifeInNumbers/
        ├── Models/          # Observable app state, UserDefaults persistence
        ├── Views/           # Onboarding, Dashboard, LifeGrid, Milestones, Settings
        └── Theme/           # Watercolor palette + paper-card styling
```

All date math and physiological estimates live in `LifeMetricsKit`, which takes an
explicit `asOf: Date` and `Calendar` everywhere, so every number is deterministic
and unit-tested. The app layer is purely presentational.

## Running

1. Open `LifeInNumbers/LifeInNumbers.xcodeproj` in Xcode 16 or later.
2. Pick a destination — **My Mac**, an iPhone simulator, or a device.
3. Run (⌘R). Tests: ⌘U (runs the `LifeMetricsKit` suite).

No dependencies, no signing requirements beyond automatic signing.

## Estimation rates

| Metric | Rate |
|--------|------|
| Heartbeats | 70 beats / minute |
| Breaths | 14 / minute |
| Sleep | 8 hours / day |
| Blinks | 15 / waking minute |
| Full moons | one per 29.53 days |
| Distance around the Sun | 940 million km / year |

These are population averages — perspective, not medical data.
