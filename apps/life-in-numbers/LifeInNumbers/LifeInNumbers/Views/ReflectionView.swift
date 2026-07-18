import SwiftUI
import LifeMetricsKit

/// A short LLM-written reflection on the user's numbers, generated
/// entirely on-device by an open-source model.
struct ReflectionView: View {
    @Environment(AppModel.self) private var model
    private var engine: ReflectionEngine { .shared }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                VStack(alignment: .leading, spacing: 4) {
                    Text("A word from the machine")
                        .font(.title2.weight(.semibold))
                        .foregroundStyle(Theme.ink)
                    Text("Written on this device by \(model.reflectionModelID), an open-source model. Nothing leaves your \(deviceNoun).")
                        .font(.subheadline)
                        .foregroundStyle(Theme.inkSecondary)
                }

                if !ReflectionEngine.isSupported {
                    unsupportedCard
                } else {
                    reflectionCard
                    generateButton
                }
            }
            .padding()
        }
        .background(Theme.paper)
        .navigationTitle("Reflection")
    }

    private var deviceNoun: String {
        #if os(macOS)
        "Mac"
        #else
        "iPhone"
        #endif
    }

    private var unsupportedCard: some View {
        VStack(alignment: .leading, spacing: 8) {
            Label("Not available here", systemImage: "cpu")
                .font(.headline)
                .foregroundStyle(Theme.ink)
            Text("On-device generation needs Apple silicon and a real device — it doesn't run in the simulator or on Intel Macs.")
                .font(.subheadline)
                .foregroundStyle(Theme.inkSecondary)
        }
        .padding(16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .paperCard()
    }

    @ViewBuilder
    private var reflectionCard: some View {
        VStack(alignment: .leading, spacing: 12) {
            switch engine.phase {
            case .loadingModel(let progress):
                VStack(alignment: .leading, spacing: 8) {
                    Label("Fetching the model", systemImage: "arrow.down.circle")
                        .font(.headline)
                        .foregroundStyle(Theme.ink)
                    if let progress {
                        ProgressView(value: progress)
                            .tint(Theme.dustyBlue)
                        Text("\(Int(progress * 100))% — one-time download, cached for offline use")
                            .font(.caption)
                            .foregroundStyle(Theme.inkSecondary)
                    } else {
                        ProgressView()
                    }
                }
            case .generating:
                HStack(spacing: 10) {
                    ProgressView()
                    Text("Thinking about your \(MetricFormatter.compact(model.calculator.heartbeats(for: model.profile, asOf: .now))) heartbeats…")
                        .font(.subheadline)
                        .foregroundStyle(Theme.inkSecondary)
                }
            case .failed(let message):
                Label(message, systemImage: "exclamationmark.triangle")
                    .font(.subheadline)
                    .foregroundStyle(Theme.terracotta)
            case .idle:
                if let reflection = model.lastReflection {
                    Text(reflection)
                        .font(.system(.body, design: .serif))
                        .foregroundStyle(Theme.ink)
                        .lineSpacing(4)
                        .textSelection(.enabled)
                    if let date = model.lastReflectionDate {
                        Text(date.formatted(date: .abbreviated, time: .shortened))
                            .font(.caption)
                            .foregroundStyle(Theme.inkSecondary)
                    }
                } else {
                    Image("RooftopArt")
                        .resizable()
                        .scaledToFit()
                        .frame(maxHeight: 260)
                        .frame(maxWidth: .infinity)
                        .clipShape(RoundedRectangle(cornerRadius: 12, style: .continuous))
                        .accessibilityLabel("A watercolor dog in a beret watching moons from a rooftop")
                    Text("Your numbers, read back to you as a few sentences. The first run downloads the model (about 300 MB); after that it works offline.")
                        .font(.subheadline)
                        .foregroundStyle(Theme.inkSecondary)
                }
            }
        }
        .padding(16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .paperCard()
    }

    private var generateButton: some View {
        Button {
            Task { await generate() }
        } label: {
            Label(model.lastReflection == nil ? "Write My Reflection" : "Write Another",
                  systemImage: "sparkles")
                .font(.headline)
                .padding(.horizontal, 8)
                .padding(.vertical, 4)
        }
        .buttonStyle(.borderedProminent)
        .disabled(engine.phase == .generating || {
            if case .loadingModel = engine.phase { return true }
            return false
        }())
    }

    private func generate() async {
        let now = Date.now
        let metrics = model.calculator.allMetrics(for: model.profile, asOf: now)
        let milestones = model.milestoneGenerator.upcomingMilestones(for: model.profile, asOf: now)
        let prompt = ReflectionPrompt.system + "\n\n" + ReflectionPrompt.userPrompt(
            profile: model.profile,
            metrics: metrics,
            milestones: milestones,
            asOf: now
        )
        if let text = await engine.generate(modelID: model.reflectionModelID, prompt: prompt) {
            model.lastReflection = text
            model.lastReflectionDate = now
        }
    }
}

#Preview {
    NavigationStack { ReflectionView() }
        .environment(AppModel())
        .fontDesign(.serif)
        .tint(Theme.terracotta)
}
