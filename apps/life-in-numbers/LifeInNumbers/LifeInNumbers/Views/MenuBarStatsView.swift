#if os(macOS)
import SwiftUI
import LifeMetricsKit

/// The menu-bar popover: a handful of live numbers, always one click away.
struct MenuBarStatsView: View {
    @Environment(AppModel.self) private var model

    var body: some View {
        TimelineView(.periodic(from: .now, by: 1)) { context in
            let profile = model.profile
            let calc = model.calculator
            VStack(alignment: .leading, spacing: 10) {
                Text("Life in Numbers")
                    .font(AppFont.serif(.headline, .semibold))
                    .foregroundStyle(Theme.ink)

                statRow("sun.max", "\(calc.daysLived(for: profile, asOf: context.date).formatted()) days lived")
                statRow("heart", "\(MetricFormatter.compact(calc.heartbeats(for: profile, asOf: context.date))) heartbeats")
                statRow("stopwatch", "\(MetricFormatter.compact(calc.secondsLived(for: profile, asOf: context.date).rounded(.down))) seconds")

                let progress = calc.lifeProgress(for: profile, asOf: context.date)
                VStack(alignment: .leading, spacing: 3) {
                    ProgressView(value: progress)
                        .tint(Theme.dustyBlue)
                    Text("\(String(format: "%.1f", progress * 100))% of a \(profile.lifeExpectancyYears)-year life")
                        .font(AppFont.serif(.caption))
                        .foregroundStyle(Theme.inkSecondary)
                }
            }
            .padding(14)
            .frame(width: 250)
            .background(Theme.paper)
        }
    }

    private func statRow(_ symbol: String, _ text: String) -> some View {
        HStack(spacing: 8) {
            Image(systemName: symbol)
                .foregroundStyle(Theme.dustyBlue)
                .frame(width: 18)
            Text(text)
                .font(AppFont.serif(.subheadline))
                .foregroundStyle(Theme.ink)
                .monospacedDigit()
        }
    }
}
#endif
