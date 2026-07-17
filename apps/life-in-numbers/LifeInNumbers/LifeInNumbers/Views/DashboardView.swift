import SwiftUI
import LifeMetricsKit

struct DashboardView: View {
    @Environment(AppModel.self) private var model

    private let columns = [GridItem(.adaptive(minimum: 220, maximum: 340), spacing: 16)]

    var body: some View {
        ScrollView {
            // Ticks once a second so the counting metrics feel alive.
            TimelineView(.periodic(from: .now, by: 1)) { context in
                let metrics = model.calculator.allMetrics(for: model.profile, asOf: context.date)
                VStack(alignment: .leading, spacing: 20) {
                    header(asOf: context.date)
                    LazyVGrid(columns: columns, spacing: 16) {
                        ForEach(Array(metrics.enumerated()), id: \.element.id) { index, metric in
                            MetricCardView(metric: metric, pigment: Theme.pigment(at: index))
                        }
                    }
                }
                .padding()
            }
        }
        .background(Theme.paper)
        .navigationTitle("Numbers")
    }

    private func header(asOf date: Date) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            Text("Since \(model.profile.birthDate.formatted(date: .long, time: .omitted))")
                .font(.title2.weight(.semibold))
                .foregroundStyle(Theme.ink)
            Text("every number below has been counting.")
                .font(.subheadline)
                .foregroundStyle(Theme.inkSecondary)
        }
    }
}

struct MetricCardView: View {
    let metric: LifeMetric
    let pigment: Color

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Image(systemName: metric.symbolName)
                    .font(.title3)
                    .foregroundStyle(pigment)
                Text(metric.title)
                    .font(.subheadline.weight(.medium))
                    .foregroundStyle(Theme.inkSecondary)
                Spacer()
            }
            Text(formattedValue)
                .font(.system(.title, design: .serif).weight(.semibold))
                .foregroundStyle(Theme.ink)
                .contentTransition(.numericText())
                .monospacedDigit()
            Text(metric.detail)
                .font(.caption)
                .foregroundStyle(Theme.inkSecondary)
                .fixedSize(horizontal: false, vertical: true)
        }
        .padding(16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .paperCard()
    }

    private var formattedValue: String {
        if metric.kind == .lifeProgress {
            return String(format: "%.1f%%", metric.value)
        }
        return MetricFormatter.compact(metric.value)
    }
}

#Preview {
    NavigationStack { DashboardView() }
        .environment(AppModel())
        .fontDesign(.serif)
        .tint(Theme.terracotta)
}
