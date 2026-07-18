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

    @Environment(AppModel.self) private var model
    @State private var isFlipped = false
    @State private var riff: String?
    @State private var isRiffing = false

    private var fact: NumberFact? {
        metric.kind == .lifeProgress ? nil : FactBank.closest(to: metric.value)
    }

    var body: some View {
        ZStack {
            front
                .opacity(isFlipped ? 0 : 1)
                .rotation3DEffect(.degrees(isFlipped ? 180 : 0), axis: (x: 0, y: 1, z: 0))
            if let fact {
                back(fact: fact)
                    .opacity(isFlipped ? 1 : 0)
                    .rotation3DEffect(.degrees(isFlipped ? 0 : -180), axis: (x: 0, y: 1, z: 0))
            }
        }
        .contentShape(Rectangle())
        .onTapGesture {
            guard fact != nil else { return }
            withAnimation(.spring(duration: 0.5)) { isFlipped.toggle() }
        }
        .accessibilityHint(fact == nil ? "" : "Tap to flip for a real-world comparison")
    }

    private var front: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Image(systemName: metric.symbolName)
                    .font(.title3)
                    .foregroundStyle(pigment)
                Text(metric.title)
                    .font(.subheadline.weight(.medium))
                    .foregroundStyle(Theme.inkSecondary)
                Spacer()
                if fact != nil {
                    Image(systemName: "arrow.2.squarepath")
                        .font(.caption)
                        .foregroundStyle(Theme.faded)
                }
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

    private func back(fact: NumberFact) -> some View {
        let comparison = FactBank.comparison(of: metric.value, with: fact)
        return VStack(alignment: .leading, spacing: 8) {
            HStack {
                Image(systemName: "lightbulb")
                    .font(.title3)
                    .foregroundStyle(pigment)
                Text("For scale")
                    .font(.subheadline.weight(.medium))
                    .foregroundStyle(Theme.inkSecondary)
                Spacer()
                Image(systemName: "arrow.2.squarepath")
                    .font(.caption)
                    .foregroundStyle(Theme.faded)
            }
            Group {
                if let riff {
                    Text(riff)
                } else {
                    Text("Your \(formattedValue) \(metric.unit ?? "") — \(comparison).")
                }
            }
            .font(.system(.subheadline, design: .serif))
            .foregroundStyle(Theme.ink)
            .fixedSize(horizontal: false, vertical: true)

            Text("Source: \(fact.source)")
                .font(.caption2)
                .foregroundStyle(Theme.inkSecondary)

            if ReflectionEngine.isSupported {
                Button {
                    Task { await generateRiff(comparison: comparison) }
                } label: {
                    if isRiffing {
                        ProgressView().controlSize(.small)
                    } else {
                        Label(riff == nil ? "Let Qwen say it" : "Again",
                              systemImage: "sparkles")
                            .font(.caption)
                    }
                }
                .buttonStyle(.bordered)
                .tint(pigment)
                .disabled(isRiffing)
            }
        }
        .padding(16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .paperCard()
    }

    private func generateRiff(comparison: String) async {
        isRiffing = true
        defer { isRiffing = false }
        let prompt = ReflectionPrompt.factRiff(
            metricTitle: metric.title,
            metricValue: "\(formattedValue) \(metric.unit ?? "")",
            comparison: comparison
        )
        if let text = await ReflectionEngine.shared.generate(modelID: model.reflectionModelID, prompt: prompt) {
            riff = text
        }
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
