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
                    // The living watercolor hero, front and center on the
                    // first tab — sand falls, stars drift.
                    Image("OnboardingHero")
                        .resizable()
                        .scaledToFill()
                        .frame(maxWidth: .infinity)
                        .frame(height: 150)
                        .overlay(LoopingVideoView(resourceName: "hero"))
                        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                        .overlay(
                            RoundedRectangle(cornerRadius: 16, style: .continuous)
                                .strokeBorder(Theme.faded, lineWidth: 1)
                        )
                        .accessibilityHidden(true)
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
                .font(AppFont.serif(.title2, .semibold))
                .foregroundStyle(Theme.ink)
            Text("every number below has been counting.")
                .font(AppFont.serif(.subheadline))
                .foregroundStyle(Theme.inkSecondary)
        }
    }
}

struct MetricCardView: View {
    let metric: LifeMetric
    let pigment: Color

    @Environment(AppModel.self) private var model
    @State private var isFlipped = false
    @State private var factOrder: [NumberFact] = []
    @State private var factIndex = 0

    /// Both faces share one height so flipping never makes the grid ragged.
    private static let faceHeight: CGFloat = 128

    private var flippable: Bool { metric.kind != .lifeProgress }

    private var currentFact: NumberFact? {
        factOrder.isEmpty ? nil : factOrder[factIndex % factOrder.count]
    }

    var body: some View {
        ZStack {
            front
                .opacity(isFlipped ? 0 : 1)
                .rotation3DEffect(.degrees(isFlipped ? 180 : 0), axis: (x: 0, y: 1, z: 0))
            if let fact = currentFact {
                back(fact: fact)
                    .opacity(isFlipped ? 1 : 0)
                    .rotation3DEffect(.degrees(isFlipped ? 0 : -180), axis: (x: 0, y: 1, z: 0))
            }
        }
        .contentShape(Rectangle())
        .onTapGesture { flip() }
        .accessibilityHint(flippable ? "Tap to flip for a real-world comparison" : "")
        // Interest/place changed in Settings — clear the stale pool and
        // flip back rather than leaving an empty back face showing.
        .onChange(of: model.interest) { resetFacts() }
        .onChange(of: model.profile.placeOfBirth) { resetFacts() }
    }

    private func resetFacts() {
        factOrder = []
        factIndex = 0
        withAnimation(.spring(duration: 0.5)) {
            isFlipped = false
        }
    }

    private func flip() {
        guard flippable else { return }
        if factOrder.isEmpty {
            // Tailored to the user's interest and home, shuffled so each
            // card starts somewhere different; cycles without repeating.
            factOrder = FactBank.pool(
                for: metric.value,
                interest: model.interest,
                place: model.profile.placeOfBirth
            ).shuffled()
        }
        guard !factOrder.isEmpty else { return }
        withAnimation(.spring(duration: 0.5)) {
            if isFlipped {
                isFlipped = false
            } else {
                // A different fact every time the card turns over.
                factIndex = (factIndex + 1) % factOrder.count
                isFlipped = true
            }
        }
    }

    private var front: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Image(systemName: metric.symbolName)
                    .font(.title3)
                    .foregroundStyle(pigment)
                Text(metric.title)
                    .font(AppFont.serif(.subheadline, .medium))
                    .foregroundStyle(Theme.inkSecondary)
                Spacer()
                if flippable {
                    Image(systemName: "arrow.2.squarepath")
                        .font(AppFont.serif(.caption))
                        .foregroundStyle(Theme.faded)
                }
            }
            Text(formattedValue)
                .font(AppFont.serif(.title, .semibold))
                .foregroundStyle(Theme.ink)
                .contentTransition(.numericText())
                .monospacedDigit()
            Text(metric.detail)
                .font(AppFont.serif(.caption))
                .foregroundStyle(Theme.inkSecondary)
                .fixedSize(horizontal: false, vertical: true)
            Spacer(minLength: 0)
        }
        .padding(16)
        .frame(maxWidth: .infinity, minHeight: Self.faceHeight, alignment: .topLeading)
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
                    .font(AppFont.serif(.subheadline, .medium))
                    .foregroundStyle(Theme.inkSecondary)
                Spacer()
                Image(systemName: "arrow.2.squarepath")
                    .font(AppFont.serif(.caption))
                    .foregroundStyle(Theme.faded)
            }
            Text("Your \(formattedValue) \(metric.unit ?? "") — \(comparison).")
                .font(AppFont.serif(.subheadline))
                .foregroundStyle(Theme.ink)
                .fixedSize(horizontal: false, vertical: true)

            Spacer(minLength: 0)

            Text("Source: \(fact.source)")
                .font(AppFont.serif(.caption2))
                .foregroundStyle(Theme.inkSecondary)
        }
        .padding(16)
        .frame(maxWidth: .infinity, minHeight: Self.faceHeight, alignment: .topLeading)
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
        .tint(Theme.dustyBlue)
}
