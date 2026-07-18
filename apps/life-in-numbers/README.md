# Life in Numbers

<p align="center">
  <img src="docs/hero.gif" alt="Watercolor dog in a beret watching an hourglass" width="340">
</p>

Your whole story, counted. Enter your birth date and watch your life quantified in
real time — heartbeats, breaths, full moons, kilometers traveled around the Sun,
and a "life in weeks" grid where every box is one week of an expected lifespan.

A native **macOS + iPhone** app built from a single SwiftUI codebase.

## Features

- **Numbers dashboard** — 13 live-updating statistics (days, weeks, hours, seconds,
  heartbeats, breaths, sleep, blinks, full moons, distance through space, trips
  around the Sun, life progress), ticking once per second via `TimelineView`.
  **Tap any card to flip it** and see your number against a real-world quantity
  ("about 4× the 384,400 km from Earth to the Moon") — comparisons come from a
  curated, sourced fact bank (NASA, World Bank, UN, US Census…) with
  closest-magnitude retrieval, and the multiplier is computed, never generated.
  On Apple silicon, the on-device model can optionally rephrase the retrieved
  fact — it is instructed to use only the numbers it is handed.
- **Life in Months** — a Canvas-drawn grid with one box per month, 12 to a row
  so every row is a year of life: terracotta for months lived, dusty blue for
  the current month, sage with an icon where a memory lives. **Tap any month to
  keep a memory there** — the grid is a personal diary. It pre-seeds movable,
  approximate milestones (born, first steps, started school, first crush,
  finished school, first job), and the editor needs no typing at all: pick an
  icon, tap a suggestion like "Started school" or "A big trip", done. A
  chronological memories list below the grid mirrors everything accessibly.
- **Milestones** — upcoming round numbers worth celebrating: your 15,000th day,
  week 2,000, 2 billion seconds, the next trip around the Sun, the halfway point.
- **Settings** — adjust birth date and life expectancy (40–120 years); everything
  recomputes instantly.
- **Reflection** — a short essay about *your* numbers, written by an open-source
  LLM (Qwen 2.5, 4-bit) running **fully on-device** via
  [MLX](https://github.com/ml-explore/mlx). The weights (~300 MB) download once
  from the Hugging Face hub on first use and are cached; after that it works
  offline. No server, no API key — your birth date never leaves the device.

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
│   │   ├── MetricFormatter  # "2.1 billion"-style compact formatting
│   │   └── ReflectionPrompt # LLM prompt built from the metrics (pure, tested)
│   └── Tests/               # XCTest suite for every calculation
└── LifeInNumbers/           # SwiftUI multiplatform app (the face)
    ├── LifeInNumbers.xcodeproj  # Single target: iOS 17+ & macOS 14+
    └── LifeInNumbers/
        ├── Models/          # Observable app state, UserDefaults persistence
        ├── Services/        # ReflectionEngine: on-device LLM via MLX
        ├── Views/           # Onboarding, Dashboard, LifeGrid, Milestones,
        │                    #   Reflection, Settings
        └── Theme/           # Watercolor palette + paper-card styling
```

All date math and physiological estimates live in `LifeMetricsKit`, which takes an
explicit `asOf: Date` and `Calendar` everywhere, so every number is deterministic
and unit-tested. The app layer is purely presentational. The only dependency is
[`mlx-swift-lm`](https://github.com/ml-explore/mlx-swift-lm)
(`MLXLLM` / `MLXLMCommon`), which powers the on-device Reflection feature.

## Running

1. Open `LifeInNumbers/LifeInNumbers.xcodeproj` in Xcode 16 or later.
2. Pick a destination — **My Mac** or an iPhone (simulator works for everything
   except Reflection, which needs real Apple-silicon hardware).
3. Run (⌘R). Tests: ⌘U (runs the `LifeMetricsKit` suite).

No signing requirements beyond automatic signing. The Reflection model can be
swapped in Settings for any MLX-format chat model on the Hugging Face hub
(e.g. a larger Qwen, Llama, or Gemma variant).

## Artwork

The app's visuals are Midjourney-generated watercolors in the style of a
hand-painted Parisian sketch, wired into each tab:

| Onboarding | Life in Weeks | Milestones | Reflection | Icon |
|---|---|---|---|---|
| <img src="docs/art/hourglass-puppy.png" width="140"> | <img src="docs/art/book-grid-dog-crop.png" width="160"> | <img src="docs/art/milestone-cake-crop.png" width="160"> | <img src="docs/art/rooftop-boxer-crop.png" width="120"> | <img src="LifeInNumbers/LifeInNumbers/Assets.xcassets/AppIcon.appiconset/AppIcon-mac-256.png" width="90"> |

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
